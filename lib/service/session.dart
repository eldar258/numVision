import 'package:test_drive/service/page.dart';

class Session {
  final String date;
  final _pages = <Page>[];

  Session(this.date);

  void addPairs(List<List<String>> pairs) {
    _pages.add(Page(pairs));
  }

  List<List<int>> search(int code) {
    List<List<int>> res = [];
    for (int i = 0; i < _pages.length; i++) {
      List<List<int>> lines = _pages[i].search(code);
      for (int j = 0; j < lines.length; j++) {
        res.add([lines[j][0], i, lines[j][1]]);
      }
    }
    return res;
  }

  void removeLine(int pageIdx, int lineIdx) {
    _pages[pageIdx].remove(lineIdx);
    if (_pages[pageIdx].isEmpty()) {
      _pages.removeAt(pageIdx);
    }
  }
}
