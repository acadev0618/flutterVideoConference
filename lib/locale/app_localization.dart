import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/messages_all.dart';

class S {
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  }

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }
  
  
  // list of Change Password Screen
  String get successfullyUpdatedPassword {
    return Intl.message(
      'Successfully updated password',
      name: 'successfullyUpdatedPassword',
      desc: '',
    );
  }

  String get pleaseFillOldPasswordField {
    return Intl.message(
      'Please fill old password field!',
      name: 'pleaseFillOldPasswordField',
      desc: '',
    );
  }

  String get pleaseFillNewPasswordField {
    return Intl.message(
      'Please fill new password field!',
      name: 'pleaseFillNewPasswordField',
      desc: '',
    );
  }

  String get passwordMustBe6CharactersAtLeast {
    return Intl.message(
      'Password must be 6 characters at least!',
      name: 'passwordMustBe6CharactersAtLeast',
      desc: '',
    );
  }

  String get pleaseFillConfirmPasswordField {
    return Intl.message(
      'Please fill confirm password field!',
      name: 'pleaseFillConfirmPasswordField',
      desc: '',
    );
  }

  String get nomatchPasswordandconfirmPassword {
    return Intl.message(
      'No match password and confirm password!',
      name: 'nomatchPasswordandconfirmPassword',
      desc: '',
    );
  }

  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
    );
  }

  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
    );
  }

  String get enterYourOldPassword {
    return Intl.message(
      'Enter your old password',
      name: 'enterYourOldPassword',
      desc: '',
    );
  }

  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
    );
  }

  String get enterYourNewPassword {
    return Intl.message(
      'Enter your new password',
      name: 'enterYourNewPassword',
      desc: '',
    );
  }

  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
    );
  }

  String get enterConfirmNewPassword {
    return Intl.message(
      'Enter confirm new password',
      name: 'enterConfirmNewPassword',
      desc: '',
    );
  }

  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
    );
  }

  // list of Channel Setting Screen
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong!',
      name: 'somethingWentWrong',
      desc: '',
    );
  }

  String get successfullyCreatedYourChannel {
    return Intl.message(
      'Successfully created your channel',
      name: 'successfullyCreatedYourChannel',
      desc: '',
    );
  }

  String get successfullyUpdatedYourChannel {
    return Intl.message(
      'Successfully updated your channel',
      name: 'successfullyUpdatedYourChannel',
      desc: '',
    );
  }

  String get pleaseFillChannelNameField {
    return Intl.message(
      'Please fill channel name field!',
      name: 'pleaseFillChannelNameField',
      desc: '',
    );
  }

  String get channelNameMustBeOnlyOneWord {
    return Intl.message(
      'Channel name must be only one word!',
      name: 'channelNameMustBeOnlyOneWord',
      desc: '',
    );
  }

  String get pleaseFillPasswordField {
    return Intl.message(
      'Please fill password field!',
      name: 'pleaseFillPasswordField',
      desc: '',
    );
  }

  String get passwordMustBe3Characters {
    return Intl.message(
      'Password must be 3 characters ( 2 numbers and 1 letter )!',
      name: 'passwordMustBe3Characters',
      desc: '',
    );
  }

  String get pleaseSelectDomain {
    return Intl.message(
      'Please select domain!',
      name: 'pleaseSelectDomain',
      desc: '',
    );
  }

  String get channelSettings {
    return Intl.message(
      'Channel Settings',
      name: 'channelSettings',
      desc: '',
    );
  }

  String get channelName {
    return Intl.message(
      'Channel Name',
      name: 'channelName',
      desc: '',
    );
  }

  String get enterChannelName {
    return Intl.message(
      'Enter channel name',
      name: 'enterChannelName',
      desc: '',
    );
  }

  String get channelPassword {
    return Intl.message(
      'Channel Password',
      name: 'channelPassword',
      desc: '',
    );
  }

  String get enterChannelPassword {
    return Intl.message(
      'Enter channel password',
      name: 'enterChannelPassword',
      desc: '',
    );
  }

  String get character {
    return Intl.message(
      '3 character ( 2 number and 1 letter )',
      name: 'character',
      desc: '',
    );
  }

  String get domain {
    return Intl.message(
      'Domain',
      name: 'domain',
      desc: '',
    );
  }

  // list of Drawer Side bar
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
    );
  }

  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
    );
  }

  String get profileSettings {
    return Intl.message(
      'Profile settings',
      name: 'profileSettings',
      desc: '',
    );
  }

  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
    );
  }

  String get privacyRules {
    return Intl.message(
      'Privacy Rules',
      name: 'privacyRules',
      desc: '',
    );
  }

  String get terms {
    return Intl.message(
      'Terms',
      name: 'terms',
      desc: '',
    );
  }

  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
    );
  }

  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
    );
  }

  // list of feedback screen
  String get successfullySubmittedYourFeedback {
    return Intl.message(
      'Successfully submitted your feedback',
      name: 'successfullySubmittedYourFeedback',
      desc: '',
    );
  }

  String get pleaseFillSubjectField {
    return Intl.message(
      'Please fill subject field!',
      name: 'pleaseFillSubjectField',
      desc: '',
    );
  }

  String get pleaseFillMessageField {
    return Intl.message(
      'Please fill message field!',
      name: 'pleaseFillMessageField',
      desc: '',
    );
  }

  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
    );
  }

  String get enterFeedbackSubject {
    return Intl.message(
      'Enter feedback subject',
      name: 'enterFeedbackSubject',
      desc: '',
    );
  }

  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
    );
  }

  
  // list of forgot password screen
  String get pleaseFillEmailField {
    return Intl.message(
      'Please fill email field!',
      name: 'pleaseFillEmailField',
      desc: '',
    );
  }

  String get enterValidEmailAddress {
    return Intl.message(
      'Enter valid email address!',
      name: 'enterValidEmailAddress',
      desc: '',
    );
  }

  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
    );
  }

  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
    );
  }

  String get enterYourEmailAddress {
    return Intl.message(
      'Enter your email address',
      name: 'enterYourEmailAddress',
      desc: '',
    );
  }

  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
    );
  }

  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
    );
  }

  
  // list of Home Screen
  String get bTalkerGuide {
    return Intl.message(
      'bTalker - Guide',
      name: 'bTalkerGuide',
      desc: '',
    );
  }

  String get youHaveToCreateFirstYourChannel {
    return Intl.message(
      'You have to create first your channel',
      name: 'youHaveToCreateFirstYourChannel',
      desc: '',
    );
  }

  String get oK {
    return Intl.message(
      'OK',
      name: 'oK',
      desc: '',
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
    );
  }

  String get areYouSureToClosebTalkerApp {
    return Intl.message(
      'Are you sure to close bTalker app?',
      name: 'areYouSureToClosebTalkerApp',
      desc: '',
    );
  }

  String get audioBroadcast {
    return Intl.message(
      'Audio Broadcast',
      name: 'audioBroadcast',
      desc: '',
    );
  }

  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
    );
  }

  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
    );
  }

  String get copiedToClipboard {
    return Intl.message(
      'Copied to Clipboard',
      name: 'copiedToClipboard',
      desc: '',
    );
  }

  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
    );
  }

  String get listenerURL {
    return Intl.message(
      'Listener URL',
      name: 'listenerURL',
      desc: '',
    );
  }

  // list of Login Screen 
  String get pleaseFillUsernameField {
    return Intl.message(
      'Please fill username field!',
      name: 'pleaseFillUsernameField',
      desc: '',
    );
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
    );
  }

  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
    );
  }

  String get enterYourUsername {
    return Intl.message(
      'Enter your Username',
      name: 'enterYourUsername',
      desc: '',
    );
  }

  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
    );
  }

  String get dontyouHaveAnAccountAlready {
    return Intl.message(
      'Don\'t you have an account already?',
      name: 'dontyouHaveAnAccountAlready',
      desc: '',
    );
  }

  String get signupHere {
    return Intl.message(
      'Signup here.',
      name: 'signupHere',
      desc: '',
    );
  }

  // list of mydetial screen
  String get profilePhoto {
    return Intl.message(
      'Profile Photo',
      name: 'profilePhoto',
      desc: '',
    );
  }

  String get successfullyUpdatedProfile {
    return Intl.message(
      'Successfully updated profile',
      name: 'successfullyUpdatedProfile',
      desc: '',
    );
  }

  String get pleaseFillFullNameField {
    return Intl.message(
      'Please fill full name field!',
      name: 'pleaseFillFullNameField',
      desc: '',
    );
  }

  String get pleaseFillPhoneNumberField {
    return Intl.message(
      'Please fill phone number field!',
      name: 'pleaseFillPhoneNumberField',
      desc: '',
    );
  }

  String get pleaseFillCountryField {
    return Intl.message(
      'Please fill country field!',
      name: 'pleaseFillCountryField',
      desc: '',
    );
  }

  String get pleaseFillCityField {
    return Intl.message(
      'Please fill city field!',
      name: 'pleaseFillCityField',
      desc: '',
    );
  }

  String get myDetails {
    return Intl.message(
      'My Details',
      name: 'myDetails',
      desc: '',
    );
  }

  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
    );
  }

  String get enterYourFullName {
    return Intl.message(
      'Enter your full name',
      name: 'enterYourFullName',
      desc: '',
    );
  }

  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
    );
  }

  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneNumber',
      desc: '',
    );
  }

  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
    );
  }

  String get enterYourCountry {
    return Intl.message(
      'Enter your country',
      name: 'enterYourCountry',
      desc: '',
    );
  }

  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
    );
  }

  String get enterYourCity {
    return Intl.message(
      'Enter your city',
      name: 'enterYourCity',
      desc: '',
    );
  }

  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
    );
  }

  // list of profile screen
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
    );
  }

  String get security {
    return Intl.message(
      'Security',
      name: 'security',
      desc: '',
    );
  }

  // list of register screen
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
    );
  }

  String get pickFromGallery {
    return Intl.message(
      'Pick from Gallery',
      name: 'pickFromGallery',
      desc: '',
    );
  }

  String get pickFromCamera {
    return Intl.message(
      'Pick from Camera',
      name: 'pickFromCamera',
      desc: '',
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S>{
  final Locale overriddenLocale;

  const AppLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => ['en', 'tk'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) => S.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<S> old) => false; 
}