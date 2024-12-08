import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class PersonnelCard extends StatelessWidget {
  PersonnelCard({super.key});
  final ThemeData _appTheme = AppTheme().instance.theme;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: _appTheme.primaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _appTheme.shadowColor)),
        padding: const EdgeInsets.all(2),
        child: const Text(
          'تم بناء هذا التطبيق لاغراض تعليمية وليس لسرقة محتوى الاخرين',
          style: TextStyle(
              color: Color.fromARGB(255, 180, 14, 2),
              fontWeight: FontWeight.w700,
              fontSize: 15),
        ));
  }
}
