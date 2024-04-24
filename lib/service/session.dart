import 'package:test_drive/service/page.dart';

class Session {
  String name;
  late List<Page> _pages = <Page>[];

  Session(this.name);
  Session.fromPages(this.name, this._pages);

  void addPairs(List<List<String>> pairs, int index) {
    if (index == _pages.length) {
      _pages.add(Page(pairs));
    } else {
      _pages[index] = Page(pairs);
    }
  }

  int getLength() {
    return _pages.length;
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

  void reverse() {
    _pages = _pages.reversed.toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pages': _pages.map((page) => page.toJson()).toList(),
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session.fromPages(json['name'], (json['pages'] as List).map((pageJson) => Page.fromJson(pageJson)).toList());
  }

  String getPageToString(int index) {
    return _pages[index].toString();
  }
}
