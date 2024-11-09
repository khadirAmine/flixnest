import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class HomeDrawer extends Drawer {
  HomeDrawer({super.key})
      : super(backgroundColor: AppTheme().instance.theme.colorScheme.secondary);
}
