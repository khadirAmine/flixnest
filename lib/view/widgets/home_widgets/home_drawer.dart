import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: AppTheme().instance.theme.colorScheme.secondary);
  }
}
