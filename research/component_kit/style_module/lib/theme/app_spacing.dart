import 'package:style_module/models/design_system.dart';

// App Spacing
class AppSpacing {
  static late Spacing _spacing;
  static double get blockToBlock => _spacing.blockToBlock;
  static double get cardToCard => _spacing.cardToCard;
  static double get titleToContent => _spacing.titleToContent;
  static double get subTitleToContent => _spacing.subTitleToContent;
  static double get inputForm => _spacing.inputForm;

  static void init(Spacing spacing) {
    _spacing = spacing;
  }
}
