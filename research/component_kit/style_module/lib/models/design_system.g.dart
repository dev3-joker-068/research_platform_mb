// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignSystem _$DesignSystemFromJson(Map<String, dynamic> json) => DesignSystem(
      sysColor: SystemColor.fromJson(json['sys-color'] as Map<String, dynamic>),
      refDm: RefDm.fromJson(json['ref-dm'] as Map<String, dynamic>),
      refColor: RefColor.fromJson(json['ref-color'] as Map<String, dynamic>),
      sysDm: SysDm.fromJson(json['sys-dm'] as Map<String, dynamic>),
      refTypo: RefTypo.fromJson(json['ref-typo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DesignSystemToJson(DesignSystem instance) =>
    <String, dynamic>{
      'sys-color': instance.sysColor,
      'ref-dm': instance.refDm,
      'ref-color': instance.refColor,
      'sys-dm': instance.sysDm,
      'ref-typo': instance.refTypo,
    };

SystemColor _$SystemColorFromJson(Map<String, dynamic> json) => SystemColor(
      light: ThemeColors.fromJson(json['light'] as Map<String, dynamic>),
      dark: ThemeColors.fromJson(json['dark'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SystemColorToJson(SystemColor instance) =>
    <String, dynamic>{
      'light': instance.light,
      'dark': instance.dark,
    };

ThemeColors _$ThemeColorsFromJson(Map<String, dynamic> json) => ThemeColors(
      background:
          BackgroundColors.fromJson(json['background'] as Map<String, dynamic>),
      fixed: FixedColors.fromJson(json['fixed'] as Map<String, dynamic>),
      text: TextColors.fromJson(json['text'] as Map<String, dynamic>),
      border: BorderColors.fromJson(json['border'] as Map<String, dynamic>),
      icon: IconColors.fromJson(json['icon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThemeColorsToJson(ThemeColors instance) =>
    <String, dynamic>{
      'background': instance.background,
      'fixed': instance.fixed,
      'text': instance.text,
      'border': instance.border,
      'icon': instance.icon,
    };

BackgroundColors _$BackgroundColorsFromJson(Map<String, dynamic> json) =>
    BackgroundColors(
      primary: ColorCategory.fromJson(json['primary'] as Map<String, dynamic>),
      neutral: ColorCategory.fromJson(json['neutral'] as Map<String, dynamic>),
      secondary:
          ColorCategory.fromJson(json['secondary'] as Map<String, dynamic>),
      status: StatusColors.fromJson(json['status'] as Map<String, dynamic>),
      overlay: colorFromJson(json['overlay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BackgroundColorsToJson(BackgroundColors instance) =>
    <String, dynamic>{
      'primary': instance.primary,
      'neutral': instance.neutral,
      'secondary': instance.secondary,
      'status': instance.status,
      'overlay': colorToJson(instance.overlay),
    };

FixedColors _$FixedColorsFromJson(Map<String, dynamic> json) => FixedColors(
      white: colorFromJson(json['white'] as Map<String, dynamic>),
      dark: colorFromJson(json['dark'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FixedColorsToJson(FixedColors instance) =>
    <String, dynamic>{
      'white': colorToJson(instance.white),
      'dark': colorToJson(instance.dark),
    };

TextColors _$TextColorsFromJson(Map<String, dynamic> json) => TextColors(
      neutral:
          TextNeutralColors.fromJson(json['neutral'] as Map<String, dynamic>),
      neutralInvert: TextNeutralInvertColors.fromJson(
          json['neutral-invert'] as Map<String, dynamic>),
      primary: ColorCategory.fromJson(json['primary'] as Map<String, dynamic>),
      secondary:
          ColorCategory.fromJson(json['secondary'] as Map<String, dynamic>),
      status: StatusColors.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextColorsToJson(TextColors instance) =>
    <String, dynamic>{
      'neutral': instance.neutral,
      'neutral-invert': instance.neutralInvert,
      'primary': instance.primary,
      'secondary': instance.secondary,
      'status': instance.status,
    };

TextNeutralColors _$TextNeutralColorsFromJson(Map<String, dynamic> json) =>
    TextNeutralColors(
      disabled: colorFromJson(json['disabled'] as Map<String, dynamic>),
      muted: colorFromJson(json['muted'] as Map<String, dynamic>),
      faded: colorFromJson(json['faded'] as Map<String, dynamic>),
      subdued: colorFromJson(json['subdued'] as Map<String, dynamic>),
      normal: colorFromJson(json['normal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextNeutralColorsToJson(TextNeutralColors instance) =>
    <String, dynamic>{
      'disabled': colorToJson(instance.disabled),
      'muted': colorToJson(instance.muted),
      'faded': colorToJson(instance.faded),
      'subdued': colorToJson(instance.subdued),
      'normal': colorToJson(instance.normal),
    };

TextNeutralInvertColors _$TextNeutralInvertColorsFromJson(
        Map<String, dynamic> json) =>
    TextNeutralInvertColors(
      disabled: colorFromJson(json['disabled'] as Map<String, dynamic>),
      subdued: colorFromJson(json['subdued'] as Map<String, dynamic>),
      normal: colorFromJson(json['normal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextNeutralInvertColorsToJson(
        TextNeutralInvertColors instance) =>
    <String, dynamic>{
      'disabled': colorToJson(instance.disabled),
      'subdued': colorToJson(instance.subdued),
      'normal': colorToJson(instance.normal),
    };

BorderColors _$BorderColorsFromJson(Map<String, dynamic> json) => BorderColors(
      neutral:
          BorderNeutralColors.fromJson(json['neutral'] as Map<String, dynamic>),
      neutralInvert: BorderNeutralInvertColors.fromJson(
          json['neutral-invert'] as Map<String, dynamic>),
      primary: ColorCategory.fromJson(json['primary'] as Map<String, dynamic>),
      secondary:
          ColorCategory.fromJson(json['secondary'] as Map<String, dynamic>),
      status: StatusColors.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BorderColorsToJson(BorderColors instance) =>
    <String, dynamic>{
      'neutral': instance.neutral,
      'neutral-invert': instance.neutralInvert,
      'primary': instance.primary,
      'secondary': instance.secondary,
      'status': instance.status,
    };

BorderNeutralColors _$BorderNeutralColorsFromJson(Map<String, dynamic> json) =>
    BorderNeutralColors(
      disabled: colorFromJson(json['disabled'] as Map<String, dynamic>),
      subdued: colorFromJson(json['subdued'] as Map<String, dynamic>),
      normal: colorFromJson(json['normal'] as Map<String, dynamic>),
      accent: colorFromJson(json['accent'] as Map<String, dynamic>),
      hover: colorFromJson(json['hover'] as Map<String, dynamic>),
      active: colorFromJson(json['active'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BorderNeutralColorsToJson(
        BorderNeutralColors instance) =>
    <String, dynamic>{
      'disabled': colorToJson(instance.disabled),
      'subdued': colorToJson(instance.subdued),
      'normal': colorToJson(instance.normal),
      'accent': colorToJson(instance.accent),
      'hover': colorToJson(instance.hover),
      'active': colorToJson(instance.active),
    };

BorderNeutralInvertColors _$BorderNeutralInvertColorsFromJson(
        Map<String, dynamic> json) =>
    BorderNeutralInvertColors(
      disabled: colorFromJson(json['disabled'] as Map<String, dynamic>),
      subdued: colorFromJson(json['subdued'] as Map<String, dynamic>),
      normal: colorFromJson(json['normal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BorderNeutralInvertColorsToJson(
        BorderNeutralInvertColors instance) =>
    <String, dynamic>{
      'disabled': colorToJson(instance.disabled),
      'subdued': colorToJson(instance.subdued),
      'normal': colorToJson(instance.normal),
    };

IconColors _$IconColorsFromJson(Map<String, dynamic> json) => IconColors(
      neutral:
          IconNeutralColors.fromJson(json['neutral'] as Map<String, dynamic>),
      neutralInvert: IconNeutralInvertColors.fromJson(
          json['neutral-invert'] as Map<String, dynamic>),
      primary: ColorCategory.fromJson(json['primary'] as Map<String, dynamic>),
      secondary:
          ColorCategory.fromJson(json['secondary'] as Map<String, dynamic>),
      status: StatusColors.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IconColorsToJson(IconColors instance) =>
    <String, dynamic>{
      'neutral': instance.neutral,
      'neutral-invert': instance.neutralInvert,
      'primary': instance.primary,
      'secondary': instance.secondary,
      'status': instance.status,
    };

IconNeutralColors _$IconNeutralColorsFromJson(Map<String, dynamic> json) =>
    IconNeutralColors(
      disabled: colorFromJson(json['disabled'] as Map<String, dynamic>),
      subdued: colorFromJson(json['subdued'] as Map<String, dynamic>),
      normal: colorFromJson(json['normal'] as Map<String, dynamic>),
      accent: colorFromJson(json['accent'] as Map<String, dynamic>),
      hover: colorFromJson(json['hover'] as Map<String, dynamic>),
      active: colorFromJson(json['active'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IconNeutralColorsToJson(IconNeutralColors instance) =>
    <String, dynamic>{
      'disabled': colorToJson(instance.disabled),
      'subdued': colorToJson(instance.subdued),
      'normal': colorToJson(instance.normal),
      'accent': colorToJson(instance.accent),
      'hover': colorToJson(instance.hover),
      'active': colorToJson(instance.active),
    };

IconNeutralInvertColors _$IconNeutralInvertColorsFromJson(
        Map<String, dynamic> json) =>
    IconNeutralInvertColors(
      disabled: colorFromJson(json['disabled'] as Map<String, dynamic>),
      subdued: colorFromJson(json['subdued'] as Map<String, dynamic>),
      normal: colorFromJson(json['normal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IconNeutralInvertColorsToJson(
        IconNeutralInvertColors instance) =>
    <String, dynamic>{
      'disabled': colorToJson(instance.disabled),
      'subdued': colorToJson(instance.subdued),
      'normal': colorToJson(instance.normal),
    };

ColorCategory _$ColorCategoryFromJson(Map<String, dynamic> json) =>
    ColorCategory(
      subdued: colorFromJson(json['subdued'] as Map<String, dynamic>),
      normal: colorFromJson(json['normal'] as Map<String, dynamic>),
      accent: colorFromJson(json['accent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ColorCategoryToJson(ColorCategory instance) =>
    <String, dynamic>{
      'subdued': colorToJson(instance.subdued),
      'normal': colorToJson(instance.normal),
      'accent': colorToJson(instance.accent),
    };

StatusColors _$StatusColorsFromJson(Map<String, dynamic> json) => StatusColors(
      positive: colorFromJson(json['positive'] as Map<String, dynamic>),
      negative: colorFromJson(json['negative'] as Map<String, dynamic>),
      warning: colorFromJson(json['warning'] as Map<String, dynamic>),
      informative: colorFromJson(json['informative'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatusColorsToJson(StatusColors instance) =>
    <String, dynamic>{
      'positive': colorToJson(instance.positive),
      'negative': colorToJson(instance.negative),
      'warning': colorToJson(instance.warning),
      'informative': colorToJson(instance.informative),
    };

RefDm _$RefDmFromJson(Map<String, dynamic> json) => RefDm(
      dm2: doubleFromJson(json['dm-2'] as Map<String, dynamic>),
      dm4: doubleFromJson(json['dm-4'] as Map<String, dynamic>),
      dm8: doubleFromJson(json['dm-8'] as Map<String, dynamic>),
      dm10: doubleFromJson(json['dm-10'] as Map<String, dynamic>),
      dm12: doubleFromJson(json['dm-12'] as Map<String, dynamic>),
      dm14: doubleFromJson(json['dm-14'] as Map<String, dynamic>),
      dm16: doubleFromJson(json['dm-16'] as Map<String, dynamic>),
      dm18: doubleFromJson(json['dm-18'] as Map<String, dynamic>),
      dm20: doubleFromJson(json['dm-20'] as Map<String, dynamic>),
      dm24: doubleFromJson(json['dm-24'] as Map<String, dynamic>),
      dm28: doubleFromJson(json['dm-28'] as Map<String, dynamic>),
      dm32: doubleFromJson(json['dm-32'] as Map<String, dynamic>),
      dm36: doubleFromJson(json['dm-36'] as Map<String, dynamic>),
      dm40: doubleFromJson(json['dm-40'] as Map<String, dynamic>),
      dm44: doubleFromJson(json['dm-44'] as Map<String, dynamic>),
      dm48: doubleFromJson(json['dm-48'] as Map<String, dynamic>),
      dm52: doubleFromJson(json['dm-52'] as Map<String, dynamic>),
      dm56: doubleFromJson(json['dm-56'] as Map<String, dynamic>),
      dm64: doubleFromJson(json['dm-64'] as Map<String, dynamic>),
      dm72: doubleFromJson(json['dm-72'] as Map<String, dynamic>),
      dm80: doubleFromJson(json['dm-80'] as Map<String, dynamic>),
      dm88: doubleFromJson(json['dm-88'] as Map<String, dynamic>),
      dm96: doubleFromJson(json['dm-96'] as Map<String, dynamic>),
      dm112: doubleFromJson(json['dm-112'] as Map<String, dynamic>),
      dm128: doubleFromJson(json['dm-128'] as Map<String, dynamic>),
      dm144: doubleFromJson(json['dm-144'] as Map<String, dynamic>),
      dm160: doubleFromJson(json['dm-160'] as Map<String, dynamic>),
      dm184: doubleFromJson(json['dm-184'] as Map<String, dynamic>),
      dm200: doubleFromJson(json['dm-200'] as Map<String, dynamic>),
      dm240: doubleFromJson(json['dm-240'] as Map<String, dynamic>),
      dm1000: doubleFromJson(json['dm-1000'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefDmToJson(RefDm instance) => <String, dynamic>{
      'dm-2': instance.dm2,
      'dm-4': instance.dm4,
      'dm-8': instance.dm8,
      'dm-10': instance.dm10,
      'dm-12': instance.dm12,
      'dm-14': instance.dm14,
      'dm-16': instance.dm16,
      'dm-18': instance.dm18,
      'dm-20': instance.dm20,
      'dm-24': instance.dm24,
      'dm-28': instance.dm28,
      'dm-32': instance.dm32,
      'dm-36': instance.dm36,
      'dm-40': instance.dm40,
      'dm-44': instance.dm44,
      'dm-48': instance.dm48,
      'dm-52': instance.dm52,
      'dm-56': instance.dm56,
      'dm-64': instance.dm64,
      'dm-72': instance.dm72,
      'dm-80': instance.dm80,
      'dm-88': instance.dm88,
      'dm-96': instance.dm96,
      'dm-112': instance.dm112,
      'dm-128': instance.dm128,
      'dm-144': instance.dm144,
      'dm-160': instance.dm160,
      'dm-184': instance.dm184,
      'dm-200': instance.dm200,
      'dm-240': instance.dm240,
      'dm-1000': instance.dm1000,
    };

RefColor _$RefColorFromJson(Map<String, dynamic> json) => RefColor(
      primary: ColorScale.fromJson(json['primary'] as Map<String, dynamic>),
      secondary: ColorScale.fromJson(json['secondary'] as Map<String, dynamic>),
      tertiary: ColorScale.fromJson(json['tertiary'] as Map<String, dynamic>),
      neutral:
          NeutralColorScale.fromJson(json['neutral'] as Map<String, dynamic>),
      status:
          StatusColorScales.fromJson(json['status'] as Map<String, dynamic>),
      alpha: AlphaScales.fromJson(json['alpha'] as Map<String, dynamic>),
      root: RootColors.fromJson(json['root'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefColorToJson(RefColor instance) => <String, dynamic>{
      'primary': instance.primary,
      'secondary': instance.secondary,
      'tertiary': instance.tertiary,
      'neutral': instance.neutral,
      'status': instance.status,
      'alpha': instance.alpha,
      'root': instance.root,
    };

ColorScale _$ColorScaleFromJson(Map<String, dynamic> json) => ColorScale(
      n100: colorFromJson(json['100'] as Map<String, dynamic>),
      n200: colorFromJson(json['200'] as Map<String, dynamic>),
      n300: colorFromJson(json['300'] as Map<String, dynamic>),
      n400: colorFromJson(json['400'] as Map<String, dynamic>),
      n500: colorFromJson(json['500'] as Map<String, dynamic>),
      n600: colorFromJson(json['600'] as Map<String, dynamic>),
      n700: colorFromJson(json['700'] as Map<String, dynamic>),
      n800: colorFromJson(json['800'] as Map<String, dynamic>),
      n900: colorFromJson(json['900'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ColorScaleToJson(ColorScale instance) =>
    <String, dynamic>{
      '100': colorToJson(instance.n100),
      '200': colorToJson(instance.n200),
      '300': colorToJson(instance.n300),
      '400': colorToJson(instance.n400),
      '500': colorToJson(instance.n500),
      '600': colorToJson(instance.n600),
      '700': colorToJson(instance.n700),
      '800': colorToJson(instance.n800),
      '900': colorToJson(instance.n900),
    };

NeutralColorScale _$NeutralColorScaleFromJson(Map<String, dynamic> json) =>
    NeutralColorScale(
      n0: colorFromJson(json['0'] as Map<String, dynamic>),
      n100: colorFromJson(json['100'] as Map<String, dynamic>),
      n200: colorFromJson(json['200'] as Map<String, dynamic>),
      n300: colorFromJson(json['300'] as Map<String, dynamic>),
      n400: colorFromJson(json['400'] as Map<String, dynamic>),
      n500: colorFromJson(json['500'] as Map<String, dynamic>),
      n600: colorFromJson(json['600'] as Map<String, dynamic>),
      n700: colorFromJson(json['700'] as Map<String, dynamic>),
      n800: colorFromJson(json['800'] as Map<String, dynamic>),
      n900: colorFromJson(json['900'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NeutralColorScaleToJson(NeutralColorScale instance) =>
    <String, dynamic>{
      '0': colorToJson(instance.n0),
      '100': colorToJson(instance.n100),
      '200': colorToJson(instance.n200),
      '300': colorToJson(instance.n300),
      '400': colorToJson(instance.n400),
      '500': colorToJson(instance.n500),
      '600': colorToJson(instance.n600),
      '700': colorToJson(instance.n700),
      '800': colorToJson(instance.n800),
      '900': colorToJson(instance.n900),
    };

StatusColorScales _$StatusColorScalesFromJson(Map<String, dynamic> json) =>
    StatusColorScales(
      positive: ColorScale.fromJson(json['positive'] as Map<String, dynamic>),
      negative: ColorScale.fromJson(json['negative'] as Map<String, dynamic>),
      warning: ColorScale.fromJson(json['warning'] as Map<String, dynamic>),
      informative:
          ColorScale.fromJson(json['informative'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatusColorScalesToJson(StatusColorScales instance) =>
    <String, dynamic>{
      'positive': instance.positive,
      'negative': instance.negative,
      'warning': instance.warning,
      'informative': instance.informative,
    };

AlphaScales _$AlphaScalesFromJson(Map<String, dynamic> json) => AlphaScales(
      white: AlphaScale.fromJson(json['white'] as Map<String, dynamic>),
      black: AlphaScale.fromJson(json['black'] as Map<String, dynamic>),
      primary: AlphaScale.fromJson(json['primary'] as Map<String, dynamic>),
      secondary: AlphaScale.fromJson(json['secondary'] as Map<String, dynamic>),
      tertiary: AlphaScale.fromJson(json['tertiary'] as Map<String, dynamic>),
      statusNegative:
          AlphaScale.fromJson(json['status-negative'] as Map<String, dynamic>),
      statusPositive:
          AlphaScale.fromJson(json['status-positive'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlphaScalesToJson(AlphaScales instance) =>
    <String, dynamic>{
      'white': instance.white,
      'black': instance.black,
      'primary': instance.primary,
      'secondary': instance.secondary,
      'tertiary': instance.tertiary,
      'status-negative': instance.statusNegative,
      'status-positive': instance.statusPositive,
    };

AlphaScale _$AlphaScaleFromJson(Map<String, dynamic> json) => AlphaScale(
      n0: colorFromJson(json['0'] as Map<String, dynamic>),
      n10: colorFromJson(json['10'] as Map<String, dynamic>),
      n20: colorFromJson(json['20'] as Map<String, dynamic>),
      n30: colorFromJson(json['30'] as Map<String, dynamic>),
      n40: colorFromJson(json['40'] as Map<String, dynamic>),
      n50: colorFromJson(json['50'] as Map<String, dynamic>),
      n60: colorFromJson(json['60'] as Map<String, dynamic>),
      n70: colorFromJson(json['70'] as Map<String, dynamic>),
      n80: colorFromJson(json['80'] as Map<String, dynamic>),
      n90: colorFromJson(json['90'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlphaScaleToJson(AlphaScale instance) =>
    <String, dynamic>{
      '0': colorToJson(instance.n0),
      '10': colorToJson(instance.n10),
      '20': colorToJson(instance.n20),
      '30': colorToJson(instance.n30),
      '40': colorToJson(instance.n40),
      '50': colorToJson(instance.n50),
      '60': colorToJson(instance.n60),
      '70': colorToJson(instance.n70),
      '80': colorToJson(instance.n80),
      '90': colorToJson(instance.n90),
    };

RootColors _$RootColorsFromJson(Map<String, dynamic> json) => RootColors(
      primary: ValueModel.fromJson(json['primary'] as Map<String, dynamic>),
      secondary: ValueModel.fromJson(json['secondary'] as Map<String, dynamic>),
      tertiary: ValueModel.fromJson(json['tertiary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RootColorsToJson(RootColors instance) =>
    <String, dynamic>{
      'primary': instance.primary,
      'secondary': instance.secondary,
      'tertiary': instance.tertiary,
    };

SysDm _$SysDmFromJson(Map<String, dynamic> json) => SysDm(
      radius: DesignRadius.fromJson(json['radius'] as Map<String, dynamic>),
      grid: Grid.fromJson(json['grid'] as Map<String, dynamic>),
      spacing: Spacing.fromJson(json['spacing'] as Map<String, dynamic>),
      padding: Padding.fromJson(json['padding'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SysDmToJson(SysDm instance) => <String, dynamic>{
      'radius': instance.radius,
      'grid': instance.grid,
      'spacing': instance.spacing,
      'padding': instance.padding,
    };

DesignRadius _$DesignRadiusFromJson(Map<String, dynamic> json) => DesignRadius(
      card: doubleFromJson(json['card'] as Map<String, dynamic>),
      button: doubleFromJson(json['button'] as Map<String, dynamic>),
      input: doubleFromJson(json['input'] as Map<String, dynamic>),
      badge: doubleFromJson(json['badge'] as Map<String, dynamic>),
      chipTag: doubleFromJson(json['chip,-tag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DesignRadiusToJson(DesignRadius instance) =>
    <String, dynamic>{
      'card': instance.card,
      'button': instance.button,
      'input': instance.input,
      'badge': instance.badge,
      'chip,-tag': instance.chipTag,
    };

Grid _$GridFromJson(Map<String, dynamic> json) => Grid(
      homeScreen:
          ScreenGrid.fromJson(json['home-screen'] as Map<String, dynamic>),
      childScreen:
          ScreenGrid.fromJson(json['child-screen'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GridToJson(Grid instance) => <String, dynamic>{
      'home-screen': instance.homeScreen,
      'child-screen': instance.childScreen,
    };

ScreenGrid _$ScreenGridFromJson(Map<String, dynamic> json) => ScreenGrid(
      marginTB: doubleFromJson(json['margin-t-b'] as Map<String, dynamic>),
      marginLR: doubleFromJson(json['margin-l-r'] as Map<String, dynamic>),
      gutter: doubleFromJson(json['gutter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScreenGridToJson(ScreenGrid instance) =>
    <String, dynamic>{
      'margin-t-b': instance.marginTB,
      'margin-l-r': instance.marginLR,
      'gutter': instance.gutter,
    };

Spacing _$SpacingFromJson(Map<String, dynamic> json) => Spacing(
      blockToBlock:
          doubleFromJson(json['block-to-block'] as Map<String, dynamic>),
      cardToCard: doubleFromJson(json['card-to-card'] as Map<String, dynamic>),
      titleToContent:
          doubleFromJson(json['title-to-content'] as Map<String, dynamic>),
      subTitleToContent:
          doubleFromJson(json['sub-title-to-content'] as Map<String, dynamic>),
      inputForm: doubleFromJson(json['input-form'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SpacingToJson(Spacing instance) => <String, dynamic>{
      'block-to-block': instance.blockToBlock,
      'card-to-card': instance.cardToCard,
      'title-to-content': instance.titleToContent,
      'sub-title-to-content': instance.subTitleToContent,
      'input-form': instance.inputForm,
    };

Padding _$PaddingFromJson(Map<String, dynamic> json) => Padding(
      inCard: doubleFromJson(json['in-card'] as Map<String, dynamic>),
      inBottomSheet:
          doubleFromJson(json['in-bottom-sheet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaddingToJson(Padding instance) => <String, dynamic>{
      'in-card': instance.inCard,
      'in-bottom-sheet': instance.inBottomSheet,
    };

RefTypo _$RefTypoFromJson(Map<String, dynamic> json) => RefTypo(
      fontFamily:
          FontFamily.fromJson(json['font-familiy'] as Map<String, dynamic>),
      fontWeight: DesignFontWeight.fromJson(
          json['font-weight'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefTypoToJson(RefTypo instance) => <String, dynamic>{
      'font-familiy': instance.fontFamily,
      'font-weight': instance.fontWeight,
    };

FontFamily _$FontFamilyFromJson(Map<String, dynamic> json) => FontFamily(
      title: fontNameFromJson(json['title'] as Map<String, dynamic>),
      body: fontNameFromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FontFamilyToJson(FontFamily instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };

DesignFontWeight _$DesignFontWeightFromJson(Map<String, dynamic> json) =>
    DesignFontWeight(
      regular: ValueModel.fromJson(json['regular'] as Map<String, dynamic>),
      italic: ValueModel.fromJson(json['italic'] as Map<String, dynamic>),
      blackItalic:
          ValueModel.fromJson(json['black-italic'] as Map<String, dynamic>),
      medium: ValueModel.fromJson(json['medium'] as Map<String, dynamic>),
      mediumItalic:
          ValueModel.fromJson(json['medium-italic'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DesignFontWeightToJson(DesignFontWeight instance) =>
    <String, dynamic>{
      'regular': instance.regular,
      'italic': instance.italic,
      'black-italic': instance.blackItalic,
      'medium': instance.medium,
      'medium-italic': instance.mediumItalic,
    };
