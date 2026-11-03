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

/// Halaman manajemen data pengguna Super Admin (daftar, tambah, edit, dan ubah status).
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

  /// Latest unfiltered snapshot, used to resolve the selected user.
  List<Map<String, dynamic>> _allUsers = const [];

  /// Page count of the currently filtered list.
  int _pageCount = 1;

  @override
  void initState() {
    super.initState();
    _usersStream = widget.usersStream == null
        ? _defaultUsersStream()
        : widget.usersStream!();
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
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Gagal memuat data pengguna'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  _allUsers = snapshot.data!;
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

  Stream<List<Map<String, dynamic>>> _defaultUsersStream() => FirebaseFirestore
      .instance
      .collection('users')
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
      );

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
          final payload = <String, dynamic>{
            'name': name,
            'email': email,
            'role': role,
            'division': division,
            'status': 'aktif',
          };
          final usersRef = FirebaseFirestore.instance.collection('users');
          if (createdUid != null && createdUid.isNotEmpty) {
            await usersRef.doc(createdUid).set(payload);
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
        try {
          final usersRef = FirebaseFirestore.instance.collection('users');
          final payload = <String, dynamic>{
            'name': name,
            'email': email,
            'role': role,
            'division': division,
            'status': status,
            if (password != null && password.isNotEmpty) 'password': password,
          };

          final docId = data['id'] as String?;
          if (docId != null && docId.isNotEmpty) {
            await usersRef.doc(docId).update(payload);
          } else {
            final snap = await usersRef
                .where('email', isEqualTo: initialEmail)
                .limit(1)
                .get();
            if (snap.docs.isNotEmpty) {
              await snap.docs.first.reference.update(payload);
            }
          }
          if (mounted) {
            setState(() {
              _selectedEmail = email;
              _selectedUser = {...data, ...payload};
            });
          }
        } catch (e) {
          debugPrint('Firestore edit user warning: $e');
        }
      },
    );
  }
}
