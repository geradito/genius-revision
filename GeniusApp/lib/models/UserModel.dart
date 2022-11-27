class User {
  int _id;
  String _name;
  int _level;
  int _points;


  User.withId(this._id,
      this._name,
      this._level,
      this._points);

  User(
      this._name,
      this._level,
      this._points);

  int get id => _id;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'level': _level,
      'points': _points,
    };
  }

  User.fromMapObject(Map<String,dynamic> map) {
      this._id = map['id'];
      this._name = map['name'];
      this._level = map['level'];
      this._points = int.parse(map['points']);
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, name: $name, level: $level, points: $points}';
  }

  String get name => _name;

  int get points => _points;

  int get level => _level;
}