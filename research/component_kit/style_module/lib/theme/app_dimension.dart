import 'package:style_module/models/design_system.dart';

// App Dimension
class AppDimension {
  static late RefDm _dimension;
  static double get dm2 => _dimension.dm2;
  static double get dm4 => _dimension.dm4;
  static double get dm8 => _dimension.dm8;
  static double get dm10 => _dimension.dm10;
  static double get dm12 => _dimension.dm12;
  static double get dm14 => _dimension.dm14;
  static double get dm16 => _dimension.dm16;
  static double get dm18 => _dimension.dm18;
  static double get dm20 => _dimension.dm20;
  static double get dm24 => _dimension.dm24;
  static double get dm28 => _dimension.dm28;
  static double get dm32 => _dimension.dm32;
  static double get dm36 => _dimension.dm36;
  static double get dm40 => _dimension.dm40;
  static double get dm44 => _dimension.dm44;
  static double get dm48 => _dimension.dm48;
  static double get dm52 => _dimension.dm52;
  static double get dm56 => _dimension.dm56;
  static double get dm64 => _dimension.dm64;
  static double get dm72 => _dimension.dm72;
  static double get dm80 => _dimension.dm80;
  static double get dm88 => _dimension.dm88;
  static double get dm96 => _dimension.dm96;
  static double get dm112 => _dimension.dm112;
  static double get dm128 => _dimension.dm128;
  static double get dm144 => _dimension.dm144;
  static double get dm160 => _dimension.dm160;
  static double get dm184 => _dimension.dm184;
  static double get dm200 => _dimension.dm200;
  static double get dm240 => _dimension.dm240;
  static double get dm1000 => _dimension.dm1000;

  static void init(RefDm dimension) {
    _dimension = dimension;
  }
}
