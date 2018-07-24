import 'package:flutter/material.dart';

class _CourseData {
  String department = '';
  String courseNumber = '';
}

class CourseForm extends StatefulWidget {
  @override
  CourseFormState createState() => CourseFormState();
}

class CourseFormState extends State<CourseForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<_CourseFormState>!
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _CourseData _data = new _CourseData();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return new Container(
      alignment: Alignment.center,
      child: new Form(
        key: this._formKey,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 350.0,
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Department', hintText: 'Ex: CS'),
                textAlign: TextAlign.center,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a department';
                  }
                  return null;
                },
                onSaved: (String value) {
                  this._data.department = value;
                },
              ),
            ),
            new Container(
              width: 350.0,
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Course Number', hintText: 'Ex: 314'),
                textAlign: TextAlign.center,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a course number';
                  }
                  return null;
                },
                onSaved: (String value) {
                  this._data.courseNumber = value;
                },
              ),
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: new RaisedButton(
                onPressed: () {
                  if (this._formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Getting information for ${_data.department} ${_data.courseNumber}')));
                  }
                },
                child: new Text(
                  'Submit',
                  style: new TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
