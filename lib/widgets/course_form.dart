import 'package:flutter/material.dart';
import 'package:pick_your_prof/data/course_data.dart';

class CourseForm extends StatefulWidget {
  @override
  CourseFormState createState() => CourseFormState();
}

class CourseFormState extends State<CourseForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<_CourseFormState>!
  final _formKey = GlobalKey<FormState>();
  CourseData data = CourseData();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Center(
      child: Card(
        elevation: 4.0,
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Find the best professor.',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
              Form(
                key: this._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 350.0,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Department', hintText: 'Ex: CS'),
                        textAlign: TextAlign.center,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a department';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          this.data.department = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    Container(
                      width: 350.0,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Course Number', hintText: 'Ex: 314'),
                        textAlign: TextAlign.center,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a course number';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          this.data.courseNumber = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (this._formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Getting information for ${data.department} ${data.courseNumber}')));
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
