import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart';
import 'value_model.dart';

part 'design_system.g.dart';

@JsonSerializable()
class DesignSystem {
  @JsonKey(name: 'sys-color')
  final SystemColor sysColor;

  @JsonKey(name: 'ref-dm')
  final RefDm refDm;

  @JsonKey(name: 'ref-color')
  final RefColor refColor;

  @JsonKey(name: 'sys-dm')
  final SysDm sysDm;

  @JsonKey(name: 'ref-typo')
  final RefTypo refTypo;

  DesignSystem({
    required this.sysColor,
    required this.refDm,
    required this.refColor,
    required this.sysDm,
    required this.refTypo,
  });

  factory DesignSystem.fromJson(Map<String, dynamic> json) =>
      _$DesignSystemFromJson(json);
  Map<String, dynamic> toJson() => _$DesignSystemToJson(this);
}

@JsonSerializable()
class SystemColor {
  final ThemeColors light;
  final ThemeColors dark;

  SystemColor({required this.light, required this.dark});

  factory SystemColor.fromJson(Map<String, dynamic> json) =>
      _$SystemColorFromJson(json);
  Map<String, dynamic> toJson() => _$SystemColorToJson(this);
}

@JsonSerializable()
class ThemeColors {
  final BackgroundColors background;
  final FixedColors fixed;
  final TextColors text;
  final BorderColors border;
  final IconColors icon;

  ThemeColors({
    required this.background,
    required this.fixed,
    required this.text,
    required this.border,
    required this.icon,
  });

  factory ThemeColors.fromJson(Map<String, dynamic> json) =>
      _$ThemeColorsFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeColorsToJson(this);

  static ThemeColors fromDesignSystem(light) => ThemeColors(
        background: BackgroundColors.fromJson(light['background']),
        fixed: FixedColors.fromJson(light['fixed']),
        text: TextColors.fromJson(light['text']),
        border: BorderColors.fromJson(light['border']),
        icon: IconColors.fromJson(light['icon']),
      );
}

@JsonSerializable()
class BackgroundColors {
  final ColorCategory primary;
  final ColorCategory neutral;
  final ColorCategory secondary;
  final StatusColors status;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color overlay;

  BackgroundColors({
    required this.primary,
    required this.neutral,
    required this.secondary,
    required this.status,
    required this.overlay,
  });

  factory BackgroundColors.fromJson(Map<String, dynamic> json) =>
      _$BackgroundColorsFromJson(json);
  Map<String, dynamic> toJson() => _$BackgroundColorsToJson(this);
}

@JsonSerializable()
class FixedColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color white;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color dark;

  FixedColors({required this.white, required this.dark});

  factory FixedColors.fromJson(Map<String, dynamic> json) =>
      _$FixedColorsFromJson(json);
  Map<String, dynamic> toJson() => _$FixedColorsToJson(this);
}

@JsonSerializable()
class TextColors {
  final TextNeutralColors neutral;
  @JsonKey(name: 'neutral-invert')
  final TextNeutralInvertColors neutralInvert;
  final ColorCategory primary;
  final ColorCategory secondary;
  final StatusColors status;

  TextColors({
    required this.neutral,
    required this.neutralInvert,
    required this.primary,
    required this.secondary,
    required this.status,
  });

  factory TextColors.fromJson(Map<String, dynamic> json) =>
      _$TextColorsFromJson(json);
  Map<String, dynamic> toJson() => _$TextColorsToJson(this);
}

@JsonSerializable()
class TextNeutralColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color disabled;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color muted;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color faded;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color subdued;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color normal;

  TextNeutralColors({
    required this.disabled,
    required this.muted,
    required this.faded,
    required this.subdued,
    required this.normal,
  });

  factory TextNeutralColors.fromJson(Map<String, dynamic> json) =>
      _$TextNeutralColorsFromJson(json);
  Map<String, dynamic> toJson() => _$TextNeutralColorsToJson(this);
}

@JsonSerializable()
class TextNeutralInvertColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color disabled;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color subdued;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color normal;

  TextNeutralInvertColors({
    required this.disabled,
    required this.subdued,
    required this.normal,
  });

  factory TextNeutralInvertColors.fromJson(Map<String, dynamic> json) =>
      _$TextNeutralInvertColorsFromJson(json);
  Map<String, dynamic> toJson() => _$TextNeutralInvertColorsToJson(this);
}

@JsonSerializable()
class BorderColors {
  final BorderNeutralColors neutral;
  @JsonKey(name: 'neutral-invert')
  final BorderNeutralInvertColors neutralInvert;
  final ColorCategory primary;
  final ColorCategory secondary;
  final StatusColors status;

  BorderColors({
    required this.neutral,
    required this.neutralInvert,
    required this.primary,
    required this.secondary,
    required this.status,
  });

  factory BorderColors.fromJson(Map<String, dynamic> json) =>
      _$BorderColorsFromJson(json);
  Map<String, dynamic> toJson() => _$BorderColorsToJson(this);
}

@JsonSerializable()
class BorderNeutralColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color disabled;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color subdued;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color normal;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color accent;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color hover;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color active;

  BorderNeutralColors({
    required this.disabled,
    required this.subdued,
    required this.normal,
    required this.accent,
    required this.hover,
    required this.active,
  });

  factory BorderNeutralColors.fromJson(Map<String, dynamic> json) =>
      _$BorderNeutralColorsFromJson(json);
  Map<String, dynamic> toJson() => _$BorderNeutralColorsToJson(this);
}

@JsonSerializable()
class BorderNeutralInvertColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color disabled;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color subdued;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color normal;

  BorderNeutralInvertColors({
    required this.disabled,
    required this.subdued,
    required this.normal,
  });

  factory BorderNeutralInvertColors.fromJson(Map<String, dynamic> json) =>
      _$BorderNeutralInvertColorsFromJson(json);
  Map<String, dynamic> toJson() => _$BorderNeutralInvertColorsToJson(this);
}

@JsonSerializable()
class IconColors {
  final IconNeutralColors neutral;
  @JsonKey(name: 'neutral-invert')
  final IconNeutralInvertColors neutralInvert;
  final ColorCategory primary;
  final ColorCategory secondary;
  final StatusColors status;

  IconColors({
    required this.neutral,
    required this.neutralInvert,
    required this.primary,
    required this.secondary,
    required this.status,
  });

  factory IconColors.fromJson(Map<String, dynamic> json) =>
      _$IconColorsFromJson(json);
  Map<String, dynamic> toJson() => _$IconColorsToJson(this);
}

@JsonSerializable()
class IconNeutralColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color disabled;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color subdued;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color normal;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color accent;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color hover;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color active;

  IconNeutralColors({
    required this.disabled,
    required this.subdued,
    required this.normal,
    required this.accent,
    required this.hover,
    required this.active,
  });

  factory IconNeutralColors.fromJson(Map<String, dynamic> json) =>
      _$IconNeutralColorsFromJson(json);
  Map<String, dynamic> toJson() => _$IconNeutralColorsToJson(this);
}

@JsonSerializable()
class IconNeutralInvertColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color disabled;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color subdued;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color normal;

  IconNeutralInvertColors({
    required this.disabled,
    required this.subdued,
    required this.normal,
  });

  factory IconNeutralInvertColors.fromJson(Map<String, dynamic> json) =>
      _$IconNeutralInvertColorsFromJson(json);
  Map<String, dynamic> toJson() => _$IconNeutralInvertColorsToJson(this);
}

@JsonSerializable()
class ColorCategory {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color subdued;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color normal;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color accent;

  ColorCategory({
    required this.subdued,
    required this.normal,
    required this.accent,
  });

  factory ColorCategory.fromJson(Map<String, dynamic> json) =>
      _$ColorCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ColorCategoryToJson(this);
}

@JsonSerializable()
class StatusColors {
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color positive;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color negative;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color warning;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color informative;

  StatusColors({
    required this.positive,
    required this.negative,
    required this.warning,
    required this.informative,
  });

  factory StatusColors.fromJson(Map<String, dynamic> json) =>
      _$StatusColorsFromJson(json);
  Map<String, dynamic> toJson() => _$StatusColorsToJson(this);
}

@JsonSerializable()
class RefDm {
  @JsonKey(name: 'dm-2', fromJson: doubleFromJson)
  final double dm2;
  @JsonKey(name: 'dm-4', fromJson: doubleFromJson)
  final double dm4;
  @JsonKey(name: 'dm-8', fromJson: doubleFromJson)
  final double dm8;
  @JsonKey(name: 'dm-10', fromJson: doubleFromJson)
  final double dm10;
  @JsonKey(name: 'dm-12', fromJson: doubleFromJson)
  final double dm12;
  @JsonKey(name: 'dm-14', fromJson: doubleFromJson)
  final double dm14;
  @JsonKey(name: 'dm-16', fromJson: doubleFromJson)
  final double dm16;
  @JsonKey(name: 'dm-18', fromJson: doubleFromJson)
  final double dm18;
  @JsonKey(name: 'dm-20', fromJson: doubleFromJson)
  final double dm20;
  @JsonKey(name: 'dm-24', fromJson: doubleFromJson)
  final double dm24;
  @JsonKey(name: 'dm-28', fromJson: doubleFromJson)
  final double dm28;
  @JsonKey(name: 'dm-32', fromJson: doubleFromJson)
  final double dm32;
  @JsonKey(name: 'dm-36', fromJson: doubleFromJson)
  final double dm36;
  @JsonKey(name: 'dm-40', fromJson: doubleFromJson)
  final double dm40;
  @JsonKey(name: 'dm-44', fromJson: doubleFromJson)
  final double dm44;
  @JsonKey(name: 'dm-48', fromJson: doubleFromJson)
  final double dm48;
  @JsonKey(name: 'dm-52', fromJson: doubleFromJson)
  final double dm52;
  @JsonKey(name: 'dm-56', fromJson: doubleFromJson)
  final double dm56;
  @JsonKey(name: 'dm-64', fromJson: doubleFromJson)
  final double dm64;
  @JsonKey(name: 'dm-72', fromJson: doubleFromJson)
  final double dm72;
  @JsonKey(name: 'dm-80', fromJson: doubleFromJson)
  final double dm80;
  @JsonKey(name: 'dm-88', fromJson: doubleFromJson)
  final double dm88;
  @JsonKey(name: 'dm-96', fromJson: doubleFromJson)
  final double dm96;
  @JsonKey(name: 'dm-112', fromJson: doubleFromJson)
  final double dm112;
  @JsonKey(name: 'dm-128', fromJson: doubleFromJson)
  final double dm128;
  @JsonKey(name: 'dm-144', fromJson: doubleFromJson)
  final double dm144;
  @JsonKey(name: 'dm-160', fromJson: doubleFromJson)
  final double dm160;
  @JsonKey(name: 'dm-184', fromJson: doubleFromJson)
  final double dm184;
  @JsonKey(name: 'dm-200', fromJson: doubleFromJson)
  final double dm200;
  @JsonKey(name: 'dm-240', fromJson: doubleFromJson)
  final double dm240;
  @JsonKey(name: 'dm-1000', fromJson: doubleFromJson)
  final double dm1000;

  RefDm({
    required this.dm2,
    required this.dm4,
    required this.dm8,
    required this.dm10,
    required this.dm12,
    required this.dm14,
    required this.dm16,
    required this.dm18,
    required this.dm20,
    required this.dm24,
    required this.dm28,
    required this.dm32,
    required this.dm36,
    required this.dm40,
    required this.dm44,
    required this.dm48,
    required this.dm52,
    required this.dm56,
    required this.dm64,
    required this.dm72,
    required this.dm80,
    required this.dm88,
    required this.dm96,
    required this.dm112,
    required this.dm128,
    required this.dm144,
    required this.dm160,
    required this.dm184,
    required this.dm200,
    required this.dm240,
    required this.dm1000,
  });

  factory RefDm.fromJson(Map<String, dynamic> json) => _$RefDmFromJson(json);
  Map<String, dynamic> toJson() => _$RefDmToJson(this);
}

@JsonSerializable()
class RefColor {
  final ColorScale primary;
  final ColorScale secondary;
  final ColorScale tertiary;
  final NeutralColorScale neutral;
  final StatusColorScales status;
  final AlphaScales alpha;
  final RootColors root;

  RefColor({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutral,
    required this.status,
    required this.alpha,
    required this.root,
  });

  factory RefColor.fromJson(Map<String, dynamic> json) =>
      _$RefColorFromJson(json);
  Map<String, dynamic> toJson() => _$RefColorToJson(this);
}

@JsonSerializable()
class ColorScale {
  @JsonKey(name: "100", fromJson: colorFromJson, toJson: colorToJson)
  final Color n100;
  @JsonKey(name: "200", fromJson: colorFromJson, toJson: colorToJson)
  final Color n200;
  @JsonKey(name: "300", fromJson: colorFromJson, toJson: colorToJson)
  final Color n300;
  @JsonKey(name: "400", fromJson: colorFromJson, toJson: colorToJson)
  final Color n400;
  @JsonKey(name: "500", fromJson: colorFromJson, toJson: colorToJson)
  final Color n500;
  @JsonKey(name: "600", fromJson: colorFromJson, toJson: colorToJson)
  final Color n600;
  @JsonKey(name: "700", fromJson: colorFromJson, toJson: colorToJson)
  final Color n700;
  @JsonKey(name: "800", fromJson: colorFromJson, toJson: colorToJson)
  final Color n800;
  @JsonKey(name: "900", fromJson: colorFromJson, toJson: colorToJson)
  final Color n900;

  ColorScale({
    required this.n100,
    required this.n200,
    required this.n300,
    required this.n400,
    required this.n500,
    required this.n600,
    required this.n700,
    required this.n800,
    required this.n900,
  });

  factory ColorScale.fromJson(Map<String, dynamic> json) =>
      _$ColorScaleFromJson(json);
  Map<String, dynamic> toJson() => _$ColorScaleToJson(this);
}

@JsonSerializable()
class NeutralColorScale {
  @JsonKey(name: "0", fromJson: colorFromJson, toJson: colorToJson)
  final Color n0;
  @JsonKey(name: "100", fromJson: colorFromJson, toJson: colorToJson)
  final Color n100;
  @JsonKey(name: "200", fromJson: colorFromJson, toJson: colorToJson)
  final Color n200;
  @JsonKey(name: "300", fromJson: colorFromJson, toJson: colorToJson)
  final Color n300;
  @JsonKey(name: "400", fromJson: colorFromJson, toJson: colorToJson)
  final Color n400;
  @JsonKey(name: "500", fromJson: colorFromJson, toJson: colorToJson)
  final Color n500;
  @JsonKey(name: "600", fromJson: colorFromJson, toJson: colorToJson)
  final Color n600;
  @JsonKey(name: "700", fromJson: colorFromJson, toJson: colorToJson)
  final Color n700;
  @JsonKey(name: "800", fromJson: colorFromJson, toJson: colorToJson)
  final Color n800;
  @JsonKey(name: "900", fromJson: colorFromJson, toJson: colorToJson)
  final Color n900;

  NeutralColorScale({
    required this.n0,
    required this.n100,
    required this.n200,
    required this.n300,
    required this.n400,
    required this.n500,
    required this.n600,
    required this.n700,
    required this.n800,
    required this.n900,
  });

  factory NeutralColorScale.fromJson(Map<String, dynamic> json) =>
      _$NeutralColorScaleFromJson(json);
  Map<String, dynamic> toJson() => _$NeutralColorScaleToJson(this);
}

@JsonSerializable()
class StatusColorScales {
  final ColorScale positive;
  final ColorScale negative;
  final ColorScale warning;
  final ColorScale informative;

  StatusColorScales({
    required this.positive,
    required this.negative,
    required this.warning,
    required this.informative,
  });

  factory StatusColorScales.fromJson(Map<String, dynamic> json) =>
      _$StatusColorScalesFromJson(json);
  Map<String, dynamic> toJson() => _$StatusColorScalesToJson(this);
}

@JsonSerializable()
class AlphaScales {
  final AlphaScale white;
  final AlphaScale black;
  final AlphaScale primary;
  final AlphaScale secondary;
  final AlphaScale tertiary;
  @JsonKey(name: 'status-negative')
  final AlphaScale statusNegative;
  @JsonKey(name: 'status-positive')
  final AlphaScale statusPositive;

  AlphaScales({
    required this.white,
    required this.black,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.statusNegative,
    required this.statusPositive,
  });

  factory AlphaScales.fromJson(Map<String, dynamic> json) =>
      _$AlphaScalesFromJson(json);
  Map<String, dynamic> toJson() => _$AlphaScalesToJson(this);
}

@JsonSerializable()
class AlphaScale {
  @JsonKey(name: "0", fromJson: colorFromJson, toJson: colorToJson)
  final Color n0;
  @JsonKey(name: "10", fromJson: colorFromJson, toJson: colorToJson)
  final Color n10;
  @JsonKey(name: "20", fromJson: colorFromJson, toJson: colorToJson)
  final Color n20;
  @JsonKey(name: "30", fromJson: colorFromJson, toJson: colorToJson)
  final Color n30;
  @JsonKey(name: "40", fromJson: colorFromJson, toJson: colorToJson)
  final Color n40;
  @JsonKey(name: "50", fromJson: colorFromJson, toJson: colorToJson)
  final Color n50;
  @JsonKey(name: "60", fromJson: colorFromJson, toJson: colorToJson)
  final Color n60;
  @JsonKey(name: "70", fromJson: colorFromJson, toJson: colorToJson)
  final Color n70;
  @JsonKey(name: "80", fromJson: colorFromJson, toJson: colorToJson)
  final Color n80;
  @JsonKey(name: "90", fromJson: colorFromJson, toJson: colorToJson)
  final Color n90;

  AlphaScale({
    required this.n0,
    required this.n10,
    required this.n20,
    required this.n30,
    required this.n40,
    required this.n50,
    required this.n60,
    required this.n70,
    required this.n80,
    required this.n90,
  });

  factory AlphaScale.fromJson(Map<String, dynamic> json) =>
      _$AlphaScaleFromJson(json);
  Map<String, dynamic> toJson() => _$AlphaScaleToJson(this);
}

@JsonSerializable()
class RootColors {
  final ValueModel primary;
  final ValueModel secondary;
  final ValueModel tertiary;

  RootColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  factory RootColors.fromJson(Map<String, dynamic> json) =>
      _$RootColorsFromJson(json);
  Map<String, dynamic> toJson() => _$RootColorsToJson(this);
}

@JsonSerializable()
class SysDm {
  final DesignRadius radius;
  final Grid grid;
  final Spacing spacing;
  final Padding padding;

  SysDm({
    required this.radius,
    required this.grid,
    required this.spacing,
    required this.padding,
  });

  factory SysDm.fromJson(Map<String, dynamic> json) => _$SysDmFromJson(json);
  Map<String, dynamic> toJson() => _$SysDmToJson(this);
}

@JsonSerializable()
class DesignRadius {
  @JsonKey(fromJson: doubleFromJson)
  final double card;
  @JsonKey(fromJson: doubleFromJson)
  final double button;
  @JsonKey(fromJson: doubleFromJson)
  final double input;
  @JsonKey(fromJson: doubleFromJson)
  final double badge;
  @JsonKey(name: 'chip,-tag', fromJson: doubleFromJson)
  final double chipTag;

  DesignRadius({
    required this.card,
    required this.button,
    required this.input,
    required this.badge,
    required this.chipTag,
  });

  factory DesignRadius.fromJson(Map<String, dynamic> json) =>
      _$DesignRadiusFromJson(json);
  Map<String, dynamic> toJson() => _$DesignRadiusToJson(this);
}

@JsonSerializable()
class Grid {
  @JsonKey(name: 'home-screen')
  final ScreenGrid homeScreen;
  @JsonKey(name: 'child-screen')
  final ScreenGrid childScreen;

  Grid({
    required this.homeScreen,
    required this.childScreen,
  });

  factory Grid.fromJson(Map<String, dynamic> json) => _$GridFromJson(json);
  Map<String, dynamic> toJson() => _$GridToJson(this);
}

@JsonSerializable()
class ScreenGrid {
  @JsonKey(name: 'margin-t-b', fromJson: doubleFromJson)
  final double marginTB;
  @JsonKey(name: 'margin-l-r', fromJson: doubleFromJson)
  final double marginLR;
  @JsonKey(fromJson: doubleFromJson)
  final double gutter;

  ScreenGrid({
    required this.marginTB,
    required this.marginLR,
    required this.gutter,
  });

  factory ScreenGrid.fromJson(Map<String, dynamic> json) =>
      _$ScreenGridFromJson(json);
  Map<String, dynamic> toJson() => _$ScreenGridToJson(this);
}

@JsonSerializable()
class Spacing {
  @JsonKey(name: 'block-to-block', fromJson: doubleFromJson)
  final double blockToBlock;
  @JsonKey(name: 'card-to-card', fromJson: doubleFromJson)
  final double cardToCard;
  @JsonKey(name: 'title-to-content', fromJson: doubleFromJson)
  final double titleToContent;
  @JsonKey(name: 'sub-title-to-content', fromJson: doubleFromJson)
  final double subTitleToContent;
  @JsonKey(name: 'input-form', fromJson: doubleFromJson)
  final double inputForm;

  Spacing({
    required this.blockToBlock,
    required this.cardToCard,
    required this.titleToContent,
    required this.subTitleToContent,
    required this.inputForm,
  });

  factory Spacing.fromJson(Map<String, dynamic> json) =>
      _$SpacingFromJson(json);
  Map<String, dynamic> toJson() => _$SpacingToJson(this);
}

@JsonSerializable()
class Padding {
  @JsonKey(name: 'in-card', fromJson: doubleFromJson)
  final double inCard;
  @JsonKey(name: 'in-bottom-sheet', fromJson: doubleFromJson)
  final double inBottomSheet;

  Padding({
    required this.inCard,
    required this.inBottomSheet,
  });

  factory Padding.fromJson(Map<String, dynamic> json) =>
      _$PaddingFromJson(json);
  Map<String, dynamic> toJson() => _$PaddingToJson(this);
}

@JsonSerializable()
class RefTypo {
  @JsonKey(name: 'font-familiy')
  final FontFamily fontFamily;
  @JsonKey(name: 'font-weight')
  final DesignFontWeight fontWeight;

  RefTypo({
    required this.fontFamily,
    required this.fontWeight,
  });

  factory RefTypo.fromJson(Map<String, dynamic> json) =>
      _$RefTypoFromJson(json);
  Map<String, dynamic> toJson() => _$RefTypoToJson(this);
}

@JsonSerializable()
class FontFamily {
  @JsonKey(fromJson: fontNameFromJson)
  final String title;
  @JsonKey(fromJson: fontNameFromJson)
  final String body;

  FontFamily({
    required this.title,
    required this.body,
  });

  factory FontFamily.fromJson(Map<String, dynamic> json) =>
      _$FontFamilyFromJson(json);
  Map<String, dynamic> toJson() => _$FontFamilyToJson(this);
}

@JsonSerializable()
class DesignFontWeight {
  final ValueModel regular;
  final ValueModel italic;
  @JsonKey(name: 'black-italic')
  final ValueModel blackItalic;
  final ValueModel medium;
  @JsonKey(name: 'medium-italic')
  final ValueModel mediumItalic;

  DesignFontWeight({
    required this.regular,
    required this.italic,
    required this.blackItalic,
    required this.medium,
    required this.mediumItalic,
  });

  factory DesignFontWeight.fromJson(Map<String, dynamic> json) =>
      _$DesignFontWeightFromJson(json);
  Map<String, dynamic> toJson() => _$DesignFontWeightToJson(this);
}
