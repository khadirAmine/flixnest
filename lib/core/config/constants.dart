import 'package:flutter/material.dart';

import 'theme.dart';

final BoxDecoration itemCardDecoration = BoxDecoration(
  color: AppTheme().instance.theme.colorScheme.secondaryContainer,
  boxShadow: [
    BoxShadow(
      color: AppTheme().instance.theme.shadowColor,
      blurRadius: 2,
      spreadRadius: 2.5,
    )
  ],
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: AppTheme().instance.theme.colorScheme.tertiary,
  ),
);
