# Kế Hoạch Triển Khai Hệ Thống Flutter Component Kit

## Tài Liệu Tổng Hợp & Hướng Dẫn Triển Khai

---

## Mục Lục

1. [Tổng Quan Dự Án](#tổng-quan-dự-án)
2. [Mục Tiêu & Tầm Nhìn](#mục-tiêu--tầm-nhìn)
3. [Kiến Trúc Hệ Thống](#kiến-trúc-hệ-thống)
4. [Phân Tích Kỹ Thuật Chi Tiết](#phân-tích-kỹ-thuật-chi-tiết)
   - [Design Token System](#design-token-system)
   - [Atomic Design Architecture](#atomic-design-architecture)
   - [Variant Management System](#variant-management-system)
   - [Layout Components](#layout-components)
   - [Slot Pattern for Complex Components](#slot-pattern-for-complex-components)
5. [Roadmap Triển Khai](#roadmap-triển-khai)
6. [Conclusion](#conclusion)

---

## Tổng Quan Dự Án

### Bối Cảnh

Hiện tại, mỗi dự án Flutter đang tốn nhiều thời gian để xây dựng lại các thành phần UI cơ bản. Giao diện giữa các dự án không đồng nhất, tạo ra trải nghiệm rời rạc cho người dùng. Khi cần thay đổi thiết kế, phải sửa ở rất nhiều nơi, tốn kém và dễ gây lỗi.

### Giải Pháp Đề Xuất

Xây dựng một hệ thống Component Kit (Bộ thành phần) cho Flutter có khả năng mở rộng, tái sử dụng cao, nhằm mục đích:

- Thống nhất giao diện người dùng (UI) trên tất cả các dự án
- Tăng tốc độ phát triển sản phẩm
- Giảm thiểu chi phí bảo trì và cập nhật thiết kế
- Tạo ra UI một cách linh hoạt (flexible), cho phép dễ dàng thay đổi, tùy biến giao diện và tái sắp xếp vị trí của các thành phần một cách đơn giản

---

## Mục Tiêu & Tầm Nhìn

### Mục Tiêu Chính

1. **Thống nhất UI**: Đảm bảo tính nhất quán về thiết kế trên toàn bộ hệ sinh thái sản phẩm
2. **Tăng tốc độ phát triển**: Giảm >30% thời gian xây dựng màn hình mới
3. **Giảm chi phí bảo trì**: Cập nhật thiết kế toàn bộ sản phẩm chỉ trong vài giờ
4. **Linh hoạt trong thiết kế**: Dễ dàng thay đổi, tùy biến giao diện và tái sắp xếp vị trí

### Tầm Nhìn Dài Hạn

- Trở thành nền tảng thiết kế chuẩn cho toàn bộ công ty
- Hỗ trợ đa nền tảng (Flutter, Web, iOS/Android native)
- Tích hợp với hệ thống CMS để thay đổi theme động
- Hỗ trợ A/B testing về giao diện

---

## Kiến Trúc Hệ Thống

### 4 trụ Cột Chính

```
Component Kit Architecture
├── Design Token System(style_module)
│   ├── JSON Configuration (style.json)
│   ├── Dynamic Theme Loader & Parser
│   └── ThemeData Cache
├── Atomic Design Structure
│   ├── Atoms (Button, Input, Icon, Text)
│   ├── Molecules (Search Bar, Form Field, List Item)
│   └── Organisms (Header, Product Card, Navigation)
├── Variant Management System
│   ├── Style (primary, secondary, outline, ghost)
│   ├── Size (sm, md, lg, xl)
│   ├── State (hover, disabled, loading, active)
│   └── Platform (iOS, Android, Web)
└── Multi-Project Integration
    ├── Published Package (via Git or Pub.dev)
    ├── Semantic Versioning
    └── Project-specific Overrides
```

### Cấu Trúc Thư Mục vs Components

#### Loại 1 Package Độc Lập (Standalone Package)

```
style_module/ # Style Module
├── lib/
│   ├── models/
│   ├── theme/  # Theme definitions
│   ├── utils/
component_kit/
├── lib/
│   ├── src/
│   │   ├── variants/
│   │   │   ├── variant.dart
│   │   │   ├── size.dart
│   │   │   └── shape.dart
│   │   ├── components/
│   │   │   ├── atoms/
│   │   │   │   ├── button/
│   │   │   │   │   ├── app_button.dart
│   │   │   │   │   ├── app_button_types.dart
│   │   │   │   │   ├── app_button_sheet.dart
│   │   │   │   │   ├── app_button_theme.dart
│   │   │   │   │   └── app_button_test.dart
│   │   │   │   └── text.dart
│   │   │   ├── molecules/
│   │   │   ├── organisms/
│   │   │   └── layout/
│   │   └── utils/
│   │       └── helpers.dart
│   └── component_kit.dart
├── assets/
├── example/
├── test/
├── pubspec.yaml
├── README.md
└── CHANGELOG.md
```

## Chi Tiết Cấu Trúc Thư Mục Components

### Cấu Trúc Chi Tiết cho Components/Atoms

```
components/
├── atoms/                           # Thành phần cơ bản nhất
│   ├── button/
│   │   ├── app_button.dart          # Main button component
│   │   ├── app_button_sheet.dart    # ButtonStyleSheet implementation
│   │   ├── app_button_theme.dart    # Theme integration
│   │   ├── app_button_types.dart    # ButtonVariant, ButtonSize, ButtonShape enums
│   │   ├── app_button_test.dart     # Unit tests
│   │   └── index.dart               # Export file
│   ├── text/
│   │   ├── app_text.dart            # Main text component
│   │   ├── app_text_sheet.dart      # TextStyleSheet implementation
│   │   ├── app_text_theme.dart      # Theme integration
│   │   ├── app_text_types.dart      # TextVariant, TextSize, TextColor enums
│   │   ├── app_text_test.dart       # Unit tests
│   │   └── index.dart               # Export file
│   ├── icon/
│   │   ├── app_icon.dart            # Main icon component
│   │   ├── app_icon_sheet.dart      # IconStyleSheet implementation
│   │   ├── app_icon_types.dart      # IconSize, IconColor enums
│   │   ├── app_icon_test.dart       # Unit tests
│   │   └── index.dart               # Export file
│   ├── input/
│   │   ├── app_input.dart           # Main input component
│   │   ├── app_input_sheet.dart     # InputStyleSheet implementation
│   │   ├── app_input_theme.dart     # Theme integration
│   │   ├── app_input_types.dart     # InputType, InputState enums
│   │   ├── app_input_test.dart      # Unit tests
│   │   └── index.dart               # Export file
│   ├── avatar/
│   │   ├── app_avatar.dart          # Main avatar component
│   │   ├── app_avatar_sheet.dart    # AvatarStyleSheet implementation
│   │   ├── app_avatar_types.dart    # AvatarSize, AvatarShape enums
│   │   ├── app_avatar_test.dart     # Unit tests
│   │   └── index.dart               # Export file
│   ├── badge/
│   │   ├── app_badge.dart           # Main badge component
│   │   ├── app_badge_sheet.dart     # BadgeStyleSheet implementation
│   │   ├── app_badge_types.dart     # BadgeVariant, BadgeSize enums
│   │   ├── app_badge_test.dart      # Unit tests
│   │   └── index.dart               # Export file
│   ├── chip/
│   │   ├── app_chip.dart            # Main chip component
│   │   ├── app_chip_sheet.dart      # ChipStyleSheet implementation
│   │   ├── app_chip_types.dart      # ChipVariant, ChipSize enums
│   │   ├── app_chip_test.dart       # Unit tests
│   │   └── index.dart               # Export file
│   ├── divider/
│   │   ├── app_divider.dart         # Main divider component
│   │   ├── app_divider_sheet.dart   # DividerStyleSheet implementation
│   │   ├── app_divider_types.dart   # DividerOrientation enum
│   │   ├── app_divider_test.dart    # Unit tests
│   │   └── index.dart               # Export file
│   └── skeleton/
│       ├── app_skeleton.dart         # Main skeleton component
│       ├── app_skeleton_sheet.dart  # SkeletonStyleSheet implementation
│       ├── app_skeleton_types.dart  # SkeletonType, SkeletonShape enums
│       ├── app_skeleton_test.dart   # Unit tests
│       └── index.dart               # Export file
├── molecules/                       # Kết hợp từ atoms
│   ├── search_bar/
│   │   ├── app_search_bar.dart      # Main search bar component
│   │   ├── app_search_bar_sheet.dart # SearchBarStyleSheet implementation
│   │   ├── app_search_bar_types.dart # SearchBarVariant enum
│   │   ├── app_search_bar_test.dart  # Unit tests
│   │   └── index.dart                # Export file
│   ├── form_field/
│   │   ├── app_form_field.dart       # Main form field component
│   │   ├── app_form_field_sheet.dart # FormFieldStyleSheet implementation
│   │   ├── app_form_field_types.dart # FormFieldType enum
│   │   ├── app_form_field_test.dart  # Unit tests
│   │   └── index.dart                # Export file
│   ├── list_item/
│   │   ├── app_list_item.dart        # Main list item component
│   │   ├── app_list_item_sheet.dart  # ListItemStyleSheet implementation
│   │   ├── app_list_item_types.dart  # ListItemVariant enum
│   │   ├── app_list_item_test.dart   # Unit tests
│   │   └── index.dart                # Export file
│   ├── card/
│   │   ├── app_card.dart             # Main card component
│   │   ├── app_card_sheet.dart       # CardStyleSheet implementation
│   │   ├── app_card_types.dart       # CardVariant enum
│   │   ├── app_card_test.dart        # Unit tests
│   │   └── index.dart                # Export file
│   ├── dialog/
│   │   ├── app_dialog.dart           # Main dialog component
│   │   ├── app_dialog_sheet.dart     # DialogStyleSheet implementation
│   │   ├── app_dialog_types.dart     # DialogVariant enum
│   │   ├── app_dialog_test.dart      # Unit tests
│   │   └── index.dart                # Export file
│   ├── modal/
│   │   ├── app_modal.dart            # Main modal component
│   │   ├── app_modal_sheet.dart      # ModalStyleSheet implementation
│   │   ├── app_modal_types.dart      # ModalVariant enum
│   │   ├── app_modal_test.dart       # Unit tests
│   │   └── index.dart                # Export file
│   ├── tooltip/
│   │   ├── app_tooltip.dart          # Main tooltip component
│   │   ├── app_tooltip_sheet.dart    # TooltipStyleSheet implementation
│   │   ├── app_tooltip_types.dart    # TooltipPosition enum
│   │   ├── app_tooltip_test.dart     # Unit tests
│   │   └── index.dart                # Export file
│   ├── progress/
│   │   ├── app_progress.dart         # Main progress component
│   │   ├── app_progress_sheet.dart   # ProgressStyleSheet implementation
│   │   ├── app_progress_types.dart   # ProgressType enum
│   │   ├── app_progress_test.dart    # Unit tests
│   │   └── index.dart                # Export file
│   ├── stepper/
│   │   ├── app_stepper.dart          # Main stepper component
│   │   ├── app_stepper_sheet.dart    # StepperStyleSheet implementation
│   │   ├── app_stepper_types.dart    # StepperOrientation enum
│   │   ├── app_stepper_test.dart     # Unit tests
│   │   └── index.dart                # Export file
│   └── breadcrumb/
│       ├── app_breadcrumb.dart       # Main breadcrumb component
│       ├── app_breadcrumb_sheet.dart # BreadcrumbStyleSheet implementation
│       ├── app_breadcrumb_types.dart # BreadcrumbSeparator enum
│       ├── app_breadcrumb_test.dart  # Unit tests
│       └── index.dart                # Export file
├── organisms/                       # Kết hợp từ molecules
│   ├── header/
│   │   ├── app_header.dart           # Main header component
│   │   ├── app_header_sheet.dart     # HeaderStyleSheet implementation
│   │   ├── app_header_types.dart     # HeaderVariant enum
│   │   ├── app_header_test.dart      # Unit tests
│   │   └── index.dart                # Export file
│   ├── navigation/
│   │   ├── app_navigation.dart       # Main navigation component
│   │   ├── app_navigation_sheet.dart # NavigationStyleSheet implementation
│   │   ├── app_navigation_types.dart # NavigationType enum
│   │   ├── app_navigation_test.dart  # Unit tests
│   │   └── index.dart                # Export file
│   ├── sidebar/
│   │   ├── app_sidebar.dart          # Main sidebar component
│   │   ├── app_sidebar_sheet.dart    # SidebarStyleSheet implementation
│   │   ├── app_sidebar_types.dart    # SidebarVariant enum
│   │   ├── app_sidebar_test.dart     # Unit tests
│   │   └── index.dart                # Export file
│   ├── footer/
│   │   ├── app_footer.dart           # Main footer component
│   │   ├── app_footer_sheet.dart     # FooterStyleSheet implementation
│   │   ├── app_footer_types.dart     # FooterVariant enum
│   │   ├── app_footer_test.dart      # Unit tests
│   │   └── index.dart                # Export file
│   ├── product_card/
│   │   ├── app_product_card.dart     # Main product card component
│   │   ├── app_product_card_sheet.dart # ProductCardStyleSheet implementation
│   │   ├── app_product_card_types.dart # ProductCardVariant enum
│   │   ├── app_product_card_test.dart  # Unit tests
│   │   └── index.dart                 # Export file
│   ├── user_profile/
│   │   ├── app_user_profile.dart     # Main user profile component
│   │   ├── app_user_profile_sheet.dart # UserProfileStyleSheet implementation
│   │   ├── app_user_profile_types.dart # UserProfileVariant enum
│   │   ├── app_user_profile_test.dart  # Unit tests
│   │   └── index.dart                 # Export file
│   ├── data_table/
│   │   ├── app_data_table.dart       # Main data table component
│   │   ├── app_data_table_sheet.dart # DataTableStyleSheet implementation
│   │   ├── app_data_table_types.dart # DataTableVariant enum
│   │   ├── app_data_table_test.dart  # Unit tests
│   │   └── index.dart                # Export file
│   ├── form/
│   │   ├── app_form.dart             # Main form component
│   │   ├── app_form_sheet.dart       # FormStyleSheet implementation
│   │   ├── app_form_types.dart       # FormVariant enum
│   │   ├── app_form_test.dart        # Unit tests
│   │   └── index.dart                # Export file
│   ├── gallery/
│   │   ├── app_gallery.dart          # Main gallery component
│   │   ├── app_gallery_sheet.dart    # GalleryStyleSheet implementation
│   │   ├── app_gallery_types.dart    # GalleryLayout enum
│   │   ├── app_gallery_test.dart     # Unit tests
│   │   └── index.dart                # Export file
│   └── dashboard/
│       ├── app_dashboard.dart        # Main dashboard component
│       ├── app_dashboard_sheet.dart  # DashboardStyleSheet implementation
│       ├── app_dashboard_types.dart  # DashboardLayout enum
│       ├── app_dashboard_test.dart   # Unit tests
│       └── index.dart                # Export file
└── layout/                          # Layout components
    ├── h_stack.dart                 # Horizontal stack layout
    ├── v_stack.dart                 # Vertical stack layout
    ├── spacer.dart                  # Flexible space component
    ├── app_padding.dart             # Consistent padding component
    ├── responsive_container.dart     # Responsive container
    ├── grid.dart                    # Grid layout component
    ├── flex_container.dart          # Flexible container
    ├── aspect_ratio.dart            # Aspect ratio component
    ├── overflow_box.dart            # Overflow handling component
    ├── constrained_box.dart         # Constrained box component
    ├── layout_builder.dart          # Layout builder component
    ├── custom_multi_child_layout.dart # Custom multi-child layout
    ├── layout_test.dart             # Layout testing utilities
    └── index.dart                   # Export file
```

**Chi Tiết Các Component:**

**Atoms (Thành phần cơ bản nhất):**

- **Button**: AppButton với variants (primary, secondary, danger, ghost, outlined, text), sizes (small, medium, large), shapes (rectangle, rounded, pill)
- **Text**: AppText với variants (heading, subheading, body, caption, label), sizes (xs, sm, md, lg, xl), colors (primary, secondary, muted, danger)
- **Icon**: AppIcon với sizes, colors, và custom icon support
- **Input**: AppInput với types (text, email, password, number, tel), states (normal, focus, error, disabled), variants (outlined, filled, underlined)
- **Avatar**: AppAvatar với sizes (xs, sm, md, lg, xl), shapes (circle, square, rounded), fallback support
- **Badge**: AppBadge với variants (primary, secondary, success, warning, danger), sizes, và dot indicator
- **Chip**: AppChip với variants (filled, outlined, soft), sizes, và removable option
- **Divider**: AppDivider với orientations (horizontal, vertical), styles, và spacing
- **Skeleton**: AppSkeleton cho loading states với customizable shapes và animations

**Molecules (Kết hợp từ atoms):**

- **SearchBar**: AppSearchBar với search input, filter options, và search history
- **FormField**: AppFormField với label, validation, error states, và helper text
- **ListItem**: AppListItem với leading/trailing slots, subtitle, và interactive states
- **Card**: AppCard với header, content, footer, và action slots
- **Dialog**: AppDialog với title, content, và action buttons
- **Modal**: AppModal với backdrop, positioning, và animation options
- **Tooltip**: AppTooltip với positioning, triggers, và custom content
- **Progress**: AppProgress với linear/circular variants, colors, và animation
- **Stepper**: AppStepper với horizontal/vertical layouts, validation states
- **Breadcrumb**: AppBreadcrumb với navigation hierarchy và responsive behavior

**Organisms (Kết hợp từ molecules):**

- **Header**: AppHeader với navigation, actions, search, và user menu
- **Navigation**: AppNavigation với tabs, pills, và responsive behavior
- **Sidebar**: AppSidebar với collapsible sections, nested navigation
- **Footer**: AppFooter với links, social media, và copyright info
- **ProductCard**: AppProductCard với image, title, price, rating, và actions
- **UserProfile**: AppUserProfile với avatar, info, stats, và actions
- **DataTable**: AppDataTable với sorting, filtering, pagination, và selection
- **Form**: AppForm với validation, submission, và field grouping
- **Gallery**: AppGallery với grid layout, lightbox, và image optimization
- **Dashboard**: AppDashboard với widgets, charts, và customizable layout

**Layout Components:**

- **HStack**: Horizontal layout với spacing, alignment, và responsive behavior
- **VStack**: Vertical layout với spacing, alignment, và responsive behavior
- **Spacer**: Flexible space với configurable flex values
- **AppPadding**: Consistent padding với design tokens
- **ResponsiveContainer**: Adaptive layout cho different screen sizes
- **Grid**: Flexible grid layout với customizable columns và spacing
- **FlexContainer**: Flexible layout với direction, wrap, và alignment
- **AspectRatio**: Maintain aspect ratio cho content
- **OverflowBox**: Handle overflow với custom constraints
- **ConstrainedBox**: Apply size constraints với min/max values
- **LayoutBuilder**: Dynamic layout based on available space
- **CustomMultiChildLayout**: Custom layout algorithms

---

### Mô Tả Chi Tiết Các File:

**1. Main Component File (app\_\*.dart):**

- Widget implementation chính
- Props và parameters
- Build method với logic chính
- Integration với StyleSheet

**2. StyleSheet File (app\_\*\_sheet.dart):**

- ThemeExtension implementation
- Style resolution logic
- Variant/size/shape handling
- Color và spacing management

**3. Theme File (app\_\*\_theme.dart):**

- ThemeData integration
- Default theme values
- Theme switching logic
- Custom theme overrides

**4. Types File (app\_\*\_types.dart):**

- Enum definitions (Variant, Size, Shape, etc.)
- Type-safe constants
- Validation helpers
- Documentation cho types

**5. Test File (app\_\*\_test.dart):**

- Unit tests cho component
- Widget tests cho rendering
- StyleSheet tests
- Integration tests

**6. Index File (index.dart):**

- Export statements
- Public API definition
- Documentation comments
- Usage examples

**Ưu điểm:**

- Có thể publish lên pub.dev hoặc private repository
- Quản lý version độc lập với Semantic Versioning
- Dễ dàng chia sẻ và tái sử dụng across projects
- Có thể tích hợp qua dependency management

**Cách tích hợp:**

```yaml
# pubspec.yaml
dependencies:
  component_kit:
    git:
      url: https://github.com/company/component_kit.git
      ref: v10.0
```

#### Loại 2 Tích Hợp Sẵn Trong Project (Embedded Integration)

```
my_flutter_app/
├── lib/
│   ├── app/
│   │   ├── screens/        # App screens
│   │   ├── navigation/     # App navigation
│   │   └── main.dart       # App entry point
│   ├── shared/
│   │   ├── component_kit/  # Embedded Component Kit
│   │   │   ├── components/
│   │   │   │   ├── atoms/  # Thành phần cơ bản nhất
│   │   │   │   │   ├── button/
│   │   │   │   │   │   ├── app_button.dart
│   │   │   │   │   │   ├── app_button_sheet.dart
│   │   │   │   │   │   └── app_button_test.dart
│   │   │   │   │   ├── text/
│   │   │   │   │   │   ├── app_text.dart
│   │   │   │   │   │   ├── app_text_sheet.dart
│   │   │   │   │   │   └── app_text_test.dart
│   │   │   │   │   ├── icon/
│   │   │   │   │   │   ├── app_icon.dart
│   │   │   │   │   │   └── app_icon_test.dart
│   │   │   │   │   ├── input/
│   │   │   │   │   │   ├── app_input.dart
│   │   │   │   │   │   ├── app_input_sheet.dart
│   │   │   │   │   │   └── app_input_test.dart
│   │   │   │   │   ├── avatar/
│   │   │   │   │   │   ├── app_avatar.dart
│   │   │   │   │   │   └── app_avatar_test.dart
│   │   │   │   │   ├── badge/
│   │   │   │   │   │   ├── app_badge.dart
│   │   │   │   │   │   └── app_badge_test.dart
│   │   │   │   │   ├── chip/
│   │   │   │   │   │   ├── app_chip.dart
│   │   │   │   │   │   └── app_chip_test.dart
│   │   │   │   │   ├── divider/
│   │   │   │   │   │   └── app_divider.dart
│   │   │   │   │   └── skeleton/
│   │   │   │   │       ├── app_skeleton.dart
│   │   │   │   │       └── app_skeleton_test.dart
│   │   │   │   ├── molecules/  # Kết hợp từ atoms
│   │   │   │   │   ├── search_bar/
│   │   │   │   │   │   ├── app_search_bar.dart
│   │   │   │   │   │   └── app_search_bar_test.dart
│   │   │   │   │   ├── form_field/
│   │   │   │   │   │   ├── app_form_field.dart
│   │   │   │   │   │   └── app_form_field_test.dart
│   │   │   │   │   ├── list_item/
│   │   │   │   │   │   ├── app_list_item.dart
│   │   │   │   │   │   └── app_list_item_test.dart
│   │   │   │   │   ├── card/
│   │   │   │   │   │   ├── app_card.dart
│   │   │   │   │   │   └── app_card_test.dart
│   │   │   │   │   ├── dialog/
│   │   │   │   │   │   ├── app_dialog.dart
│   │   │   │   │   │   └── app_dialog_test.dart
│   │   │   │   │   ├── modal/
│   │   │   │   │   │   ├── app_modal.dart
│   │   │   │   │   │   └── app_modal_test.dart
│   │   │   │   │   ├── tooltip/
│   │   │   │   │   │   ├── app_tooltip.dart
│   │   │   │   │   │   └── app_tooltip_test.dart
│   │   │   │   │   ├── progress/
│   │   │   │   │   │   ├── app_progress.dart
│   │   │   │   │   │   └── app_progress_test.dart
│   │   │   │   │   ├── stepper/
│   │   │   │   │   │   ├── app_stepper.dart
│   │   │   │   │   │   └── app_stepper_test.dart
│   │   │   │   │   └── breadcrumb/
│   │   │   │   │       ├── app_breadcrumb.dart
│   │   │   │   │       └── app_breadcrumb_test.dart
│   │   │   │   ├── organisms/  # Kết hợp từ molecules
│   │   │   │   │   ├── header/
│   │   │   │   │   │   ├── app_header.dart
│   │   │   │   │   │   └── app_header_test.dart
│   │   │   │   │   ├── navigation/
│   │   │   │   │   │   ├── app_navigation.dart
│   │   │   │   │   │   └── app_navigation_test.dart
│   │   │   │   │   ├── sidebar/
│   │   │   │   │   │   ├── app_sidebar.dart
│   │   │   │   │   │   └── app_sidebar_test.dart
│   │   │   │   │   ├── footer/
│   │   │   │   │   │   ├── app_footer.dart
│   │   │   │   │   │   └── app_footer_test.dart
│   │   │   │   │   ├── product_card/
│   │   │   │   │   │   ├── app_product_card.dart
│   │   │   │   │   │   └── app_product_card_test.dart
│   │   │   │   │   ├── user_profile/
│   │   │   │   │   │   ├── app_user_profile.dart
│   │   │   │   │   │   └── app_user_profile_test.dart
│   │   │   │   │   ├── data_table/
│   │   │   │   │   │   ├── app_data_table.dart
│   │   │   │   │   │   └── app_data_table_test.dart
│   │   │   │   │   ├── form/
│   │   │   │   │   │   ├── app_form.dart
│   │   │   │   │   │   └── app_form_test.dart
│   │   │   │   │   ├── gallery/
│   │   │   │   │   │   ├── app_gallery.dart
│   │   │   │   │   │   └── app_gallery_test.dart
│   │   │   │   │   └── dashboard/
│   │   │   │   │       ├── app_dashboard.dart
│   │   │   │   │       └── app_dashboard_test.dart
│   │   │   │   └── layout/  # Layout components
│   │   │   │       ├── h_stack.dart
│   │   │   │       ├── v_stack.dart
│   │   │   │       ├── spacer.dart
│   │   │   │       ├── app_padding.dart
│   │   │   │       ├── responsive_container.dart
│   │   │   │       ├── grid.dart
│   │   │   │       ├── flex_container.dart
│   │   │   │       ├── aspect_ratio.dart
│   │   │   │       ├── overflow_box.dart
│   │   │   │       ├── constrained_box.dart
│   │   │   │       ├── layout_builder.dart
│   │   │   │       ├── custom_multi_child_layout.dart
│   │   │   │       └── layout_test.dart
│   │   │   ├── variants/   # Variant management
│   │   │   │   ├── variant.dart
│   │   │   │   ├── size.dart
│   │   │   │   └── shape.dart
│   │   │   └── stylesheets/
│   │   │       ├── button_style_sheet.dart
│   │   │       ├── text_style_sheet.dart
│   │   │       ├── input_style_sheet.dart
│   │   │       └── card_style_sheet.dart
│   │   ├── utils/          # App utilities
│   │   ├── constants/      # App constants
│   │   └── services/       # App services
│   ├── features/           # Feature modules
│   │   ├── auth/
│   │   ├── home/
│   │   └── profile/
│   └── main.dart
├── package/
│   ├── style_module/
│   │   ├── lib/
│   │   │   ├── models/
│   │   │   ├── theme/
│   │   │   └── utils/
│   │   └── pubspec.yaml
│   └── component_kit/
├── assets/
│   ├── images/
│   ├── fonts/
│   └── tokens/             # Design tokens
│       ├── light.json
│       ├── dark.json
│       └── custom.json
├── test/
├── pubspec.yaml
└── README.md
```

**Ưu điểm:**

- Không cần quản lý dependency external
- Có thể customize trực tiếp cho project cụ thể
- Không có overhead của package management
- Dễ dàng debug và modify cho project

### So Sánh Hai Loại

| Tiêu Chí               | Package Độc Lập        | Tích Hợp Sẵn             |
| ---------------------- | ---------------------- | ------------------------ |
| **Quản lý version**    | Semantic Versioning    | Theo project             |
| **Tái sử dụng**        | Across nhiều projects  | Chỉ cho project hiện tại |
| **Customization**      | Cần override hoặc fork | Modify trực tiếp         |
| **Maintenance**        | Centralized            | Distributed              |
| **Setup complexity**   | Medium (dependency)    | Low (copy-paste)         |
| **Team collaboration** | Shared ownership       | Project-specific         |
| **CI/CD**              | Separate pipeline      | Integrated pipeline      |

### Khuyến Nghị Sử Dụng

**Sử dụng Package Độc Lập khi:**

- Có nhiều projects cần dùng chung Component Kit
- Team có quy trình quản lý package tốt
- Cần version control và backward compatibility
- Muốn chia sẻ với community hoặc teams khác

**Sử dụng Tích Hợp Sẵn khi:**

- Chỉ có 1-2 projects sử dụng
- Cần customization cao cho project cụ thể
- Team nhỏ, không có quy trình package management
- Muốn development velocity cao hơn

---

## Phân Tích Kỹ Thuật Chi Tiết

### 1. Hệ Thống Design Token (JSON-Based)

Hệ thống Design Token dựa trên JSON cho phép quản lý tập trung tất cả các giá trị thiết kế (màu sắc, khoảng cách, font size, border radius) trong file cấu hình. Designer có thể thay đổi thiết kế mà không cần can thiệp vào code, đảm bảo tính nhất quán và dễ bảo trì.

#### ✅ Lợi ích & Lý do lựa chọn:

**1. Centralized Design Management:**

- Tất cả design tokens được quản lý tập trung trong file `styles.json`
- Thay đổi design không cần sửa code, chỉ cần update JSON
- Đảm bảo consistency across toàn bộ ứng dụng

**2. Dynamic Theme Loading:**

- Load theme từ JSON file khi app khởi động
- Hỗ trợ multiple themes (light/dark) từ cùng một configuration
- Runtime theme switching không cần restart app

**3. Type-Safe Implementation:**

- Sử dụng code generation với `json_annotation` để tạo type-safe models
- Compile-time validation của design tokens
- IntelliSense support cho tất cả design properties

**4. Scalable Architecture:**

- Modular design với separate classes cho Colors, Spacing, Radius, Dimensions
- Easy extension cho new design tokens
- Backward compatibility với existing Flutter theme system

#### ✅ Triển Khai Kỹ Thuật

**JSON Configuration Structure:**

```json
{
  "sys-color": {
    "light": {
      "background": {
        "primary": {
          "subdued": { "value": "#9fedec" }
        },
        "neutral": {
          "accent": { "value": "#f5f5f5" }
        }
      },
      "text": {
        "neutral": {
          "normal": { "value": "#212121" },
          "subdued": { "value": "#757575" }
        }
      }
    },
    "dark": {
      "background": {
        "primary": {
          "subdued": { "value": "#1a1a1a" }
        }
      }
    }
  },
  "ref-dm": {
    "dm2": { "value": "2px" },
    "dm4": { "value": "4px" },
    "dm8": { "value": "8px" },
    "dm12": { "value": "12px" },
    "dm16": { "value": "16px" },
    "dm20": { "value": "20px" }
  },
  "sys-dm": {
    "spacing": {
      "blockToBlock": { "value": "8px" },
      "cardToCard": { "value": "12px" },
      "titleToContent": { "value": "16px" },
      "subTitleToContent": { "value": "20px" },
      "inputForm": { "value": "24px" }
    },
    "radius": {
      "card": { "value": "8px" },
      "button": { "value": "12px" },
      "input": { "value": "16px" },
      "badge": { "value": "1000px" },
      "chipTag": { "value": "1000px" }
    }
  }
}
```

**Dynamic Theme Loader Implementation:**

```dart
class ThemeManager {
  static Future<void> loadStyles() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/styles.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final DesignSystem designSystem = DesignSystem.fromJson(jsonMap);

      // Initialize all design token classes
      AppColors.init(designSystem.sysColor);
      AppDimension.init(designSystem.refDm);
      AppFont.init(designSystem.refTypo);
      AppRadius.init(designSystem.sysDm.radius);
      AppSpacing.init(designSystem.sysDm.spacing);
      AppTheme.init();
    } catch (e) {
      print('Error loading styles: $e');
      // Fallback to default values
    }
  }
}
```

**Type-Safe Design Token Classes:**

```dart
// AppColors - Centralized color management
class AppColors {
  static late ThemeColors _light;
  static late ThemeColors _dark;

  static ThemeColors get light => _light;
  static ThemeColors get dark => _dark;

  static void init(SystemColor sysColor) {
    _light = sysColor.light;
    _dark = sysColor.dark;
  }
}

// AppSpacing - Consistent spacing values
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

// AppRadius - Border radius consistency
class AppRadius {
  static late DesignRadius _radius;

  static double get card => _radius.card;
  static double get button => _radius.button;
  static double get input => _radius.input;
  static double get badge => _radius.badge;
  static double get chipTag => _radius.chipTag;

  static void init(DesignRadius radius) {
    _radius = radius;
  }
}
```

**Utility Functions for JSON Parsing:**

```dart
// Helper functions for converting JSON to Flutter objects
Color colorFromJson(Map<String, dynamic> json) {
  final valueModel = ValueModel.fromJson(json);
  if (valueModel.value.startsWith('rgba')) {
    final rgba = valueModel.value.replaceAll(RegExp(r'rgba\(|\)'), '').split(',');
    return Color.fromRGBO(
      int.parse(rgba[0].trim()),
      int.parse(rgba[1].trim()),
      int.parse(rgba[2].trim()),
      double.parse(rgba[3].trim()),
    );
  }
  final hex = valueModel.value.replaceAll('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}

double doubleFromJson(Map<String, dynamic> json) {
  try {
    final valueModel = ValueModel.fromJson(json);
    return double.parse(valueModel.value.replaceAll('px', ''));
  } catch (e) {
    return 0.0;
  }
}
```

**ThemeData Integration:**

```dart
class AppTheme {
  static late ThemeData _lightTheme;
  static late ThemeData _darkTheme;

  static ThemeData get lightTheme => _lightTheme;
  static ThemeData get darkTheme => _darkTheme;

  static void init() {
    _lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme(),
      useMaterial3: true,
      // Custom theme extensions
      extensions: [
        AppColors.light,
        AppSpacing(),
        AppRadius(),
      ],
    );

    _darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      textTheme: _buildTextTheme(),
      useMaterial3: true,
      extensions: [
        AppColors.dark,
        AppSpacing(),
        AppRadius(),
      ],
    );
  }
}
```

### 2. Kiến Trúc Atomic Design

Kiến trúc Atomic Design chia nhỏ UI thành các thành phần cơ bản (atoms), kết hợp thành các nhóm phức tạp hơn (molecules, organisms). Phương pháp này đảm bảo tính tái sử dụng cao, dễ bảo trì và tạo ra hệ thống component có tổ chức tốt.

#### ✅ Lợi ích & Lý do lựa chọn:

- **Tái sử dụng tối đa**: Một atom có thể được dùng ở hàng trăm nơi khác nhau
- **Tính nhất quán và dễ bảo trì**: Sửa một component ở một nơi duy nhất
- **Tăng tốc độ phát triển**: Lắp ráp màn hình phức tạp từ các khối có sẵn
- **Tư duy có hệ thống**: Buộc đội ngũ suy nghĩ có hệ thống về UI

#### ✅ Triển Khai Kỹ Thuật

**Cấu trúc thư mục theo Atomic Design:**

```
components/
├── atoms/           # Thành phần cơ bản nhất
│   ├── button/
│   │   ├── app_button.dart
│   │   ├── app_button_sheet.dart
│   │   └── app_button_test.dart
│   ├── text/
│   │   ├── app_text.dart
│   │   └── app_text_sheet.dart
│   └── icon/
│       └── app_icon.dart
├── molecules/       # Kết hợp từ atoms
│   ├── search_bar/
│   │   ├── app_search_bar.dart
│   │   └── app_search_bar_sheet.dart
│   ├── form_field/
│   │   ├── app_form_field.dart
│   │   └── app_form_field_sheet.dart
│   └── list_item/
│       ├── app_list_item.dart
│       └── app_list_item_sheet.dart
├── organisms/       # Kết hợp từ molecules
│   ├── header/
│   │   ├── app_header.dart
│   │   └── app_header_sheet.dart
│   ├── product_card/
│   │   ├── app_product_card.dart
│   │   └── app_product_card_sheet.dart
│   └── navigation/
│       ├── app_navigation.dart
│       └── app_navigation_sheet.dart
└── layout/          # Layout components
    ├── h_stack.dart
    ├── v_stack.dart
    ├── spacer.dart
    └── app_padding.dart
```

**Nguyên tắc Composition over Inheritance:**

```dart
// ✅ Tốt: Sử dụng composition
class AppSearchBar extends StatelessWidget {
  final AppButton searchButton;
  final AppTextField searchField;

  const AppSearchBar({
    required this.searchButton,
    required this.searchField,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HStack([
      searchField,
      searchButton,
    ]);
  }
}

// ❌ Tránh: Inheritance
class AppSearchBar extends AppButton {
  // Không nên extend từ component khác
}
```

**Component Hierarchy Implementation:**

```dart
// Atoms - Thành phần cơ bản
class AppButton extends StatelessWidget {
  final ButtonVariant variant;
  final ButtonSize size;
  final String text;
  final VoidCallback? onPressed;

  const AppButton({
    required this.variant,
    required this.size,
    required this.text,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final styleSheet = Theme.of(context).extension<ButtonStyleSheet>();
    final buttonStyle = styleSheet?.resolve(
      variant: variant,
      size: size,
      shape: ButtonShape.rectangle,
    ) ?? const ButtonStyle();

    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

// Molecules - Kết hợp atoms
class AppSearchBar extends StatelessWidget {
  final String placeholder;
  final VoidCallback? onSearch;

  const AppSearchBar({
    required this.placeholder,
    this.onSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HStack([
      Expanded(
        child: AppTextField(
          placeholder: placeholder,
        ),
      ),
      SizedBox(width: AppSpacing.cardToCard),
      AppButton(
        variant: ButtonVariant.primary,
        size: ButtonSize.medium,
        text: 'Search',
        onPressed: onSearch,
      ),
    ]);
  }
}

// Organisms - Kết hợp molecules
class AppHeader extends StatelessWidget {
  final String title;
  final List<AppButton> actions;

  const AppHeader({
    required this.title,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VStack([
      AppText(
        text: title,
        variant: TextVariant.heading,
        size: TextSize.large,
      ),
      SizedBox(height: AppSpacing.titleToContent),
      HStack(actions),
    ]);
  }
}
```

**❌ Điểm yếu & Cách khắc phục:**

- **Cảm thấy cứng nhắc**: Tài liệu hóa và workshop để team làm quen
- **Nguy cơ breaking changes**: Kiểm thử nghiêm ngặt và Semantic Versioning

### 3. Hệ Thống Quản Lý Biến Thể (Variant) với StyleSheet Pattern

Hệ thống quản lý biến thể sử dụng StyleSheet Pattern kết hợp với ThemeExtension để tạo ra các component linh hoạt với nhiều variants (primary, secondary, danger), sizes (small, medium, large), và shapes (rectangle, rounded, pill). Phương pháp này tách biệt hoàn toàn styling logic khỏi component logic, cho phép customization dễ dàng và type-safe.

#### ✅ Lợi ích & Lý do lựa chọn:

**1. Tách biệt hoàn toàn Style và Logic:**

- Style được định nghĩa riêng biệt trong StyleSheet, không phụ thuộc vào logic widget
- Component chỉ focus vào behavior, StyleSheet focus vào appearance
- Dễ dàng maintain và update style mà không ảnh hưởng component logic

**2. Type-Safe Customization:**

- Sử dụng enums cho variants, sizes, shapes đảm bảo compile-time safety
- Function signature của styleBuilder đảm bảo an toàn khi custom style
- IntelliSense support cho tất cả style properties

**3. Flexible Override System:**

- Thông qua `styleBuilder` function, có thể custom style một cách linh hoạt
- Graceful fallback: Luôn có style mặc định, đảm bảo component hoạt động
- Modular approach: Có thể custom từng phần hoặc toàn bộ style

**4. Comprehensive Style Checklist:**

- States: normal, hover, pressed, disabled, loading
- Sizes: small, medium, large với padding, font size tương ứng
- Variants: primary, secondary, danger, ghost, outlined, text
- Shapes: rectangle, rounded, pill với border radius
- Theme modes: light, dark với color schemes
- Content types: text, icon, text+icon với layout logic
- Layout: horizontal, vertical với alignment options
- Animation: transition effects, loading states
- Accessibility: semantics, focus indicators
- Responsive: mobile, tablet, desktop adaptations

#### ✅ Triển Khai Kỹ Thuật

**StyleSheet Pattern với ThemeExtension:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum ButtonVariant { primary, secondary, danger, ghost, outlined, text }
enum ButtonSize { small, medium, large }
enum ButtonShape { rectangle, rounded, pill }

/// ButtonStyleSheet là ThemeExtension với Style Checklist
@immutable
class ButtonStyleSheet extends ThemeExtension<ButtonStyleSheet> {
  // Colors cho các variants
  final Color primaryColor;
  final Color secondaryColor;
  final Color dangerColor;
  final Color ghostColor;
  final Color outlinedColor;
  final Color textColor;

  // Font sizes cho các sizes
  final double smallFontSize;
  final double mediumFontSize;
  final double largeFontSize;

  // Padding cho các sizes
  final EdgeInsets smallPadding;
  final EdgeInsets mediumPadding;
  final EdgeInsets largePadding;

  // Border radius cho các shapes
  final double roundedRadius;
  final double pillRadius;

  const ButtonStyleSheet({
    required this.primaryColor,
    required this.secondaryColor,
    required this.dangerColor,
    required this.ghostColor,
    required this.outlinedColor,
    required this.textColor,
    this.smallFontSize = 12,
    this.mediumFontSize = 14,
    this.largeFontSize = 16,
    this.smallPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.mediumPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.largePadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.roundedRadius = 8.0,
    this.pillRadius = 50.0,
  });

  /// Tạo ButtonStyle từ variant/size/shape với đầy đủ checklist
  ButtonStyle resolve({
    required ButtonVariant variant,
    required ButtonSize size,
    required ButtonShape shape,
  }) {
    final Color bgColor = _getColor(variant);
    final BorderRadius borderRadius = _getShape(shape);
    final (EdgeInsets padding, double fontSize) = _getSize(size);
    final bool isOutlined = variant == ButtonVariant.outlined;
    final bool isText = variant == ButtonVariant.text;

    return ButtonStyle(
      // Background colors cho các trạng thái khác nhau
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return isOutlined || isText ? Colors.transparent : Colors.grey.shade300;
        }
        if (states.contains(MaterialState.pressed)) {
          if (isOutlined || isText) {
            return bgColor.withOpacity(0.1);
          }
          return bgColor.withOpacity(0.7);
        }
        if (states.contains(MaterialState.hovered)) {
          if (isOutlined || isText) {
            return bgColor.withOpacity(0.05);
          }
          return bgColor.withOpacity(0.9);
        }
        return isOutlined || isText ? Colors.transparent : bgColor;
      }),

      // Foreground colors (text/icon colors)
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return (isOutlined || isText ? bgColor : Colors.white).withOpacity(0.5);
        }
        return isOutlined || isText ? bgColor : Colors.white;
      }),

      // Overlay color cho hiệu ứng ripple
      overlayColor: MaterialStateProperty.all(
        isOutlined || isText ? bgColor.withOpacity(0.1) : Colors.white.withOpacity(0.2),
      ),

      // Border cho outlined variant
      side: MaterialStateProperty.all(
        isOutlined ? BorderSide(color: bgColor, width: 1.5) : BorderSide.none,
      ),

      // Padding và text style
      padding: MaterialStateProperty.all(padding),
      textStyle: MaterialStateProperty.all(
        TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
      ),

      // Border radius
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: borderRadius),
      ),

      // Shadow cho elevated buttons
      elevation: MaterialStateProperty.resolveWith((states) {
        if (isOutlined || isText) return 0;
        if (states.contains(MaterialState.disabled)) return 0;
        if (states.contains(MaterialState.pressed)) return 2;
        return 4;
      }),
    );
  }

  // Helper methods
  Color _getColor(ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.primary:
        return primaryColor;
      case ButtonVariant.secondary:
        return secondaryColor;
      case ButtonVariant.danger:
        return dangerColor;
      case ButtonVariant.ghost:
        return ghostColor;
      case ButtonVariant.outlined:
        return outlinedColor;
      case ButtonVariant.text:
        return textColor;
    }
  }

  BorderRadius _getShape(ButtonShape shape) {
    switch (shape) {
      case ButtonShape.rectangle:
        return BorderRadius.zero;
      case ButtonShape.rounded:
        return BorderRadius.circular(roundedRadius);
      case ButtonShape.pill:
        return BorderRadius.circular(pillRadius);
    }
  }

  (EdgeInsets, double) _getSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return (smallPadding, smallFontSize);
      case ButtonSize.medium:
        return (mediumPadding, mediumFontSize);
      case ButtonSize.large:
        return (largePadding, largeFontSize);
    }
  }

  // ThemeExtension implementation
  @override
  ButtonStyleSheet copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? dangerColor,
    Color? ghostColor,
    Color? outlinedColor,
    Color? textColor,
    double? smallFontSize,
    double? mediumFontSize,
    double? largeFontSize,
    EdgeInsets? smallPadding,
    EdgeInsets? mediumPadding,
    EdgeInsets? largePadding,
    double? roundedRadius,
    double? pillRadius,
  }) {
    return ButtonStyleSheet(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      dangerColor: dangerColor ?? this.dangerColor,
      ghostColor: ghostColor ?? this.ghostColor,
      outlinedColor: outlinedColor ?? this.outlinedColor,
      textColor: textColor ?? this.textColor,
      smallFontSize: smallFontSize ?? this.smallFontSize,
      mediumFontSize: mediumFontSize ?? this.mediumFontSize,
      largeFontSize: largeFontSize ?? this.largeFontSize,
      smallPadding: smallPadding ?? this.smallPadding,
      mediumPadding: mediumPadding ?? this.mediumPadding,
      largePadding: largePadding ?? this.largePadding,
      roundedRadius: roundedRadius ?? this.roundedRadius,
      pillRadius: pillRadius ?? this.pillRadius,
    );
  }

  @override
  ButtonStyleSheet lerp(ThemeExtension<ButtonStyleSheet>? other, double t) {
    if (other is! ButtonStyleSheet) return this;

    return ButtonStyleSheet(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      ghostColor: Color.lerp(ghostColor, other.ghostColor, t)!,
      outlinedColor: Color.lerp(outlinedColor, other.outlinedColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      smallFontSize: lerpDouble(smallFontSize, other.smallFontSize, t)!,
      mediumFontSize: lerpDouble(mediumFontSize, other.mediumFontSize, t)!,
      largeFontSize: lerpDouble(largeFontSize, other.largeFontSize, t)!,
      smallPadding: EdgeInsets.lerp(smallPadding, other.smallPadding, t)!,
      mediumPadding: EdgeInsets.lerp(mediumPadding, other.mediumPadding, t)!,
      largePadding: EdgeInsets.lerp(largePadding, other.largePadding, t)!,
      roundedRadius: lerpDouble(roundedRadius, other.roundedRadius, t)!,
      pillRadius: lerpDouble(pillRadius, other.pillRadius, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ButtonStyleSheet &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.dangerColor == dangerColor &&
        other.ghostColor == ghostColor &&
        other.outlinedColor == outlinedColor &&
        other.textColor == textColor &&
        other.smallFontSize == smallFontSize &&
        other.mediumFontSize == mediumFontSize &&
        other.largeFontSize == largeFontSize &&
        other.smallPadding == smallPadding &&
        other.mediumPadding == mediumPadding &&
        other.largePadding == largePadding &&
        other.roundedRadius == roundedRadius &&
        other.pillRadius == pillRadius;
  }

  @override
  int get hashCode {
    return Object.hash(
      primaryColor,
      secondaryColor,
      dangerColor,
      ghostColor,
      outlinedColor,
      textColor,
      smallFontSize,
      mediumFontSize,
      largeFontSize,
      smallPadding,
      mediumPadding,
      largePadding,
      roundedRadius,
      pillRadius,
    );
  }
}
```

**AppButton với StyleBuilder Pattern:**

```dart
class AppButton extends StatelessWidget {
  final ButtonVariant variant;
  final ButtonSize size;
  final ButtonShape shape;
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonStyle? Function(ButtonStyle)? styleBuilder;

  const AppButton({
    required this.variant,
    required this.size,
    required this.shape,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.styleBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final styleSheet = Theme.of(context).extension<ButtonStyleSheet>();

    // Resolve base style from StyleSheet
    final baseStyle = styleSheet?.resolve(
      variant: variant,
      size: size,
      shape: shape,
    ) ?? const ButtonStyle();

    // Apply custom style override if provided
    final finalStyle = styleBuilder?.call(baseStyle) ?? baseStyle;

    // Determine if button should be disabled
    final isDisabled = onPressed == null || isLoading;

    return ElevatedButton(
      style: finalStyle,
      onPressed: isDisabled ? null : onPressed,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  Color _getTextColor() {
    // This would be determined by the current theme and variant
    return Colors.white; // Simplified for example
  }
}
```

**Theme Data Setup:**

```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      extensions: [
        ButtonStyleSheet(
          primaryColor: const Color(0xFF2196F3),
          secondaryColor: const Color(0xFF757575),
          dangerColor: const Color(0xFFF44336),
          ghostColor: const Color(0xFFE3F2FD),
          outlinedColor: const Color(0xFF2196F3),
          textColor: const Color(0xFF2196F3),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: [
        ButtonStyleSheet(
          primaryColor: const Color(0xFF90CAF9),
          secondaryColor: const Color(0xFFBDBDBD),
          dangerColor: const Color(0xFFEF5350),
          ghostColor: const Color(0xFF1A237E),
          outlinedColor: const Color(0xFF90CAF9),
          textColor: const Color(0xFF90CAF9),
        ),
      ],
    );
  }
}
```

**Usage Examples:**

```dart
// Basic usage
AppButton(
  variant: ButtonVariant.primary,
  size: ButtonSize.medium,
  shape: ButtonShape.rounded,
  text: 'Click me',
  onPressed: () => print('Button pressed'),
)

// With icon
AppButton(
  variant: ButtonVariant.secondary,
  size: ButtonSize.large,
  shape: ButtonShape.pill,
  text: 'Download',
  icon: Icon(Icons.download),
  onPressed: () => downloadFile(),
)

// Loading state
AppButton(
  variant: ButtonVariant.primary,
  size: ButtonSize.medium,
  shape: ButtonShape.rectangle,
  text: 'Processing...',
  isLoading: true,
  onPressed: null,
)

// Custom style override
AppButton(
  variant: ButtonVariant.danger,
  size: ButtonSize.small,
  shape: ButtonShape.rounded,
  text: 'Delete',
  styleBuilder: (baseStyle) => baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(Colors.red.shade700),
    foregroundColor: MaterialStateProperty.all(Colors.white),
  ),
  onPressed: () => deleteItem(),
)

// Disabled state
AppButton(
  variant: ButtonVariant.outlined,
  size: ButtonSize.medium,
  shape: ButtonShape.rounded,
  text: 'Disabled',
  onPressed: null, // This makes it disabled
)
```

#### Triển Khai Kỹ Thuật Chi Tiết

**1. Định nghĩa StyleSheet cho Component (Ví dụ: ButtonStyleSheet)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Để sử dụng @immutable

// Định nghĩa ButtonStyleSheet với Style Checklist
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, danger, ghost, outlined, text }
enum ButtonSize { small, medium, large }
enum ButtonShape { rectangle, rounded, pill }

/// ButtonStyleSheet là ThemeExtension với Style Checklist
@immutable
class ButtonStyleSheet extends ThemeExtension<ButtonStyleSheet> {
  // Colors cho các variants
  final Color primaryColor;
  final Color secondaryColor;
  final Color dangerColor;
  final Color ghostColor;
  final Color outlinedColor;
  final Color textColor;

  // Font sizes cho các sizes
  final double smallFontSize;
  final double mediumFontSize;
  final double largeFontSize;

  // Padding cho các sizes
  final EdgeInsets smallPadding;
  final EdgeInsets mediumPadding;
  final EdgeInsets largePadding;

  // Border radius cho các shapes
  final double roundedRadius;
  final double pillRadius;

  const ButtonStyleSheet({
    required this.primaryColor,
    required this.secondaryColor,
    required this.dangerColor,
    required this.ghostColor,
    required this.outlinedColor,
    required this.textColor,
    this.smallFontSize = 12,
    this.mediumFontSize = 14,
    this.largeFontSize = 16,
    this.smallPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.mediumPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.largePadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.roundedRadius = 8.0,
    this.pillRadius = 50.0,
  });

  /// Tạo ButtonStyle từ variant/size/shape với đầy đủ checklist
  ButtonStyle resolve({
    required ButtonVariant variant,
    required ButtonSize size,
    required ButtonShape shape,
  }) {
    final Color bgColor = _getColor(variant);
    final BorderRadius borderRadius = _getShape(shape);
    final (EdgeInsets padding, double fontSize) = _getSize(size);
    final bool isOutlined = variant == ButtonVariant.outlined;
    final bool isText = variant == ButtonVariant.text;

    return ButtonStyle(
      // Background colors cho các trạng thái khác nhau
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return isOutlined || isText ? Colors.transparent : Colors.grey.shade300;
        }
        if (states.contains(MaterialState.pressed)) {
          if (isOutlined || isText) {
            return bgColor.withOpacity(0.1);
          }
          return bgColor.withOpacity(0.7);
        }
        if (states.contains(MaterialState.hovered)) {
          if (isOutlined || isText) {
            return bgColor.withOpacity(0.05);
          }
          return bgColor.withOpacity(0.9);
        }
        return isOutlined || isText ? Colors.transparent : bgColor;
      }),

      // Foreground colors (text/icon colors)
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return (isOutlined || isText ? bgColor : Colors.white).withOpacity(0.5);
        }
        return isOutlined || isText ? bgColor : Colors.white;
      }),

      // Overlay color cho hiệu ứng ripple
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return (isOutlined || isText ? bgColor : Colors.white).withOpacity(0.2);
        }
        if (states.contains(MaterialState.hovered)) {
          return (isOutlined || isText ? bgColor : Colors.white).withOpacity(0.1);
        }
        return Colors.transparent;
      }),

      // Shadow cho các trạng thái
      elevation: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return 0;
        }
        if (states.contains(MaterialState.pressed)) {
          return isOutlined || isText ? 1 : 2;
        }
        if (states.contains(MaterialState.hovered)) {
          return isOutlined || isText ? 2 : 4;
        }
        return isOutlined || isText ? 0 : 3;
      }),

      // Shape và border
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: borderRadius,
      )),

      // Padding
      padding: MaterialStateProperty.all(padding),

      // Text style
      textStyle: MaterialStateProperty.all(TextStyle(fontSize: fontSize)),

      // Side (border) - cho outlined buttons
      side: MaterialStateProperty.resolveWith((states) {
        if (variant != ButtonVariant.outlined) {
          return BorderSide.none;
        }
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(color: bgColor.withOpacity(0.5), width: 2);
        }
        return BorderSide(color: bgColor, width: 2);
      }),

      // Minimum size
      minimumSize: MaterialStateProperty.all(_getMinimumSize(size)),

      // Maximum size
      maximumSize: MaterialStateProperty.all(_getMaximumSize(size)),
    );
  }

  // Helper methods
  Color _getColor(ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.primary:
        return primaryColor;
      case ButtonVariant.secondary:
        return secondaryColor;
      case ButtonVariant.danger:
        return dangerColor;
      case ButtonVariant.ghost:
        return ghostColor;
      case ButtonVariant.outlined:
        return outlinedColor;
      case ButtonVariant.text:
        return textColor;
    }
  }

  BorderRadius _getShape(ButtonShape shape) {
    switch (shape) {
      case ButtonShape.rectangle:
        return BorderRadius.zero;
      case ButtonShape.rounded:
        return BorderRadius.circular(roundedRadius);
      case ButtonShape.pill:
        return BorderRadius.circular(pillRadius);
    }
  }

  (EdgeInsets, double) _getSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return (smallPadding, smallFontSize);
      case ButtonSize.medium:
        return (mediumPadding, mediumFontSize);
      case ButtonSize.large:
        return (largePadding, largeFontSize);
    }
  }

  Size _getMinimumSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const Size(64, 32);
      case ButtonSize.medium:
        return const Size(88, 48);
      case ButtonSize.large:
        return const Size(120, 56);
    }
  }

  Size _getMaximumSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const Size(double.infinity, 40);
      case ButtonSize.medium:
        return const Size(double.infinity, 56);
      case ButtonSize.large:
        return const Size(double.infinity, 64);
    }
  }

  // Triển khai copyWith để tạo một bản sao với các thuộc tính được thay đổi
  @override
  ButtonStyleSheet copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? dangerColor,
    Color? ghostColor,
    Color? outlinedColor,
    Color? textColor,
    double? smallFontSize,
    double? mediumFontSize,
    double? largeFontSize,
    EdgeInsets? smallPadding,
    EdgeInsets? mediumPadding,
    EdgeInsets? largePadding,
    double? roundedRadius,
    double? pillRadius,
  }) {
    return ButtonStyleSheet(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      dangerColor: dangerColor ?? this.dangerColor,
      ghostColor: ghostColor ?? this.ghostColor,
      outlinedColor: outlinedColor ?? this.outlinedColor,
      textColor: textColor ?? this.textColor,
      smallFontSize: smallFontSize ?? this.smallFontSize,
      mediumFontSize: mediumFontSize ?? this.mediumFontSize,
      largeFontSize: largeFontSize ?? this.largeFontSize,
      smallPadding: smallPadding ?? this.smallPadding,
      mediumPadding: mediumPadding ?? this.mediumPadding,
      largePadding: largePadding ?? this.largePadding,
      roundedRadius: roundedRadius ?? this.roundedRadius,
      pillRadius: pillRadius ?? this.pillRadius,
    );
  }

  // Triển khai lerp (linear interpolation) để hỗ trợ chuyển đổi giữa các theme
  // Điều này rất hữu ích khi bạn có các chủ đề sáng/tối hoặc chuyển đổi mượt mà
  @override
  ButtonStyleSheet lerp(covariant ThemeExtension<ButtonStyleSheet>? other, double t) {
    if (other is! ButtonStyleSheet) {
      return this;
    }
    return ButtonStyleSheet(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      ghostColor: Color.lerp(ghostColor, other.ghostColor, t)!,
      outlinedColor: Color.lerp(outlinedColor, other.outlinedColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      smallFontSize: lerpDouble(smallFontSize, other.smallFontSize, t)!,
      mediumFontSize: lerpDouble(mediumFontSize, other.mediumFontSize, t)!,
      largeFontSize: lerpDouble(largeFontSize, other.largeFontSize, t)!,
      smallPadding: EdgeInsets.lerp(smallPadding, other.smallPadding, t)!,
      mediumPadding: EdgeInsets.lerp(mediumPadding, other.mediumPadding, t)!,
      largePadding: EdgeInsets.lerp(largePadding, other.largePadding, t)!,
      roundedRadius: lerpDouble(roundedRadius, other.roundedRadius, t)!,
      pillRadius: lerpDouble(pillRadius, other.pillRadius, t)!,
    );
  }

  // Ghi đè hashCode và operator == để so sánh đối tượng
  @override
  int get hashCode => Object.hash(
    primaryColor, secondaryColor, dangerColor, ghostColor, outlinedColor, textColor,
    smallFontSize, mediumFontSize, largeFontSize,
    smallPadding, mediumPadding, largePadding,
    roundedRadius, pillRadius,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ButtonStyleSheet &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.dangerColor == dangerColor &&
        other.ghostColor == ghostColor &&
        other.outlinedColor == outlinedColor &&
        other.textColor == textColor &&
        other.smallFontSize == smallFontSize &&
        other.mediumFontSize == mediumFontSize &&
        other.largeFontSize == largeFontSize &&
        other.smallPadding == smallPadding &&
        other.mediumPadding == mediumPadding &&
        other.largePadding == largePadding &&
        other.roundedRadius == roundedRadius &&
        other.pillRadius == pillRadius;
  }
}
```

**Giải thích các thành phần:**

- **@immutable**: Annotation này cho biết lớp là bất biến (immutable), tức là các thuộc tính của nó không thể thay đổi sau khi khởi tạo. Điều này quan trọng cho hiệu suất và tính nhất quán.

- **copyWith**: Phương thức này cho phép tạo một bản sao của StyleSheet với một số thuộc tính được sửa đổi. Đây là pattern phổ biến trong Flutter để làm việc với các đối tượng bất biến.

- **lerp**: Viết tắt của "linear interpolation". Phương thức này được sử dụng để nội suy giữa hai phiên bản của StyleSheet. Nó cực kỳ hữu ích khi muốn hỗ trợ chuyển đổi theme mượt mà.

- **hashCode và operator ==**: Việc ghi đè các phương thức này đảm bảo rằng các đối tượng ButtonStyleSheet có thể được so sánh đúng cách, quan trọng cho caching và kiểm tra sự thay đổi.

**2. Thêm StyleSheet vào ThemeData**

```dart
// Định nghĩa các token cơ bản của bạn (ví dụ từ một tệp constants.dart hoặc design_tokens.dart)
const Color primaryColor = Color(0xFF6200EE);
const Color secondaryColor = Color(0xFF03DAC6);
const Color textColor = Colors.white;
const Color onSurfaceColor = Color(0xFF212121);
const Color borderColor = Color(0xFFBDBDBD);

// Tạo một Theme Data (ví dụ: Light Theme)
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Colors.white,
    onSurface: onSurfaceColor,
  ),
    // Thêm các StyleSheet vào extensions
  extensions: <ThemeExtension<dynamic>>[
    ButtonStyleSheet(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      dangerColor: const Color(0xFFDC3545),
      ghostColor: const Color(0xFF6C757D),
      outlinedColor: primaryColor,
      textColor: primaryColor,
      smallFontSize: 12,
      mediumFontSize: 14,
      largeFontSize: 16,
      smallPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      mediumPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      largePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      roundedRadius: 8.0,
      pillRadius: 50.0,
    ),
    // Bạn có thể thêm các StyleSheet khác cho các component khác ở đây
    // Ví dụ: TextFieldStyleSheet, CardStyleSheet, v.v.
  ],
);
```

**3. Sử dụng trong Component (Ví dụ: AppButton)**

```dart
// AppButton Widget
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final ButtonShape shape;
  final ButtonStyle Function(ButtonStyle baseStyle)? styleBuilder; // Kỹ thuật override

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.shape = ButtonShape.rounded,
    this.styleBuilder, // Cho phép override style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy StyleSheet từ Theme với fallback
    final buttonStyles = Theme.of(context).extension<ButtonStyleSheet>();

    // Lấy base style với fallback
    final ButtonStyle baseStyle = _getBaseStyleWithFallback(buttonStyles);

    // Áp dụng styleBuilder nếu có, nếu không thì dùng baseStyle
    final ButtonStyle finalStyle = styleBuilder?.call(baseStyle) ?? baseStyle;

    return ElevatedButton(
      onPressed: onPressed,
      style: finalStyle,
      child: Text(text),
    );
  }

  ButtonStyle _getBaseStyleWithFallback(ButtonStyleSheet? styles) {
    // Nếu không có styles từ theme, sử dụng fallback
    if (styles == null) {
      return _getFallbackStyle();
    }

    // Sử dụng resolve method với đầy đủ checklist
    return styles.resolve(
      variant: variant,
      size: size,
      shape: shape,
    );
  }

  ButtonStyle _getFallbackStyle() {
    // Fallback style khi không có theme
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.blue),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      )),
    );
  }
}

// Định nghĩa Enum cho các biến thể nút
enum ButtonVariant {
  primary,
  secondary,
  outlined,
  text,
}

// Ví dụ sử dụng AppButton với Style Checklist
// 1. Sử dụng cơ bản với đầy đủ checklist
AppButton(
  text: 'Submit',
  onPressed: () => submitForm(),
  variant: ButtonVariant.primary,
  size: ButtonSize.medium,
  shape: ButtonShape.rounded,
)

// 2. Button với size và shape khác nhau
AppButton(
  text: 'Small Pill',
  onPressed: () => smallAction(),
  variant: ButtonVariant.secondary,
  size: ButtonSize.small,
  shape: ButtonShape.pill,
)

// 3. Danger button với large size
AppButton(
  text: 'Delete',
  onPressed: () => deleteAction(),
  variant: ButtonVariant.danger,
  size: ButtonSize.large,
  shape: ButtonShape.rounded,
)

// 4. Ghost button với rectangle shape
AppButton(
  text: 'Cancel',
  onPressed: () => cancelAction(),
  variant: ButtonVariant.ghost,
  size: ButtonSize.medium,
  shape: ButtonShape.rectangle,
)

// 5. Override style với styleBuilder
AppButton(
  text: 'Custom Button',
  onPressed: () => customAction(),
  variant: ButtonVariant.primary,
  size: ButtonSize.medium,
  shape: ButtonShape.rounded,
  styleBuilder: (baseStyle) => baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(Colors.red),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
  ),
)

// 6. Outlined button với custom border
AppButton(
  text: 'Outlined',
  onPressed: () => outlinedAction(),
  variant: ButtonVariant.outlined,
  size: ButtonSize.medium,
  shape: ButtonShape.rounded,
  styleBuilder: (baseStyle) => baseStyle.copyWith(
    side: MaterialStateProperty.all(const BorderSide(color: Colors.blue, width: 3)),
  ),
)
```

**4. Tích hợp với Design Token Manager**

```dart
class DesignTokenManager {
  static final Map<String, ThemeData> _themeCache = {};

  static ThemeData createThemeFromTokens(Map<String, dynamic> tokens) {
    return ThemeData(
      // ... other theme properties
      extensions: <ThemeExtension<dynamic>>[
        ButtonStyleSheet(
          primary: _createButtonStyle(tokens['button']['primary']),
          secondary: _createButtonStyle(tokens['button']['secondary']),
          outlined: _createButtonStyle(tokens['button']['outlined']),
          text: _createButtonStyle(tokens['button']['text']),
        ),
        // ... other component stylesheets
      ],
    );
  }

  static ButtonStyle _createButtonStyle(Map<String, dynamic> tokenData) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(tokenData['backgroundColor'])),
      foregroundColor: MaterialStateProperty.all(Color(tokenData['foregroundColor'])),
      padding: MaterialStateProperty.all(EdgeInsets.all(tokenData['padding'])),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokenData['borderRadius']),
      )),
    );
  }
}
```

#### Code Generation Setup

```yaml
# pubspec.yaml
dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_annotation: ^4.8.0

dependencies:
  json_annotation: ^4.8.0
```

```dart
// Tự động generate StyleSheet từ JSON
@JsonSerializable()
class ButtonTokens {
  final Map<String, dynamic> primary;
  final Map<String, dynamic> secondary;
  final Map<String, dynamic> outlined;
  final Map<String, dynamic> text;

  ButtonTokens({
    required this.primary,
    required this.secondary,
    required this.outlined,
    required this.text,
  });

  factory ButtonTokens.fromJson(Map<String, dynamic> json) =>
      _$ButtonTokensFromJson(json);
}
```

### 4. Layout Components

Layout Components cung cấp các widget tiêu chuẩn để tạo layout linh hoạt và nhất quán, thay thế cho Row, Column với spacing tự động và responsive design. Hệ thống này đảm bảo tính nhất quán trong spacing, alignment và responsive behavior across toàn bộ ứng dụng.

#### ✅ Lợi ích & Lý do lựa chọn:

**1. Consistent Spacing System:**

- Loại bỏ hoàn toàn "magic number" trong layout
- Sử dụng design tokens cho spacing từ style_module
- Đảm bảo visual consistency across toàn bộ ứng dụng

**2. Simplified Layout Code:**

- Giảm đáng kể boilerplate code so với Row/Column thông thường
- API đơn giản và intuitive cho developer
- Automatic spacing management

**3. Responsive Design Support:**

- Built-in responsive behavior cho mobile, tablet, desktop
- Adaptive layout dựa trên screen size
- Consistent breakpoints và behavior

**4. Flexible Alignment Options:**

- Hỗ trợ tất cả alignment patterns (start, center, end, spaceBetween, spaceAround)
- Cross-axis alignment cho complex layouts
- Easy customization cho specific use cases

**5. Developer Experience (DX) Enhancement:**

- Code viết nhanh hơn, an toàn hơn, dễ đọc hơn
- Ngữ nghĩa của HStack, VStack rõ ràng hơn Row, Column
- Thiết kế nhất quán: Buộc các nhà phát triển tuân thủ hệ thống thiết kế

#### ✅ Triển Khai Kỹ Thuật

**Core Layout Components với Design Token Integration:**

```dart
import 'package:flutter/material.dart';
import 'package:style_module/theme/app_spacing.dart';

// Enum để code dễ đọc hơn
enum StackAlignment {
  start,
  center,
  end,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

// Widget cơ sở FlexStack để tránh lặp code
class FlexStack extends StatelessWidget {
  final Axis direction;
  final List<Widget> children;
  final double spacing;
  final StackAlignment alignment;
  final CrossAxisAlignment crossAlignment;

  const FlexStack({
    super.key,
    required this.direction,
    required this.children,
    this.spacing = 0,
    this.alignment = StackAlignment.start,
    this.crossAlignment = CrossAxisAlignment.center,
  });

  // Hàm helper để map enum với thuộc tính của Flutter
  MainAxisAlignment _mapAlignment() {
    switch (alignment) {
      case StackAlignment.start:
        return MainAxisAlignment.start;
      case StackAlignment.center:
        return MainAxisAlignment.center;
      case StackAlignment.end:
        return MainAxisAlignment.end;
      case StackAlignment.spaceBetween:
        return MainAxisAlignment.spaceBetween;
      case StackAlignment.spaceAround:
        return MainAxisAlignment.spaceAround;
      case StackAlignment.spaceEvenly:
        return MainAxisAlignment.spaceEvenly;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic chính để thêm khoảng cách vào giữa các children
    final spacedChildren = <Widget>[];
    if (children.isNotEmpty) {
      for (int i = 0; i < children.length; i++) {
        spacedChildren.add(children[i]);
        if (i < children.length - 1) {
          spacedChildren.add(SizedBox(
            width: direction == Axis.horizontal ? spacing : 0,
            height: direction == Axis.vertical ? spacing : 0,
          ));
        }
      }
    }

    return Flex(
      direction: direction,
      mainAxisAlignment: _mapAlignment(),
      crossAxisAlignment: crossAlignment,
      children: spacedChildren,
    );
  }
}

// HStack - Horizontal layout với spacing tự động
class HStack extends FlexStack {
  const HStack(
    List<Widget> children, {
    super.key,
    double spacing = 0,
    StackAlignment alignment = StackAlignment.start,
    CrossAxisAlignment crossAlignment = CrossAxisAlignment.center,
  }) : super(
    direction: Axis.horizontal,
    children: children,
    spacing: spacing,
    alignment: alignment,
    crossAlignment: crossAlignment,
  );
}

// VStack - Vertical layout với spacing tự động
class VStack extends FlexStack {
  const VStack(
    List<Widget> children, {
    super.key,
    double spacing = 0,
    StackAlignment alignment = StackAlignment.start,
    CrossAxisAlignment crossAlignment = CrossAxisAlignment.start,
  }) : super(
    direction: Axis.vertical,
    children: children,
    spacing: spacing,
    alignment: alignment,
    crossAlignment: crossAlignment,
  );
}

// AppSpacer - Flexible space với configurable flex
class AppSpacer extends StatelessWidget {
  final double flex;

  const AppSpacer({this.flex = 1, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex.toInt(), child: const SizedBox());
  }
}

// AppPadding - Consistent padding với design tokens từ style_module
class AppPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AppPaddingSize size;

  const AppPadding({
    required this.child,
    this.padding,
    this.size = AppPaddingSize.medium,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = _getPadding(size);
    return Padding(
      padding: padding ?? defaultPadding,
      child: child,
    );
  }

  EdgeInsets _getPadding(AppPaddingSize size) {
    switch (size) {
      case AppPaddingSize.small:
        return EdgeInsets.all(AppSpacing.blockToBlock);
      case AppPaddingSize.medium:
        return EdgeInsets.all(AppSpacing.cardToCard);
      case AppPaddingSize.large:
        return EdgeInsets.all(AppSpacing.titleToContent);
    }
  }
}

// ResponsiveContainer - Adaptive layout cho different screen sizes
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    required this.child,
    this.maxWidth,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? _getMaxWidth(context),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(AppSpacing.cardToCard),
          child: child,
        ),
      ),
    );
  }

  double _getMaxWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 1200; // Desktop
    if (screenWidth > 768) return 768;   // Tablet
    return screenWidth;                   // Mobile
  }
}

// Grid - Flexible grid layout
class Grid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const Grid({
    required this.children,
    required this.crossAxisCount,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.childAspectRatio = 1.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
```

**Layout Enums và Constants:**

```dart
enum AppPaddingSize { small, medium, large }

enum LayoutAlignment {
  start,
  center,
  end,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}
```

**Usage Examples với Design Token Integration:**

```dart
// Basic horizontal layout với spacing từ design tokens
HStack([
  AppText('Hello'),
  AppIcon(Icons.star),
  AppSpacer(),
  AppButton(
    variant: ButtonVariant.primary,
    size: ButtonSize.medium,
    text: 'Click me',
    onPressed: () {},
  ),
], spacing: AppSpacing.blockToBlock)

// Vertical layout với spacing từ design tokens
VStack([
  AppText('Title', variant: TextVariant.heading),
  AppText('Description', variant: TextVariant.body),
  HStack([
    AppButton(
      variant: ButtonVariant.primary,
      size: ButtonSize.medium,
      text: 'Save',
      onPressed: () {},
    ),
    AppButton(
      variant: ButtonVariant.secondary,
      size: ButtonSize.medium,
      text: 'Cancel',
      onPressed: () {},
    ),
  ], spacing: AppSpacing.blockToBlock),
], spacing: AppSpacing.titleToContent)

// Responsive layout với design tokens
ResponsiveContainer(
  child: VStack([
    AppText('Responsive Title'),
    Grid(
      children: [
        AppCard(child: AppText('Item 1')),
        AppCard(child: AppText('Item 2')),
        AppCard(child: AppText('Item 3')),
        AppCard(child: AppText('Item 4')),
      ],
      crossAxisCount: _getCrossAxisCount(context),
      crossAxisSpacing: AppSpacing.blockToBlock,
      mainAxisSpacing: AppSpacing.blockToBlock,
    ),
  ], spacing: AppSpacing.titleToContent),
)

// Complex layout với nested components và design tokens
AppPadding(
  size: AppPaddingSize.large,
  child: VStack([
    // Header
    HStack([
      AppText('Dashboard', variant: TextVariant.heading),
      AppSpacer(),
      AppButton(
        variant: ButtonVariant.ghost,
        size: ButtonSize.small,
        icon: Icon(Icons.settings),
        text: 'Settings',
        onPressed: () {},
      ),
    ], alignment: StackAlignment.spaceBetween),

    // Content
    Grid(
      children: [
        AppCard(
          child: VStack([
            AppIcon(Icons.analytics),
            AppText('Analytics', variant: TextVariant.subheading),
            AppText('View your data', variant: TextVariant.caption),
          ], spacing: AppSpacing.blockToBlock),
        ),
        AppCard(
          child: VStack([
            AppIcon(Icons.people),
            AppText('Users', variant: TextVariant.subheading),
            AppText('Manage users', variant: TextVariant.caption),
          ], spacing: AppSpacing.blockToBlock),
        ),
      ],
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.cardToCard,
      mainAxisSpacing: AppSpacing.cardToCard,
    ),
  ], spacing: AppSpacing.titleToContent),
)
```

**❌ Điểm yếu & Cách khắc phục:**

- **Chi phí hiệu năng nhỏ**: Giữ implementation đơn giản, cung cấp escape hatch cho Row/Column khi cần
- **Learning curve**: Documentation và examples để team làm quen
- **Flexibility trade-off**: Cung cấp customization options cho edge cases

### 5. Slot Pattern cho Complex Components

Slot Pattern là một kỹ thuật mạnh mẽ để tạo ra các component linh hoạt và có thể tái sử dụng cao. Thay vì nhận các giá trị nguyên thủy (String, IconData), component sẽ nhận hẳn các Widget, cho phép người dùng "nhét" bất cứ thứ gì họ muốn vào các "khe cắm" (slot) đã được định nghĩa.

#### ✅ Lợi ích & Lý do lựa chọn:

**1. Maximum Flexibility:**

- Cho phép tạo ra vô số biến thể UI từ một component cơ sở
- Người dùng có thể "nhét" bất cứ Widget nào vào các slot
- Không bị giới hạn bởi các prop cứng nhắc

**2. Composition over Inheritance:**

- Tuân thủ triệt để nguyên tắc Composition trong Flutter
- Dễ dàng kết hợp các component với nhau
- Tránh được các vấn đề của inheritance

**3. Reusable & Maintainable:**

- Một component có thể được sử dụng cho nhiều use case khác nhau
- Dễ dàng maintain và extend
- Code sạch và có tổ chức

**4. Type-Safe & Intuitive:**

- API rõ ràng và intuitive
- Compile-time safety với Widget types
- IntelliSense support đầy đủ

#### ✅ Triển Khai Kỹ Thuật

**AppListItem với Slot Pattern:**

```dart
import 'package:flutter/material.dart';
import 'package:style_module/theme/app_spacing.dart';

class AppListItem extends StatelessWidget {
  /// Slot bên trái, thường là Icon hoặc Avatar
  final Widget? leading;

  /// Slot nội dung chính, bắt buộc
  final Widget title;

  /// Slot nội dung phụ, bên dưới title
  final Widget? subtitle;

  /// Slot bên phải, thường là Icon, Switch, hoặc Button
  final Widget? trailing;

  /// Callback khi tap vào item
  final VoidCallback? onTap;

  /// Custom padding cho item
  final EdgeInsetsGeometry? padding;

  const AppListItem({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppSpacing.cardToCard),
        child: HStack([
          if (leading != null) leading!,
          Expanded(
            child: VStack([
              title,
              if (subtitle != null) subtitle!,
            ], spacing: AppSpacing.blockToBlock / 2),
          ),
          if (trailing != null) trailing!,
        ], spacing: AppSpacing.cardToCard),
      ),
    );
  }
}
```

**AppCard với Slot Pattern:**

```dart
class AppCard extends StatelessWidget {
  /// Slot header của card
  final Widget? header;

  /// Slot content chính của card
  final Widget content;

  /// Slot footer của card
  final Widget? footer;

  /// Slot actions của card (thường là buttons)
  final List<Widget>? actions;

  /// Custom padding cho card
  final EdgeInsetsGeometry? padding;

  /// Background color của card
  final Color? backgroundColor;

  /// Border radius của card
  final BorderRadius? borderRadius;

  /// Shadow của card
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    this.header,
    required this.content,
    this.footer,
    this.actions,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.card),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: VStack([
        if (header != null) header!,
        Padding(
          padding: padding ?? EdgeInsets.all(AppSpacing.cardToCard),
          child: content,
        ),
        if (footer != null) footer!,
        if (actions != null)
          Padding(
            padding: EdgeInsets.all(AppSpacing.cardToCard),
            child: HStack(actions!, alignment: StackAlignment.end),
          ),
      ], spacing: 0),
    );
  }
}
```

**AppDialog với Slot Pattern:**

```dart
class AppDialog extends StatelessWidget {
  /// Slot title của dialog
  final Widget? title;

  /// Slot content chính của dialog
  final Widget content;

  /// Slot actions của dialog
  final List<Widget>? actions;

  /// Custom padding cho dialog
  final EdgeInsetsGeometry? padding;

  /// Background color của dialog
  final Color? backgroundColor;

  /// Border radius của dialog
  final BorderRadius? borderRadius;

  const AppDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppSpacing.titleToContent),
        child: VStack([
          if (title != null) title!,
          content,
          if (actions != null)
            HStack(actions!, alignment: StackAlignment.end),
        ], spacing: AppSpacing.cardToCard),
      ),
    );
  }
}
```

**Usage Examples với Slot Pattern:**

```dart
// AppListItem - User profile
AppListItem(
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),
  title: AppText('John Doe', variant: TextVariant.heading),
  subtitle: AppText('@johndoe', variant: TextVariant.caption),
  trailing: AppButton(
    variant: ButtonVariant.primary,
    size: ButtonSize.small,
    text: 'Follow',
    onPressed: () {},
  ),
  onTap: () => navigateToProfile(),
)

// AppListItem - Settings menu
AppListItem(
  leading: Icon(Icons.notifications, color: AppColors.primary),
  title: AppText('Notifications', variant: TextVariant.body),
  trailing: Switch(
    value: true,
    onChanged: (value) => toggleNotifications(),
  ),
  onTap: () => navigateToNotifications(),
)

// AppCard - Product card
AppCard(
  header: Image.network(
    'https://example.com/product.jpg',
    height: 200,
    fit: BoxFit.cover,
  ),
  content: VStack([
    AppText('Product Name', variant: TextVariant.heading),
    AppText('Product description goes here...', variant: TextVariant.body),
    HStack([
      AppText('\$99.99', variant: TextVariant.heading),
      AppSpacer(),
      AppText('4.5 ★', variant: TextVariant.caption),
    ]),
  ], spacing: AppSpacing.blockToBlock),
  actions: [
    AppButton(
      variant: ButtonVariant.secondary,
      size: ButtonSize.small,
      text: 'Add to Cart',
      onPressed: () {},
    ),
    AppButton(
      variant: ButtonVariant.primary,
      size: ButtonSize.small,
      text: 'Buy Now',
      onPressed: () {},
    ),
  ],
)

// AppDialog - Confirmation dialog
AppDialog(
  title: AppText('Confirm Action', variant: TextVariant.heading),
  content: AppText(
    'Are you sure you want to delete this item?',
    variant: TextVariant.body,
  ),
  actions: [
    AppButton(
      variant: ButtonVariant.secondary,
      size: ButtonSize.medium,
      text: 'Cancel',
      onPressed: () => Navigator.pop(context),
    ),
    AppButton(
      variant: ButtonVariant.danger,
      size: ButtonSize.medium,
      text: 'Delete',
      onPressed: () => deleteItem(),
    ),
  ],
)

// Complex nested components với Slot Pattern
AppCard(
  header: HStack([
    AppIcon(Icons.analytics),
    AppSpacer(),
    AppButton(
      variant: ButtonVariant.ghost,
      size: ButtonSize.small,
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    ),
  ]),
  content: VStack([
    AppText('Analytics Overview', variant: TextVariant.heading),
    AppText('Last 30 days', variant: TextVariant.caption),
    SizedBox(height: AppSpacing.titleToContent),
    Grid(
      children: [
        AppCard(
          content: VStack([
            AppText('Revenue', variant: TextVariant.subheading),
            AppText('\$12,345', variant: TextVariant.heading),
          ], spacing: AppSpacing.blockToBlock),
        ),
        AppCard(
          content: VStack([
            AppText('Users', variant: TextVariant.subheading),
            AppText('1,234', variant: TextVariant.heading),
          ], spacing: AppSpacing.blockToBlock),
        ),
      ],
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.blockToBlock,
      mainAxisSpacing: AppSpacing.blockToBlock,
    ),
  ], spacing: AppSpacing.titleToContent),
  footer: AppText('Updated 2 hours ago', variant: TextVariant.caption),
)
```

**❌ Điểm yếu & Cách khắc phục:**

- **Over-abstraction**: Cần cẩn thận để không tạo ra các abstraction quá cứng nhắc
- **Performance impact**: Việc thêm một vài lớp widget có thể tăng nhẹ độ sâu của widget tree
- **Learning curve**: Documentation và examples để team làm quen với Slot Pattern

---

## Roadmap Triển Khai

### Phase 1: Foundation (Tuần 1-2)

- [ ] Setup project structure và development environment
- [ ] Implement core design tokens và theme system
- [ ] Create basic atomic components (Button, Text, Icon)
- [ ] Setup testing framework và CI/CD pipeline
- [ ] Document coding standards và contribution guidelines
- [ ] Implement style_module integration

### Phase 2: Core Components (Tuần 3-4)

- [ ] Develop layout components (HStack, VStack, Spacer, AppPadding)
- [ ] Implement variant management system với StyleSheet pattern
- [ ] Create complex components với slot pattern
- [ ] Add comprehensive unit tests
- [ ] Performance optimization và bundle size analysis
- [ ] Implement responsive design system

### Phase 3: Advanced Features (Tuần 5-6)

- [ ] Add accessibility features (semantic labels, screen reader support)
- [ ] Create animation system và micro-interactions
- [ ] Develop component playground và documentation site
- [ ] Integration testing với existing projects
- [ ] Implement CMS-driven theming capabilities
- [ ] Add visual regression testing

### Phase 4: Production Ready (Tuần 7-8)

- [ ] Security audit và vulnerability scanning
- [ ] Performance benchmarking và optimization
- [ ] Documentation completion và video tutorials
- [ ] Team training và knowledge transfer
- [ ] Production deployment và monitoring setup
- [ ] Multi-project integration testing

## Công Cụ và Technologies

### Development Tools

- **Flutter SDK:** Latest stable version (3.x)
- **Dart:** Strong typing và null safety
- **VS Code/Android Studio:** IDE với Flutter extensions
- **Git:** Version control với conventional commits
- **GitHub/GitLab:** Repository management

### Testing Framework

- **flutter_test:** Unit và widget testing
- **integration_test:** End-to-end testing
- **golden_toolkit:** Visual regression testing
- **mockito:** Mocking cho testing
- **coverage:** Code coverage reporting

### CI/CD Pipeline

- **GitHub Actions:** Automated testing và deployment
- **Codecov:** Coverage reporting
- **SonarQube:** Code quality analysis
- **Firebase App Distribution:** Beta testing distribution
- **Fastlane:** Automated deployment

### Documentation Tools

- **dartdoc:** API documentation generation
- **Storybook (Flutter):** Component playground
- **Notion/Confluence:** Project documentation
- **Figma:** Design system collaboration
- **Loom:** Video tutorials và walkthroughs

## Success Metrics và KPIs

### Development Efficiency

- **Time to market:** Giảm 50% cho new features
- **Code duplication:** Giảm 85% across projects
- **Bug reduction:** 70% fewer UI-related bugs
- **Developer productivity:** 40% increase in feature delivery
- **Design token adoption:** 90%+ component usage

### Quality Assurance

- **Test coverage:** Maintain 90%+ coverage
- **Performance:** < 16ms render time
- **Accessibility:** WCAG 2.1 AA compliance
- **Cross-platform consistency:** 95%+ visual parity
- **Type safety:** 100% null safety compliance

### Business Impact

- **Development cost:** 30% reduction in UI development
- **Maintenance overhead:** 60% reduction in bug fixes
- **Time to onboard:** 70% faster developer onboarding
- **Design consistency:** 95%+ brand compliance
- **Multi-project efficiency:** 80% code sharing

## Risk Management

### Technical Risks

- **Performance degradation:** Regular benchmarking và optimization
- **Breaking changes:** Semantic versioning và migration guides
- **Bundle size bloat:** Automated size monitoring
- **Compatibility issues:** Comprehensive testing matrix
- **Style token conflicts:** Centralized token management

### Process Risks

- **Adoption resistance:** Training và change management
- **Documentation gaps:** Continuous documentation updates
- **Knowledge silos:** Cross-team knowledge sharing
- **Scope creep:** Strict feature prioritization
- **Multi-project coordination:** Centralized governance

### Mitigation Strategies

- **Regular code reviews:** Peer review requirements
- **Automated testing:** Comprehensive test suites
- **Performance monitoring:** Real-time performance tracking
- **Stakeholder communication:** Weekly progress updates
- **Style token governance:** Centralized design system management

## Training và Knowledge Transfer

### Developer Training

- **Component usage workshops:** Hands-on training sessions
- **Best practices documentation:** Comprehensive guides
- **Code review sessions:** Regular peer learning
- **Performance optimization training:** Advanced techniques
- **Style token system training:** Design system integration

### Design Team Integration

- **Design system workshops:** Collaborative design sessions
- **Component specification reviews:** Design-dev alignment
- **Prototype sharing:** Rapid iteration cycles
- **Accessibility training:** Inclusive design principles
- **Token system collaboration:** Design-dev token workflow

### Documentation Strategy

- **Interactive documentation:** Live component examples
- **Video tutorials:** Step-by-step implementation guides
- **Troubleshooting guides:** Common issues và solutions
- **Migration guides:** Version upgrade assistance
- **Style token documentation:** Comprehensive token reference

## Monitoring và Maintenance

### Performance Monitoring

- **Render time tracking:** Automated performance testing
- **Memory usage monitoring:** Memory leak detection
- **Bundle size tracking:** Automated size alerts
- **User experience metrics:** Real user monitoring
- **Style token performance:** Token usage optimization

### Quality Assurance

- **Automated testing:** Continuous integration testing
- **Visual regression testing:** Automated UI comparison
- **Accessibility testing:** Automated a11y compliance
- **Cross-platform testing:** Multi-device testing
- **Style consistency testing:** Automated design compliance

### Maintenance Schedule

- **Weekly:** Performance review và optimization
- **Monthly:** Security updates và dependency management
- **Quarterly:** Major feature updates và breaking changes
- **Annually:** Architecture review và refactoring
- **Continuous:** Style token updates và design system evolution

## Số Liệu Thành Công

### Hiệu Quả Phát Triển

- **Thời gian phát triển component mới:** Giảm 60-80%
- **Code reusability:** Tăng từ 20% lên 85%
- **Consistency score:** Đạt 95%+ across projects
- **Developer onboarding:** Giảm từ 2 tuần xuống 3 ngày
- **Design-to-code time:** Giảm 70% với design tokens

### Chất Lượng Code

- **Type safety:** 100% với null safety và strong typing
- **Test coverage:** Mục tiêu 90%+ cho core components
- **Performance:** < 16ms render time cho complex layouts
- **Bundle size:** Tối ưu < 2MB cho component library
- **Accessibility:** WCAG 2.1 AA compliance

### Metrics Tracking

- **Component usage analytics:** Track frequency và performance
- **Error monitoring:** Real-time alerting cho breaking changes
- **Performance monitoring:** Automated performance regression testing
- **Developer satisfaction:** Quarterly surveys và feedback collection
- **Design token adoption:** Usage tracking across projects

### Business Impact

- **Development cost:** 30% reduction in UI development
- **Maintenance overhead:** 60% reduction in bug fixes
- **Time to onboard:** 70% faster developer onboarding
- **Design consistency:** 95%+ brand compliance
- **Multi-project efficiency:** 80% code sharing

---

## Conclusion

### Tóm Tắt Giá Trị

Hệ thống Flutter Component Kit sẽ mang lại:

- **Hiệu quả phát triển** tăng 60-80%
- **Chất lượng UI** đồng nhất 95%+
- **Chi phí bảo trì** giảm 70%+
- **Tốc độ thay đổi thiết kế** nhanh gấp 10 lần
- **Multi-project efficiency** 80% code sharing

### Điểm Mạnh Của Giải Pháp

1. **Kỹ thuật hiện đại:** JSON-based tokens, Atomic Design, Type-safe variants
2. **Linh hoạt cao:** Dễ dàng thay đổi, tùy biến UI và layout với StyleSheet pattern
3. **Khả năng mở rộng:** Hỗ trợ đa dự án, đa nền tảng với layout components
4. **Tương lai bền vững:** Chuẩn bị cho CMS-driven theming, A/B testing
5. **Design integration:** Seamless integration với style_module và design tokens

### Cam Kết Chất Lượng

- **Code sạch:** Tuân thủ Flutter best practices
- **Test coverage:** Unit test, widget test, visual regression test
- **Documentation:** Hướng dẫn chi tiết cho developer
- **Performance:** Không ảnh hưởng đến hiệu năng ứng dụng
- **Accessibility:** WCAG 2.1 AA compliance

### Lời Kết

Dự án này không chỉ là một bộ component library, mà là một **hệ thống thiết kế hoàn chỉnh** sẽ thay đổi cách chúng ta phát triển sản phẩm. Với style_module integration, layout components, và slot pattern, nó sẽ giúp team phát triển nhanh hơn, sản phẩm đẹp hơn, và thương hiệu nhất quán hơn.

**"Đầu tư vào Component Kit hôm nay là đầu tư vào tương lai của toàn bộ hệ sinh thái sản phẩm."**
