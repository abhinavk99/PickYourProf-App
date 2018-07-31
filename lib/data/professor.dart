class Professor {
  String _name = '';
  double _score = 0.0;
  double _avgGPA = 0.0;
  String _link = '';

  Professor(this._name, this._score, this._avgGPA, this._link);

  String get name => _name;

  double get score => _score;

  double get avgGPA => _avgGPA;

  String get link => _link;

  @override
  String toString() => '{name: $_name, score: $_score, gpa: $_avgGPA, link: $_link}';

}
