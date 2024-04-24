import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_drive/service/session.dart';

late SessionService service;

class SessionService {
  var _sessions = <Session>[];
  late Session _currentSession;

  SessionService();
  SessionService.fromSessions(this._sessions, this._currentSession);

  List<Session> getSessions() {
    return _sessions;
  }

  String getSessionName(int sessionIdx) {
    return _sessions[sessionIdx].name;
  }

  newSession() {
    var date = DateTime.now();
    _sessions.add(Session("${date.day < 10 ? "0" : ""}${date.day}.${date.month < 10 ? "0" : ""}${date.month} ${date.hour}:${date.minute}"));
  }

  changeNameSession(String newName, int index) {
    _sessions[index].name = newName;
  }

  removeSession(int sessionIdx) {
    _sessions.removeAt(sessionIdx);
  }

  setCurrent(int sessionIdx) {
    _currentSession = _sessions[sessionIdx];
  }

  addPairs(List<List<String>> pairs) {
    _currentSession.addPairs(pairs);
  }

  List<List<int>> search(int code) {
    return _currentSession.search(code);
  }

  removeLine(int pageIdx, int lineIdx) {
    _currentSession.removeLine(pageIdx, lineIdx);
  }

  reverseCurrent() {
    _currentSession.reverse();
  }

  Map<String, dynamic> toJson() {
    return {
      'sessions': _sessions.map((session) => session.toJson()).toList(),
      'currentSession': _currentSession.toJson(),
    };
  }

  factory SessionService.fromJson(Map<String, dynamic> json) {
    return SessionService.fromSessions((json['sessions'] as List).map((session) => Session.fromJson(session)).toList(), Session.fromJson(json['currentSession']));
  }

  Future<void> saveToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionServiceJson = json.encode(this);
    prefs.setString('service', sessionServiceJson);
  }

  static Future<SessionService> loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionServiceJson = prefs.getString('service');
    if (sessionServiceJson != null) {
      return SessionService.fromJson(json.decode(sessionServiceJson));
    }
    return SessionService();
  }
}