// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Danger zone:`
  String get dangerZone {
    return Intl.message('Danger zone:', name: 'dangerZone', desc: '', args: []);
  }

  /// `Sometimes, you should change me:`
  String get changeMe {
    return Intl.message(
      'Sometimes, you should change me:',
      name: 'changeMe',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Want to switch account?`
  String get switchAccount {
    return Intl.message(
      'Want to switch account?',
      name: 'switchAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message('Log out', name: 'logOut', desc: '', args: []);
  }

  /// `Register:`
  String get register {
    return Intl.message('Register:', name: 'register', desc: '', args: []);
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalidEmailFormat {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid password, should be more complex`
  String get invalidPassword {
    return Intl.message(
      'Invalid password, should be more complex',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Register me`
  String get registerMe {
    return Intl.message('Register me', name: 'registerMe', desc: '', args: []);
  }

  /// `About our mission`
  String get aboutMission {
    return Intl.message(
      'About our mission',
      name: 'aboutMission',
      desc: '',
      args: [],
    );
  }

  /// `We blend together technology and sport, and with YOUR help, we can find the balance between them. Let's encourage a healthy lifestyle!`
  String get aboutMissionText {
    return Intl.message(
      'We blend together technology and sport, and with YOUR help, we can find the balance between them. Let\'s encourage a healthy lifestyle!',
      name: 'aboutMissionText',
      desc: '',
      args: [],
    );
  }

  /// `Jogging Time`
  String get joggingTime {
    return Intl.message(
      'Jogging Time',
      name: 'joggingTime',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message('Connect', name: 'connect', desc: '', args: []);
  }

  /// `Make Friends`
  String get makeFriends {
    return Intl.message(
      'Make Friends',
      name: 'makeFriends',
      desc: '',
      args: [],
    );
  }

  /// `Stay Healthy`
  String get stayHealthy {
    return Intl.message(
      'Stay Healthy',
      name: 'stayHealthy',
      desc: '',
      args: [],
    );
  }

  /// `Hello but without the kitty!`
  String get helloWithoutKitty {
    return Intl.message(
      'Hello but without the kitty!',
      name: 'helloWithoutKitty',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Current user information:`
  String get currentUserInfo {
    return Intl.message(
      'Current user information:',
      name: 'currentUserInfo',
      desc: '',
      args: [],
    );
  }

  /// `First Name:`
  String get firstName {
    return Intl.message('First Name:', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name:`
  String get lastName {
    return Intl.message('Last Name:', name: 'lastName', desc: '', args: []);
  }

  /// `Sex:`
  String get sex {
    return Intl.message('Sex:', name: 'sex', desc: '', args: []);
  }

  /// `Age:`
  String get age {
    return Intl.message('Age:', name: 'age', desc: '', args: []);
  }

  /// `Save changes`
  String get saveChanges {
    return Intl.message(
      'Save changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Starting Point`
  String get startingPoint {
    return Intl.message(
      'Starting Point',
      name: 'startingPoint',
      desc: '',
      args: [],
    );
  }

  /// `End point`
  String get endPoint {
    return Intl.message('End point', name: 'endPoint', desc: '', args: []);
  }

  /// `Sending current run to database`
  String get sendingRunToDatabase {
    return Intl.message(
      'Sending current run to database',
      name: 'sendingRunToDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to proceed?`
  String get confirmProceed {
    return Intl.message(
      'Are you sure you want to proceed?',
      name: 'confirmProceed',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `We are glad to see you back!`
  String get welcomeBack {
    return Intl.message(
      'We are glad to see you back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Wrong email or password`
  String get wrongEmailPassword {
    return Intl.message(
      'Wrong email or password',
      name: 'wrongEmailPassword',
      desc: '',
      args: [],
    );
  }

  /// `The email does not have the right format.`
  String get invalidEmailFormatText {
    return Intl.message(
      'The email does not have the right format.',
      name: 'invalidEmailFormatText',
      desc: '',
      args: [],
    );
  }

  /// `Password does not have the right format`
  String get invalidPasswordFormat {
    return Intl.message(
      'Password does not have the right format',
      name: 'invalidPasswordFormat',
      desc: '',
      args: [],
    );
  }

  /// `Login into account`
  String get loginIntoAccount {
    return Intl.message(
      'Login into account',
      name: 'loginIntoAccount',
      desc: '',
      args: [],
    );
  }

  /// `No Internet connection, try again later`
  String get noInternetConnection {
    return Intl.message(
      'No Internet connection, try again later',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Tell us your first name`
  String get tellFirstName {
    return Intl.message(
      'Tell us your first name',
      name: 'tellFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Invalid firstname`
  String get invalidFirstName {
    return Intl.message(
      'Invalid firstname',
      name: 'invalidFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your last name`
  String get enterLastName {
    return Intl.message(
      'Enter your last name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Invalid lastname`
  String get invalidLastName {
    return Intl.message(
      'Invalid lastname',
      name: 'invalidLastName',
      desc: '',
      args: [],
    );
  }

  /// `Choose your age`
  String get chooseAge {
    return Intl.message(
      'Choose your age',
      name: 'chooseAge',
      desc: '',
      args: [],
    );
  }

  /// `Choose your gender`
  String get chooseGender {
    return Intl.message(
      'Choose your gender',
      name: 'chooseGender',
      desc: '',
      args: [],
    );
  }

  /// `Your Description`
  String get yourDescription {
    return Intl.message(
      'Your Description',
      name: 'yourDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send profile info`
  String get sendProfileInfo {
    return Intl.message(
      'Send profile info',
      name: 'sendProfileInfo',
      desc: '',
      args: [],
    );
  }

  /// `An account with this email already exists`
  String get accountExists {
    return Intl.message(
      'An account with this email already exists',
      name: 'accountExists',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternet {
    return Intl.message(
      'No internet connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Unknown failure occurred`
  String get unknownFailure {
    return Intl.message(
      'Unknown failure occurred',
      name: 'unknownFailure',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to show here yet`
  String get nothingToShow {
    return Intl.message(
      'Nothing to show here yet',
      name: 'nothingToShow',
      desc: '',
      args: [],
    );
  }

  /// `Starting Time:`
  String get startingTime {
    return Intl.message(
      'Starting Time:',
      name: 'startingTime',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Distance traveled`
  String get distanceTraveled {
    return Intl.message(
      'Distance traveled',
      name: 'distanceTraveled',
      desc: '',
      args: [],
    );
  }

  /// `There is no run yet`
  String get noRunYet {
    return Intl.message(
      'There is no run yet',
      name: 'noRunYet',
      desc: '',
      args: [],
    );
  }

  /// `Go for a jog and come here again.`
  String get goForJog {
    return Intl.message(
      'Go for a jog and come here again.',
      name: 'goForJog',
      desc: '',
      args: [],
    );
  }

  /// `End Location`
  String get endLocation {
    return Intl.message(
      'End Location',
      name: 'endLocation',
      desc: '',
      args: [],
    );
  }

  /// `Initial Location`
  String get initialLocation {
    return Intl.message(
      'Initial Location',
      name: 'initialLocation',
      desc: '',
      args: [],
    );
  }

  /// `Friend Requests`
  String get friendRequests {
    return Intl.message(
      'Friend Requests',
      name: 'friendRequests',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `User found`
  String get userFound {
    return Intl.message('User found', name: 'userFound', desc: '', args: []);
  }

  /// `Hello, let's be friends on Jogging Time.`
  String get helloLetsBeFriends {
    return Intl.message(
      'Hello, let\'s be friends on Jogging Time.',
      name: 'helloLetsBeFriends',
      desc: '',
      args: [],
    );
  }

  /// `Collecting Data`
  String get collectingData {
    return Intl.message(
      'Collecting Data',
      name: 'collectingData',
      desc: '',
      args: [],
    );
  }

  /// `Get more users`
  String get getMoreUsers {
    return Intl.message(
      'Get more users',
      name: 'getMoreUsers',
      desc: '',
      args: [],
    );
  }

  /// `No more users to be found.`
  String get noMoreUsers {
    return Intl.message(
      'No more users to be found.',
      name: 'noMoreUsers',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
