import 'package:flutter/material.dart';

class Insets {
  static double gutterScale = 1;

  static double scale = 1;

  /// Dynamic insets, may get scaled with the device size
  static double get mGutter => m * gutterScale;

  static double get lGutter => l * gutterScale;

  static double get xs => 2 * scale;

  static double get sm => 6 * scale;

  static double get m => 12 * scale;

  static double get l => 24 * scale;

  static double get xl => 36 * scale;
}

class FontSizes {
  static double get scale => 1;

  static double get s11 => 11 * scale;

  static double get s12 => 12 * scale;

  static double get s14 => 14 * scale;

  static double get s16 => 16 * scale;

  static double get s18 => 18 * scale;
}

class Sizes {
  static double hitScale = 1;

  static double get hit => 40 * hitScale;

  static double get iconMed => 20;

  static double get sideBarSm => 150 * hitScale;

  static double get sideBarMed => 200 * hitScale;

  static double get sideBarLg => 290 * hitScale;
}

// class TextStyles {
//   static const TextStyle lato = TextStyle(
//     fontWeight: FontWeight.w400,
//     letterSpacing: 0,
//     height: 1,
//     fontFamilyFallback: [
//       "OpenSansEmoji",
//     ],
//   );

//   static const TextStyle quicksand = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontFamilyFallback: [
//        "OpenSansEmoji",
//     ],
//   );

//   static TextStyle get T1 => quicksand.bold.size(FontSizes.s14).letterSpace(.7);

//   static TextStyle get T2 => lato.bold.size(FontSizes.s12).letterSpace(.4);

//   static TextStyle get H1 => lato.bold.size(FontSizes.s14);

//   static TextStyle get H2 => lato.bold.size(FontSizes.s12);

//   static TextStyle get Body1 => lato.size(FontSizes.s14);

//   static TextStyle get Body2 => lato.size(FontSizes.s12);

//   static TextStyle get Body3 => lato.size(FontSizes.s11);

//   static TextStyle get Callout => quicksand.size(FontSizes.s14).letterSpace(1.75);

//   static TextStyle get CalloutFocus => Callout.bold;

//   static TextStyle get Btn => quicksand.bold.size(FontSizes.s14).letterSpace(1.75);

//   static TextStyle get BtnSelected => quicksand.size(FontSizes.s14).letterSpace(1.75);

//   static TextStyle get Footnote => quicksand.bold.size(FontSizes.s11);

//   static TextStyle get Caption => lato.size(FontSizes.s11).letterSpace(.3);
// }

class Shadows {
  static bool enabled = true;

  static double get mRadius => 8;

  static List<BoxShadow> m(Color color, [double opacity = 0]) {
    return enabled
        ? [
            BoxShadow(
              color: color.withOpacity(opacity ?? .03),
              blurRadius: mRadius,
              spreadRadius: mRadius / 2,
              offset: Offset(1, 0),
            ),
            BoxShadow(
              color: color.withOpacity(opacity ?? .04),
              blurRadius: mRadius / 2,
              spreadRadius: mRadius / 4,
              offset: Offset(1, 0),
            )
          ]
        : null;
  }
}

class Corners {
  static double get btn => s5;

  static double get dialog => 12;

  /// Xs
  static double get s3 => 3;

  static BorderRadius get s3Border => BorderRadius.all(s3Radius);

  static Radius get s3Radius => Radius.circular(s3);

  /// Small
  static double get s5 => 5;

  static BorderRadius get s5Border => BorderRadius.all(s5Radius);

  static Radius get s5Radius => Radius.circular(s5);

  /// Medium
  static double get s8 => 8;

  static BorderRadius get s8Border => BorderRadius.all(s8Radius);

  static Radius get s8Radius => Radius.circular(s8);

  /// Large
  static double get s10 => 10;

  static BorderRadius get s10Border => BorderRadius.all(s10Radius);

  static Radius get s10Radius => Radius.circular(s10);
}
