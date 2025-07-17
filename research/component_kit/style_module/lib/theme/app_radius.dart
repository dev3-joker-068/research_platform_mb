import 'package:style_module/models/design_system.dart';

// App Radius
class AppRadius {
  static late DesignRadius _designRadius;
  static double get card => _designRadius.card;
  static double get button => _designRadius.button;
  static double get input => _designRadius.input;
  static double get badge => _designRadius.badge;
  static double get chipTag => _designRadius.chipTag;

  static void init(DesignRadius designRadius) {
    _designRadius = designRadius;
  }
}
