import 'package:style_module/models/design_system.dart';

// App Font
class AppFont {
  static late RefTypo _refTypo;

  static RefTypo get refTypo => _refTypo;

  static void init(RefTypo refTypo) {
    _refTypo = refTypo;
  }
}
