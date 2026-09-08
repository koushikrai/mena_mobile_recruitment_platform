import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double touchMin = 48.0;
  static const double gutterMobile = 16.0;
  static const double marginScreen = 20.0;
  static const double cardPadding = 16.0;
  static const double stackXs = 4.0;
  static const double stackSm = 8.0;
  static const double stackMd = 12.0;
  static const double stackLg = 16.0;
  static const double stackXl = 24.0;
  static const double bottomBarHeight = 72.0;
}

class AppRadius {
  AppRadius._();

  static const double none = 0.0;
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0; // buttons/inputs
  static const double xl = 16.0; // cards
  static const double full = 9999.0; // chips

  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderFull = BorderRadius.all(Radius.circular(full));
}

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> level0 = [];
  
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x0C000000), // ~5% opacity black
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000), // ~4% opacity black
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 15,
      offset: Offset(0, 10),
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];
}
