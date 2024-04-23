import 'package:test_drive/service/session.dart';

final service = SessionService();

class SessionService {
  final _sessions = <Session>[];
  late Session _currentSession;

  List<Session> getSessions() {
    return _sessions;
  }

  String getSessionDate(int sessionIdx) {
    return _sessions[sessionIdx].date;
  }

  newSession() {
    var date = DateTime.now();
    _sessions.add(Session("${date.day} ${date.month} ${date.hour}:${date.minute}"));
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
}