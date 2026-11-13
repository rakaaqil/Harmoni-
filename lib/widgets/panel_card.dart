import 'package:flutter/material.dart';

class PanelCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const PanelCard({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x45000000),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    ),
  );
}
