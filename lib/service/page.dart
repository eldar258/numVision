class Page {
  var _lines = <Line>[];
  final _regex = RegExp(r'\d+');

  Page(List<List<String>> pairs) {
    for (var el in pairs) {_lines.add(Line(toInt(el.first), toInt(el.last)));}
  }

  Page.fromLines(this._lines);

  bool isEmpty() {
    return _lines.isEmpty;
  }

  remove(int idx) {
    _lines.removeAt(idx);
  }

  int toInt(String str) {
    var res = _regex.firstMatch(str);
    return res == null ? 0 : int.parse(res[0]!);
  }

  List<List<int>> search(int code) {
    List<List<int>> res = [];
    for (int i = 0; i < _lines.length; i++) {
      if (_lines[i].code == code) {
        res.add([_lines[i].id, i]);
      }
    }
    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      'lines': _lines.map((line) => line.toJson()).toList(),
    };
  }

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page.fromLines((json['lines'] as List).map((lineJson) => Line.fromJson(lineJson)).toList());
  }

  @override
  String toString() {
    String res = "";
    for (var i = 0; i < _lines.length; i++) {
      res += "${_lines[i].code}\n";
    }
    return res;
  }
}

class Line {
  int id;
  int code;

  Line(this.id, this.code);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
    };
  }

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line((json['id'] as int), json['code']);
  }
}