import 'package:flutter/material.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _accessToken = prefs.getString('ff_accessToken') ?? _accessToken;
    });
    _safeInit(() {
      _refreshToken = prefs.getString('ff_refreshToken') ?? _refreshToken;
    });
    _safeInit(() {
      _userId = prefs.getString('ff_userId') ?? _userId;
    });
    _safeInit(() {
      _sessionId = prefs.getString('ff_sessionId') ?? _sessionId;
    });
    _safeInit(() {
      _deviceId = prefs.getString('ff_deviceId') ?? _deviceId;
    });
    _safeInit(() {
      _deviceFingerprint =
          prefs.getString('ff_deviceFingerprint') ?? _deviceFingerprint;
    });
    _safeInit(() {
      _languageCode = prefs.getString('ff_languageCode') ?? _languageCode;
    });
    _safeInit(() {
      _pendingMobile = prefs.getString('ff_pendingMobile') ?? _pendingMobile;
    });
    _safeInit(() {
      _hasLoggedInBefore =
          prefs.getBool('ff_hasLoggedInBefore') ?? _hasLoggedInBefore;
    });
    _safeInit(() {
      _userPasscode = prefs.getString('ff_userPasscode') ?? _userPasscode;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _accessToken = '';
  String get accessToken => _accessToken;
  set accessToken(String value) {
    _accessToken = value;
    prefs.setString('ff_accessToken', value);
  }

  String _refreshToken = '';
  String get refreshToken => _refreshToken;
  set refreshToken(String value) {
    _refreshToken = value;
    prefs.setString('ff_refreshToken', value);
  }

  String _userId = '';
  String get userId => _userId;
  set userId(String value) {
    _userId = value;
    prefs.setString('ff_userId', value);
  }

  String _sessionId = '';
  String get sessionId => _sessionId;
  set sessionId(String value) {
    _sessionId = value;
    prefs.setString('ff_sessionId', value);
  }

  String _deviceId = '';
  String get deviceId => _deviceId;
  set deviceId(String value) {
    _deviceId = value;
    prefs.setString('ff_deviceId', value);
  }

  String _deviceFingerprint = '';
  String get deviceFingerprint => _deviceFingerprint;
  set deviceFingerprint(String value) {
    _deviceFingerprint = value;
    prefs.setString('ff_deviceFingerprint', value);
  }

  String _languageCode = 'en';
  String get languageCode => _languageCode;
  set languageCode(String value) {
    _languageCode = value;
    prefs.setString('ff_languageCode', value);
  }

  String _pendingMobile = '';
  String get pendingMobile => _pendingMobile;
  set pendingMobile(String value) {
    _pendingMobile = value;
    prefs.setString('ff_pendingMobile', value);
  }

  String _mfaToken = '';
  String get mfaToken => _mfaToken;
  set mfaToken(String value) {
    _mfaToken = value;
  }

  /// True once the user has reached the home screen at least once.
  ///
  /// Switches the app from the first-time welcome to the returning-user login
  /// screen.
  bool _hasLoggedInBefore = false;
  bool get hasLoggedInBefore => _hasLoggedInBefore;
  set hasLoggedInBefore(bool value) {
    _hasLoggedInBefore = value;
    prefs.setBool('ff_hasLoggedInBefore', value);
  }

  String _devOtpCode = '';
  String get devOtpCode => _devOtpCode;
  set devOtpCode(String value) {
    _devOtpCode = value;
  }

  String _username = '';
  String get username => _username;
  set username(String value) {
    _username = value;
  }

  bool _hasPassword = false;
  bool get hasPassword => _hasPassword;
  set hasPassword(bool value) {
    _hasPassword = value;
  }

  bool _hasPasscode = false;
  bool get hasPasscode => _hasPasscode;
  set hasPasscode(bool value) {
    _hasPasscode = value;
  }

  bool _mobileVerified = false;
  bool get mobileVerified => _mobileVerified;
  set mobileVerified(bool value) {
    _mobileVerified = value;
  }

  bool _mfaEnabled = false;
  bool get mfaEnabled => _mfaEnabled;
  set mfaEnabled(bool value) {
    _mfaEnabled = value;
  }

  bool _mustChangePassword = false;
  bool get mustChangePassword => _mustChangePassword;
  set mustChangePassword(bool value) {
    _mustChangePassword = value;
  }

  String _accountStatus = '';
  String get accountStatus => _accountStatus;
  set accountStatus(String value) {
    _accountStatus = value;
  }

  String _authStatus = '';
  String get authStatus => _authStatus;
  set authStatus(String value) {
    _authStatus = value;
  }

  /// The passcode the user set during onboarding.
  ///
  /// Checked on the passcode login screen.
  String _userPasscode = '';
  String get userPasscode => _userPasscode;
  set userPasscode(String value) {
    _userPasscode = value;
    prefs.setString('ff_userPasscode', value);
  }

  /// What the business sells, as backend category keys — never labels, because
  /// PATCH /organizations validates against its own catalogue.
  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;
  set selectedCategories(List<String> value) {
    _selectedCategories = value;
  }

  void addToSelectedCategories(String value) {
    selectedCategories.add(value);
  }

  void removeFromSelectedCategories(String value) {
    selectedCategories.remove(value);
  }

  void removeAtIndexFromSelectedCategories(int index) {
    selectedCategories.removeAt(index);
  }

  void updateSelectedCategoriesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedCategories[index] = updateFn(_selectedCategories[index]);
  }

  void insertAtIndexInSelectedCategories(int index, String value) {
    selectedCategories.insert(index, value);
  }

  /// Where the business sells — one sales-channel key, or empty.
  String _selectedSalesChannel = '';
  String get selectedSalesChannel => _selectedSalesChannel;
  set selectedSalesChannel(String value) {
    _selectedSalesChannel = value;
  }

  /// One of the Blink SDK's own names: passport, nationalId, idCard or
  /// drivingLicence.
  String _kycDocumentType = 'nationalId';
  String get kycDocumentType => _kycDocumentType;
  set kycDocumentType(String value) {
    _kycDocumentType = value;
  }

  /// Where the business sells, as backend sales-channel keys.
  ///
  /// The count the setup screen shows on Continue is read from here.
  List<String> _selectedSalesChannels = [];
  List<String> get selectedSalesChannels => _selectedSalesChannels;
  set selectedSalesChannels(List<String> value) {
    _selectedSalesChannels = value;
  }

  void addToSelectedSalesChannels(String value) {
    selectedSalesChannels.add(value);
  }

  void removeFromSelectedSalesChannels(String value) {
    selectedSalesChannels.remove(value);
  }

  void removeAtIndexFromSelectedSalesChannels(int index) {
    selectedSalesChannels.removeAt(index);
  }

  void updateSelectedSalesChannelsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedSalesChannels[index] = updateFn(_selectedSalesChannels[index]);
  }

  void insertAtIndexInSelectedSalesChannels(int index, String value) {
    selectedSalesChannels.insert(index, value);
  }

  /// The sentence to show after an identity check, or empty when there is
  /// nothing to say.
  ///
  /// Written by haatRunKyc.
  String _kycMessage = '';
  String get kycMessage => _kycMessage;
  set kycMessage(String value) {
    _kycMessage = value;
  }

  /// The signed-in merchant's name, or their handle, or their masked number —
  /// whichever they have.
  ///
  /// Never empty for a signed-in account.
  String _displayName = '';
  String get displayName => _displayName;
  set displayName(String value) {
    _displayName = value;
  }

  /// The last four digits of the signed-in number, as the backend masks it.
  ///
  /// The whole number never reaches the handset.
  String _mobileMasked = '';
  String get mobileMasked => _mobileMasked;
  set mobileMasked(String value) {
    _mobileMasked = value;
  }

  /// Address of the business's logo, or empty when it has none.
  ///
  /// Written by haatPickBusinessLogo and haatLoadProfile.
  String _businessLogoUrl = '';
  String get businessLogoUrl => _businessLogoUrl;
  set businessLogoUrl(String value) {
    _businessLogoUrl = value;
  }

  /// The business's account number, as a value — the line it is written in is
  /// made from it by the bbanLine function.
  String _bban = 'SA 8891 8891 8812 1990';
  String get bban => _bban;
  set bban(String value) {
    _bban = value;
  }

  /// True once the statement has come back with at least one line.
  ///
  /// Written by the MerchantTransactions widget, read by the empty screen
  /// beside it.
  bool _hasTransactions = false;
  bool get hasTransactions => _hasTransactions;
  set hasTransactions(bool value) {
    _hasTransactions = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
