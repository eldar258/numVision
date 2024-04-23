
class Page {
  final _numbers = <_Line>[];
  final _regex = RegExp(r'\d+');

  Page(List<List<String>> pairs) {
    for (var el in pairs) {_numbers.add(_Line(toInt(el.first), toInt(el.last)));}
  }

  bool isEmpty() {
    return _numbers.isEmpty;
  }

  remove(int idx) {
    _numbers.removeAt(idx);
  }

  int toInt(String str) {
    var res = _regex.firstMatch(str);
    return res == null ? 0 : int.parse(res[0]!);
  }

  List<List<int>> search(int code) {
    List<List<int>> res = [];
    for (int i = 0; i < _numbers.length; i++) {
      if (_numbers[i].code == code) {
        res.add([_numbers[i].id, i]);
      }
    }
    return res;
  }
}

class _Line {
  int id;
  int code;

  _Line(this.id, this.code);
}