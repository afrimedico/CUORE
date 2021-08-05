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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Username`
  String get user_name {
    return Intl.message(
      'Username',
      name: 'user_name',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Village`
  String get village {
    return Intl.message(
      'Village',
      name: 'village',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Collect`
  String get collect {
    return Intl.message(
      'Collect',
      name: 'collect',
      desc: '',
      args: [],
    );
  }

  /// `Choose an option`
  String get choose_an_option {
    return Intl.message(
      'Choose an option',
      name: 'choose_an_option',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get count {
    return Intl.message(
      'Count',
      name: 'count',
      desc: '',
      args: [],
    );
  }

  /// `ADULT`
  String get adult {
    return Intl.message(
      'ADULT',
      name: 'adult',
      desc: '',
      args: [],
    );
  }

  /// `CHILD`
  String get child {
    return Intl.message(
      'CHILD',
      name: 'child',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Visit date`
  String get visit_date {
    return Intl.message(
      'Visit date',
      name: 'visit_date',
      desc: '',
      args: [],
    );
  }

  /// `Collection`
  String get collection {
    return Intl.message(
      'Collection',
      name: 'collection',
      desc: '',
      args: [],
    );
  }

  /// `Input Collection`
  String get input_collection {
    return Intl.message(
      'Input Collection',
      name: 'input_collection',
      desc: '',
      args: [],
    );
  }

  /// `Accounts payable`
  String get accounts_payable {
    return Intl.message(
      'Accounts payable',
      name: 'accounts_payable',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Ring up`
  String get ring_up {
    return Intl.message(
      'Ring up',
      name: 'ring_up',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `sheet`
  String get sheet {
    return Intl.message(
      'sheet',
      name: 'sheet',
      desc: '',
      args: [],
    );
  }

  /// `resend`
  String get resend {
    return Intl.message(
      'resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message(
      'ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Box`
  String get box {
    return Intl.message(
      'Box',
      name: 'box',
      desc: '',
      args: [],
    );
  }

  /// `Station`
  String get station {
    return Intl.message(
      'Station',
      name: 'station',
      desc: '',
      args: [],
    );
  }

  /// `use`
  String get ringup_use {
    return Intl.message(
      'use',
      name: 'ringup_use',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get customer_count {
    return Intl.message(
      'Count',
      name: 'customer_count',
      desc: '',
      args: [],
    );
  }

  /// `Resend by SMS`
  String get resend_by_sms {
    return Intl.message(
      'Resend by SMS',
      name: 'resend_by_sms',
      desc: '',
      args: [],
    );
  }

  /// `Please send again when your network works.`
  String get resend_again {
    return Intl.message(
      'Please send again when your network works.',
      name: 'resend_again',
      desc: '',
      args: [],
    );
  }

  /// `Some messages cant be sent properly.`
  String get resend_error {
    return Intl.message(
      'Some messages cant be sent properly.',
      name: 'resend_error',
      desc: '',
      args: [],
    );
  }

  /// `Message sent`
  String get message_sent {
    return Intl.message(
      'Message sent',
      name: 'message_sent',
      desc: '',
      args: [],
    );
  }

  /// `Failed Messages`
  String get failed_messages {
    return Intl.message(
      'Failed Messages',
      name: 'failed_messages',
      desc: '',
      args: [],
    );
  }

  /// `Processing...`
  String get processing {
    return Intl.message(
      'Processing...',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `All villages`
  String get all_villages {
    return Intl.message(
      'All villages',
      name: 'all_villages',
      desc: '',
      args: [],
    );
  }

  /// `All stations`
  String get all_stations {
    return Intl.message(
      'All stations',
      name: 'all_stations',
      desc: '',
      args: [],
    );
  }

  /// `Reloading...`
  String get reloading {
    return Intl.message(
      'Reloading...',
      name: 'reloading',
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
