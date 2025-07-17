import 'dart:convert';

import 'package:style_module/models/design_system.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:style_module/theme/app_colors.dart';
import 'package:style_module/theme/app_dimension.dart';
import 'package:style_module/theme/app_font.dart';
import 'package:style_module/theme/app_radius.dart';
import 'package:style_module/theme/app_spacing.dart';
import 'package:style_module/theme/app_theme.dart';

class ThemeManager {
  static Future<void> loadStyles() async {
    try {
      final String jsonString = await rootBundle.loadString('packages/style_module/assets/styles.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final DesignSystem designSystem = DesignSystem.fromJson(jsonMap);

      AppColors.init(designSystem.sysColor);
      AppDimension.init(designSystem.refDm);
      AppFont.init(designSystem.refTypo);
      AppRadius.init(designSystem.sysDm.radius);
      AppSpacing.init(designSystem.sysDm.spacing);
      AppTheme.init();
    } catch (e) {
      print('Error loading styles: $e');
    }
  }
}