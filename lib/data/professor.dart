class Professor {
  String _name = '';
  double _score = 0.0;
  String _link = '';

  Professor(this._name, this._score, this._link);

  String get name => _name;

  double get score => _score;

  String get link => _link;

  @override
  String toString() => '{name: $_name, score: $_score, link: $_link}';

}
