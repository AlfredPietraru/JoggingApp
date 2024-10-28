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
  );

  static final TextStyle headline2 = _nunito.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.bold,
  );

  static final TextStyle subheader1 = _nunito.copyWith(
    fontSize: 15,
    fontWeight: AppFontWeight.medium,
  );

  static final TextStyle alert = _nunito.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.regular,
    color: Colors.red,
  );

  static final TextStyle body = _nunito.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.regular,
  );

  static final TextStyle button = _nunito.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.semiBold,
  );

  static final TextStyle buttonLarge = _plusJukartaSans.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.semiBold,
  );
  static final TextStyle logo = _nunito.copyWith(
    fontSize: 36,
    fontWeight: AppFontWeight.extraBold,
    letterSpacing: 0.02,
  );

  static final TextStyle header = roboto.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.bold,
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
  static const lightBlue = Color(0xFFEDF2FB);
  static const second = Color(0xFFE2EAFC);
  static const third = Color(0xFFD7E3FC);
  static const fourth = Color(0xFFCCDBFD);
  static const fifth = Color(0xFFC1D3FE);
  static const sixth = Color(0xFFB6CCFE);
  static const seventh = Color(0xFFABC4FF);
  static const buttonBlue = Color(0xFF82A7FF);
  static const white = Color(0xffffffff);
  static const textFieldBlue = Color(0xFFACC3FF);
  static const fullBlueButton = Color(0xFF749DFF);
  static const unselectedGrey = Color(0xFFB0B0B0);
  static const primary = Color(0xFF82A8FF);
  static const error = Color(0xFFB3261E);
  static const azureGame = Color(0xFF3CF3FF);
  static const visualGamePurple = Color(0xFF9289FF);
  static const black0 = Color(0xFF000000);

  static const buttonDefault = primary;
  static final buttonDisabled = primary.withOpacity(0.3);
  static const buttonPressed = fullBlueButton;

  static const transparent = Colors.transparent;
}

abstract class AppPadding {
  /// The default unit of spacing
  static const double unit = 16;

  /// the standard padding for a page, specifically an onboarding page
  /// (at least for now)
  static const page =
      EdgeInsets.symmetric(horizontal: unit * 1.5, vertical: unit * 2);
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
