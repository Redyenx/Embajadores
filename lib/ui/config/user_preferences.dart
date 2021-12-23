import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get password {
    return _prefs!.getString('password') ?? '0';
  }

  set password(String value) {
    _prefs!.setString('password', value);
  }

  bool? get showPassword {
    return _prefs!.getBool('showPassword') ?? false;
  }

  set showPassword(bool? value) {
    _prefs!.setBool('showPassword', value!);
  }

  int get ownerCount {
    return _prefs!.getInt('ownerCount') ?? 0;
  }

  set ownerCount(int value) {
    _prefs!.setInt('ownerCount', value);
  }

  bool? get firstIncident {
    return _prefs!.getBool('firstIncident') ?? true;
  }

  set firstIncident(bool? value) {
    _prefs!.setBool('firstIncident', value!);
  }

  bool? get firstViewOrEdit {
    return _prefs!.getBool('firstViewOrEdit') ?? true;
  }

  set firstViewOrEdit(bool? value) {
    _prefs!.setBool('firstViewOrEdit', value!);
  }

  bool? get firstViewStore {
    return _prefs!.getBool('firstViewStore') ?? true;
  }

  set firstViewStore(bool? value) {
    _prefs!.setBool('firstViewStore', value!);
  }

  bool? get firstIncidentFilter {
    return _prefs!.getBool('firstIncidentFilter') ?? true;
  }

  set firstIncidentFilter(bool? value) {
    _prefs!.setBool('firstIncidentFilter', value!);
  }

  bool? get firstStore {
    return _prefs!.getBool('firstStore') ?? true;
  }

  set firstStore(bool? value) {
    _prefs!.setBool('firstStore', value!);
  }

  bool? get firstStoreFilter {
    return _prefs!.getBool('firstStoreFilter') ?? true;
  }

  set firstStoreFilter(bool? value) {
    _prefs!.setBool('firstStoreFilter', value!);
  }

  bool? get firstRun {
    return _prefs!.getBool('firstRun') ?? true;
  }

  set firstRun(bool? value) {
    _prefs!.setBool('firstRun', value!);
  }

  String get userId {
    return _prefs!.getString('userId') ?? '0';
  }

  set userId(String value) {
    _prefs!.setString('userId', value);
  }

  String get userRolId {
    return _prefs!.getString('userRolId') ?? '0';
  }

  set userRolId(String value) {
    _prefs!.setString('userRolId', value);
  }

  String get userDni {
    return _prefs!.getString('userDni') ?? '0';
  }

  set userDni(String value) {
    _prefs!.setString('userDni', value);
  }

  String get userName {
    return _prefs!.getString('userName') ?? '0';
  }

  set userName(String value) {
    _prefs!.setString('userName', value);
  }

  String get lastName {
    return _prefs!.getString('lastName') ?? '0';
  }

  set lastName(String value) {
    _prefs!.setString('lastName', value);
  }

  String get email {
    return _prefs!.getString('email') ?? '0';
  }

  set email(String value) {
    _prefs!.setString('email', value);
  }

  String get phone {
    return _prefs!.getString('phone') ?? '0';
  }

  set phone(String value) {
    _prefs!.setString('phone', value);
  }

  String get token {
    return _prefs!.getString('token') ?? '0';
  }

  set token(String value) {
    _prefs!.setString('token', value);
  }

  String get getAll {
    return _prefs!.getString('getAll') ?? '0';
  }

  set getAll(String value) {
    _prefs!.setString('getAll', value);
  }

  removeValues() async {
    _prefs!.remove('userId');
    _prefs!.remove('userRolId');
    _prefs!.remove('userName');
    _prefs!.remove('lastName');
    _prefs!.remove('email');
    _prefs!.remove('phone');
    _prefs!.remove('userDni');
    _prefs!.remove('token');
  }

  bool checkUserId() {
    return _prefs!.containsKey('userId');
  }
}
