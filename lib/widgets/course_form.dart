import 'package:flutter/material.dart';
import 'package:pick_your_prof/data/course_data.dart';
import 'package:pick_your_prof/views/results.dart';

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
  String courseDepartment = '';
  String courseNumber = '';

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
                          courseDepartment = value;
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
                          courseNumber = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (this._formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            CourseData currentCourse = CourseData(courseDepartment, courseNumber);
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Getting information for ${courseDepartment} ${courseNumber}')));
                            //Maybe we could await the results method here and then navigate to the new page?
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsScreen(currentCourse)));
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
