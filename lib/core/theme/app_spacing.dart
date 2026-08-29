import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: md);

  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(sm);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(lg);

  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets listItemPaddingLg = EdgeInsets.symmetric(horizontal: md, vertical: md);

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  static const EdgeInsets buttonPaddingSm = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const EdgeInsets buttonPaddingLg = EdgeInsets.symmetric(horizontal: 32, vertical: 16);

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const EdgeInsets inputPaddingSm = EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  static const double borderRadiusXs = 4.0;
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusFull = 9999.0;

  static const double iconSizeXs = 16.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;

  static const double avatarSizeXs = 24.0;
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 40.0;
  static const double avatarSizeLg = 56.0;
  static const double avatarSizeXl = 80.0;

  static const double bottomNavHeight = 80.0;
  static const double appBarHeight = 64.0;
  static const double tabBarHeight = 48.0;
  static const double fabSize = 56.0;

  static const double minTouchTarget = 48.0;
}

class AppShadows {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x050F172A),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x050F172A),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x0D0F172A),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x080F172A),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x100F172A),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}

class AppSizing {
  static const double maxContentWidth = 1400.0;
  static const double maxCardWidth = 400.0;
  static const double minCardWidth = 280.0;

  static const double chartHeightSm = 160.0;
  static const double chartHeightMd = 240.0;
  static const double chartHeightLg = 320.0;

  static const double listItemHeightSm = 56.0;
  static const double listItemHeightMd = 72.0;
  static const double listItemHeightLg = 96.0;

  static const double inputHeight = 52.0;
  static const double inputHeightSm = 44.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightLg = 56.0;
}

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets copyWithSymmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? this.horizontal,
      vertical: vertical ?? this.vertical,
    );
  }
}

extension BorderRadiusExtension on BorderRadius {
  static BorderRadius all(double radius) => BorderRadius.circular(radius);
  static BorderRadius top(double radius) => BorderRadius.vertical(top: Radius.circular(radius));
  static BorderRadius bottom(double radius) => BorderRadius.vertical(bottom: Radius.circular(radius));
  static BorderRadius left(double radius) => BorderRadius.horizontal(left: Radius.circular(radius));
  static BorderRadius right(double radius) => BorderRadius.horizontal(right: Radius.circular(radius));
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );
}