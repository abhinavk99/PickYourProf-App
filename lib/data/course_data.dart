class CourseData {
  String _department = '';
  String _courseNumber = '';

  CourseData(this._department, this._courseNumber);

  String get department => _department;

  String get courseNumber => _courseNumber;

  set courseNumber(String value) {
    _courseNumber = value;
  }

  set department(String value) {
    _department = value;
  }
}
