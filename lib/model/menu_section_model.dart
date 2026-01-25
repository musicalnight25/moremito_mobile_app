import 'package:flutter/material.dart';

/// =========================
/// MODELS
/// =========================
class MenuSection {
  final String title;
  final IconData icon;
  final List<MenuItem> items;

  MenuSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final List<MenuItem>? children;

  MenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.children,
  });
}
