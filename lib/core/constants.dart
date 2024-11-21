import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyle {
  static final _nunito = GoogleFonts.nunito();
  static final manrope = GoogleFonts.manrope();
  static final roboto = GoogleFonts.roboto();

  static final _plusJukartaSans = GoogleFonts.plusJakartaSans(
    fontWeight: AppFontWeight.regular,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
  );
  static final TextStyle headline1 = _nunito.copyWith(
    fontSize: 24,
    fontWeight: AppFontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle headline2 = _nunito.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle subheader1 = _nunito.copyWith(
    fontSize: 15,
    fontWeight: AppFontWeight.medium,
    color: Colors.black,
  );

  static final TextStyle alert = _nunito.copyWith(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.w900,
  );

  static final TextStyle body = _nunito.copyWith(
    fontSize: 25,
    fontWeight: FontWeight.w900,
    color: AppColors.eerieBlack,
  );

  static final TextStyle button = _nunito.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.semiBold,
    color: Colors.black,
  );

  static final TextStyle buttonLarge = _plusJukartaSans.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.semiBold,
    color: Colors.black,
  );
  static final TextStyle logo = _nunito.copyWith(
    fontSize: 36,
    fontWeight: AppFontWeight.extraBold,
    color: Colors.black,
    letterSpacing: 0.02,
  );

  static final TextStyle header = roboto.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.bold,
    color: Colors.black,
  );
}

/// Namespace for Default App Font Weights
abstract class AppFontWeight {
  /// FontWeight value of `w900`
  static const FontWeight black = FontWeight.w900;

  /// FontWeight value of `w800`
  static const FontWeight extraBold = FontWeight.w800;

  /// FontWeight value of `w700`
  static const FontWeight bold = FontWeight.w700;

  /// FontWeight value of `w600`
  static const FontWeight semiBold = FontWeight.w600;

  /// FontWeight value of `w500`
  static const FontWeight medium = FontWeight.w500;

  /// FontWeight value of `w400`
  static const FontWeight regular = FontWeight.w400;

  /// FontWeight value of `w300`
  static const FontWeight light = FontWeight.w300;

  /// FontWeight value of `w200`
  static const FontWeight extraLight = FontWeight.w200;

  /// FontWeight value of `w100`
  static const FontWeight thin = FontWeight.w100;
}

class AppColors {
  static const buttonInterior = Color.fromRGBO(102, 187, 106, 1);
  static const transparent = Colors.transparent;
  static const Color eerieBlack = Color(0xFF1A1F16);
  static const Color pakistanGreen = Color(0xFF1E3F20);
  static const Color hunterGreen = Color(0xFF345830);
  static const Color fernGreen = Color(0xFF4A7856);
  static const Color aquamarine = Color(0xFF94ECBE);
  static const Color enabledFieldOrange = Color(0xFFD29E52);
  static const Color enabledInsideFieldBlue = Color(0xFF72C1B0);
  static const Color containerBackground = Color(0xFFC1E899);
  static const Color textColorBrown = Color(0xFF9A6735);
  static const Color costalBlue = Color(0xFF077A81);
}

abstract class AppPadding {
  /// The default unit of spacing
  static const double unit = 16; 

  /// the standard padding for a page, specifically an onboarding page
  /// (at least for now)
  static const page =
      EdgeInsets.symmetric(horizontal: unit * 1.2, vertical: unit * 2);
  static const horizontalPage = EdgeInsets.symmetric(horizontal: 1.5 * unit);

  static const profile =
      EdgeInsets.symmetric(horizontal: unit, vertical: unit * 0.75);

  static const dialog =
      EdgeInsets.symmetric(horizontal: unit, vertical: unit * 0.75);

  static const smallButton = EdgeInsets.symmetric(horizontal: unit * 3);
  static const insider = EdgeInsets.symmetric(horizontal: unit * 1.5);
  static const profileSpace =
      EdgeInsets.symmetric(horizontal: unit * 1.5, vertical: unit * .7);
}

abstract class AppSpacing {
  /// The default unit of spacing
  static const double spaceUnit = 16;

  /// xxxs spacing value (1pt)
  static const double xxxs = 0.0625 * spaceUnit;

  /// xxs spacing value (2pt)
  static const double xxs = 0.125 * spaceUnit;

  /// xs spacing value (4pt)
  static const double xs = 0.25 * spaceUnit;

  /// sm spacing value (8pt)
  static const double sm = 0.5 * spaceUnit;

  /// md spacing value (12pt)
  static const double md = 0.75 * spaceUnit;

  /// lg spacing value (16pt)
  static const double lg = spaceUnit;

  /// xlg spacing value (24pt)
  static const double xlg = 1.5 * spaceUnit;

  /// xxlg spacing value (40pt)
  static const double xxlg = 2.5 * spaceUnit;

  /// xxxlg pacing value (64pt)
  static const double xxxlg = 4 * spaceUnit;
}