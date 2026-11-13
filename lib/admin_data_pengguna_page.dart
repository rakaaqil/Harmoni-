import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'constants/user_options.dart';
import 'login_page.dart';
import 'widgets/admin/admin_action_bar.dart';
import 'widgets/admin/admin_filter_sheet.dart';
import 'widgets/admin/admin_search_bar.dart';
import 'widgets/admin/user_form_sheet.dart';
import 'widgets/admin/user_table.dart';

class AdminDataPenggunaPage extends StatefulWidget {
  /// Optional seam for tests; defaults to live Firestore query.
  final Stream<List<Map<String, dynamic>>>? Function()? usersStream;
  const AdminDataPenggunaPage({super.key, this.usersStream});

  @override
  State<AdminDataPenggunaPage> createState() => _AdminDataPenggunaPageState();
}

class _AdminDataPenggunaPageState extends State<AdminDataPenggunaPage> {
  final _search = TextEditingController();
  String? _filterRole;
  String? _filterDivision;
  String? _filterStatus;
  String? _selectedEmail;
  Map<String, dynamic>? _selectedUser;
  int _page = 0;

  late final Stream<List<Map<String, dynamic>>>? _usersStream;

  /// Seeded Firebase Auth users + locally added/edited users.
  final List<Map<String, dynamic>> _localUsers = [
    for (final u in defaultFirebaseUsers) Map<String, dynamic>.from(u),
  ];

  /// In-memory overrides applied when a user is edited or added in this session.
  final Map<String, Map<String, dynamic>> _sessionEdits = {};
  final List<Map<String, dynamic>> _sessionAdded = [];

  /// Latest unfiltered snapshot, used to resolve the selected user.
  List<Map<String, dynamic>> _allUsers = const [];

  /// Page count of the currently filtered list.
  int _pageCount = 1;

  @override
  void initState() {
    super.initState();
    if (widget.usersStream == null) {
      _usersStream = _defaultUsersStream();
      _ensureDefaultUsersInFirestore();
    } else {
      _usersStream = widget.usersStream!();
    }
  }

  Future<void> _ensureDefaultUsersInFirestore() async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');
      final snap = await usersRef.get();
      final existingEmails = <String>{};
      for (final doc in snap.docs) {
        final email = extractUserEmail(doc.data()).toLowerCase();
        if (email.isNotEmpty) existingEmails.add(email);
      }
      for (final seed in defaultFirebaseUsers) {
        final email = extractUserEmail(seed).toLowerCase();
        if (email.isNotEmpty && !existingEmails.contains(email)) {
          final docId = seed['id']?.toString() ?? email;
          final payload = <String, dynamic>{
            'name': seed['name'],
            'email': seed['email'],
            'role': seed['role'],
            'division': seed['division'],
            'status': seed['status'] ?? 'aktif',
          };
          await usersRef.doc(docId).set(payload, SetOptions(merge: true));
        }
      }
    } catch (e) {
      debugPrint('Auto-seed default Firebase users warning: $e');
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: AdminSearchBar(
                controller: _search,
                onChanged: (_) => setState(() => _page = 0),
                onFilter: _openFilter,
                filterActive:
                    _filterRole != null ||
                    _filterDivision != null ||
                    _filterStatus != null,
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (widget.usersStream != null) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Gagal memuat data pengguna'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    _allUsers = _mergeUsers(
                      baseUsers: snapshot.data!,
                      remoteUsers: const [],
                    );
                  } else {
                    _allUsers = _mergeUsers(
                      baseUsers: _localUsers,
                      remoteUsers: snapshot.data ?? const [],
                    );
                  }
                  final users = _applyFilters(_allUsers);
                  _pageCount = UserTable.pageCountFor(users.length);
                  final page = _page.clamp(0, _pageCount - 1);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: UserTable(
                      users: users,
                      page: page,
                      selectedEmail: _selectedEmail,
                      onSelect: _onRowTap,
                      onPrev: () => _goToPage(page - 1),
                      onNext: () => _goToPage(page + 1),
                    ),
                  );
                },
              ),
            ),
            AdminActionBar(onEdit: _onEditPressed, onAdd: _addUser),
          ],
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _defaultUsersStream() {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map(
            (snap) => snap.docs
                .map((d) => <String, dynamic>{'id': d.id, ...d.data()})
                .toList(),
          );
    } catch (_) {
      return Stream.value(_localUsers);
    }
  }

  List<Map<String, dynamic>> _mergeUsers({
    required List<Map<String, dynamic>> baseUsers,
    required List<Map<String, dynamic>> remoteUsers,
  }) {
    final merged = <Map<String, dynamic>>[
      for (final u in baseUsers) Map<String, dynamic>.from(u),
    ];

    for (final remote in remoteUsers) {
      final remoteEmail = extractUserEmail(remote).toLowerCase();
      final remoteId = remote['id']?.toString();
      final index = merged.indexWhere((item) {
        final itemEmail = extractUserEmail(item).toLowerCase();
        final itemId = item['id']?.toString();
        return (remoteEmail.isNotEmpty && itemEmail == remoteEmail) ||
            (remoteId != null && remoteId.isNotEmpty && itemId == remoteId);
      });
      if (index >= 0) {
        merged[index] = {...merged[index], ...remote};
      } else {
        merged.add(Map<String, dynamic>.from(remote));
      }
    }

    for (var i = 0; i < merged.length; i++) {
      final item = merged[i];
      final keyById = item['id']?.toString();
      final keyByEmail = extractUserEmail(item).toLowerCase();
      final edit = (keyById != null ? _sessionEdits[keyById] : null) ??
          (keyByEmail.isNotEmpty ? _sessionEdits[keyByEmail] : null);
      if (edit != null) {
        merged[i] = {...item, ...edit};
      }
    }

    for (final added in _sessionAdded) {
      final addedEmail = extractUserEmail(added).toLowerCase();
      final exists = merged.any(
        (u) => extractUserEmail(u).toLowerCase() == addedEmail,
      );
      if (!exists) {
        merged.add(Map<String, dynamic>.from(added));
      }
    }

    return merged;
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> all) {
    final query = _search.text.trim().toLowerCase();
    return all.where((data) {
      final email = extractUserEmail(data);
      final name = extractUserName(data);
      final role = extractUserRole(data);
      final division = extractUserDivision(data) ?? '';
      if (query.isNotEmpty &&
          !email.toLowerCase().contains(query) &&
          !name.toLowerCase().contains(query)) {
        return false;
      }
      if (_filterRole != null && role != _filterRole) {
        return false;
      }
      if (_filterDivision != null && division != _filterDivision) {
        return false;
      }
      if (_filterStatus != null &&
          normalizeStatus(data['status']) != _filterStatus) {
        return false;
      }
      return true;
    }).toList();
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _pageCount) return;
    setState(() => _page = page);
  }

  void _onRowTap(Map<String, dynamic> data) {
    final email = extractUserEmail(data);
    setState(() {
      _selectedEmail = email;
      _selectedUser = data;
    });
    _editUser(data);
  }

  void _openFilter() => showAdminFilterSheet(
    context: context,
    role: _filterRole,
    division: _filterDivision,
    status: _filterStatus,
    onChanged: (role, division, status) => setState(() {
      _filterRole = role;
      _filterDivision = division;
      _filterStatus = status;
      _page = 0;
    }),
  );

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Widget _header() => Container(
    width: double.infinity,
    height: 66,
    color: Colors.white,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 30,
          child: InkResponse(
            key: const ValueKey('admin-logout'),
            onTap: _logout,
            radius: 22,
            child: Container(
              width: 41,
              height: 41,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 22,
                color: AppColors.logoutRed,
              ),
            ),
          ),
        ),
        const Text(
          'Data Pengguna',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: -0.4,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );

  void _onEditPressed() {
    final email = _selectedEmail;
    Map<String, dynamic>? selected = _selectedUser;
    if (email != null && email.isNotEmpty) {
      for (final u in _allUsers) {
        if (extractUserEmail(u) == email) {
          selected = u;
          break;
        }
      }
    }
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih pengguna di tabel terlebih dahulu'),
        ),
      );
      return;
    }
    _editUser(selected);
  }

  void _addUser() {
    showUserFormSheet(
      context: context,
      title: 'Tambah Pengguna',
      isEdit: false,
      onSave: (name, email, role, division, status, [password]) async {
        final payload = <String, dynamic>{
          'name': name,
          'email': email,
          'role': role,
          'division': division,
          'status': 'aktif',
        };

        if (mounted) {
          setState(() {
            final lowerEmail = email.toLowerCase();
            final idx = _localUsers.indexWhere(
              (u) => extractUserEmail(u).toLowerCase() == lowerEmail,
            );
            if (idx >= 0) {
              _localUsers[idx] = {..._localUsers[idx], ...payload};
            } else {
              _localUsers.add(Map<String, dynamic>.from(payload));
            }
            _sessionAdded.removeWhere(
              (u) => extractUserEmail(u).toLowerCase() == lowerEmail,
            );
            _sessionAdded.add(Map<String, dynamic>.from(payload));
          });
        }

        String? createdUid;
        if (password != null && password.isNotEmpty) {
          try {
            final app = await Firebase.initializeApp(
              name: 'admin_create_${DateTime.now().millisecondsSinceEpoch}',
              options: Firebase.app().options,
            );
            try {
              final cred = await FirebaseAuth.instanceFor(app: app)
                  .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
              createdUid = cred.user?.uid;
            } finally {
              await app.delete();
            }
          } catch (e) {
            debugPrint('Secondary FirebaseAuth user creation warning: $e');
          }
        }

        try {
          final usersRef = FirebaseFirestore.instance.collection('users');
          if (createdUid != null && createdUid.isNotEmpty) {
            await usersRef.doc(createdUid).set(payload, SetOptions(merge: true));
          } else {
            await usersRef.add(payload);
          }
        } catch (e) {
          debugPrint('Firestore add user warning: $e');
        }
      },
    );
  }

  void _editUser(Map<String, dynamic> data) {
    final initialName = extractUserName(data);
    final initialEmail = extractUserEmail(data);
    final initialRole = extractUserRole(data);
    final initialDivision = extractUserDivision(data);
    final initialStatus = normalizeStatus(data['status']);

    showUserFormSheet(
      context: context,
      title: 'Edit Pengguna',
      isEdit: true,
      initialName: initialName,
      initialEmail: initialEmail,
      initialRole: initialRole,
      initialDivision: initialDivision,
      initialStatus: initialStatus,
      onSave: (name, email, role, division, status, [password]) async {
        final payload = <String, dynamic>{
          'name': name,
          'email': email,
          'role': role,
          'division': division,
          'status': status,
          if (password != null && password.isNotEmpty) 'password': password,
        };
        final docId = data['id'] as String?;

        if (mounted) {
          setState(() {
            final lowerInitial = initialEmail.toLowerCase();
            if (docId != null && docId.isNotEmpty) {
              _sessionEdits[docId] = {...data, ...payload};
            }
            if (lowerInitial.isNotEmpty) {
              _sessionEdits[lowerInitial] = {...data, ...payload};
            }
            if (email.toLowerCase() != lowerInitial) {
              _sessionEdits[email.toLowerCase()] = {...data, ...payload};
            }
            final idx = _localUsers.indexWhere((u) {
              final uEmail = extractUserEmail(u).toLowerCase();
              final uId = u['id']?.toString();
              return (lowerInitial.isNotEmpty && uEmail == lowerInitial) ||
                  (docId != null && docId.isNotEmpty && uId == docId);
            });
            if (idx >= 0) {
              _localUsers[idx] = {..._localUsers[idx], ...payload};
            }
            _selectedEmail = email;
            _selectedUser = {...data, ...payload};
          });
        }

        try {
          final usersRef = FirebaseFirestore.instance.collection('users');
          if (docId != null && docId.isNotEmpty) {
            await usersRef.doc(docId).set(payload, SetOptions(merge: true));
          } else {
            final snap = await usersRef
                .where('email', isEqualTo: initialEmail)
                .limit(1)
                .get();
            if (snap.docs.isNotEmpty) {
              await snap.docs.first.reference.set(
                payload,
                SetOptions(merge: true),
              );
            } else {
              await usersRef.add(payload);
            }
          }
        } catch (e) {
          debugPrint('Firestore edit user warning: $e');
        }
      },
    );
  }
}
