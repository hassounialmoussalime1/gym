import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @shapeYourBody.
  ///
  /// In en, this message translates to:
  /// **'SHAPE YOUR BODY'**
  String get shapeYourBody;

  /// No description provided for @beStrong.
  ///
  /// In en, this message translates to:
  /// **'BE STRONG'**
  String get be;
  String get strong;
  String get info;

  /// No description provided for @trainingHard.
  ///
  /// In en, this message translates to:
  /// **'TRAINING HARD'**
  String get trainingHard;
  String get arabic;
  String get english;
  String get selectLang;
  String get home;
  String get product;
  String get about;
  String get contact;
  String get changeLang;
  String get whyChooseUs;
  String get PUSHYOURLIMITSFORWARD;
  String get categories;
  String get bigsale;
  String get newArivvw;
  String get feature;
  String get seeMor;
  String get addToCart;
  String get outOfStock;
  String get chekout;
  String get WhoWeAre;
  String get WhoWeAreDes;
  String get OurMission;
  String get OurMissionDes;
  String get WhatWeOffer;
  String get WhatWeOfferDes;
  String get WhyChooseUs;
  String get WhyChooseUsDes;
  String get phone;
  String get email;
  String get location;
  String get workingHour;
  String get sendMessage;
  String get fullNamw;
  String get emailAddress;
  String get Message;
  String get sendMessag;
  String get orders;
  String get newOrders;
  String get users;
  String get orderId;
  String get date;
  String get clientName;
  String get adress;
  String get totale;
  String get sendToWatsap;
  String get priceDetail;
  String get ShippingDetail;
  String get OrderInfo;
  String get OrderStatus;
  String get updateProduct;
  String get title;
  String get price;
  String get qantitie;
  String get discount;
  String get descreption;
  String get featureProduct;
  String get addProduct;
  String get pickImage;
  String get name;
  String get NewCategorie;
  String get CategorieInfo;
  String get updateCategorie;
  String get password;
  String get checkOut;
  String get orderSummary;
  String get subTotal;
  String get shipping;
  String get confirmPayement;
  String get thanks;
  String get message;
  String get gobakce;
  String get cart;
  String get emptycart;
  String get productDetail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
