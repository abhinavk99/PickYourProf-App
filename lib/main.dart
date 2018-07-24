import 'package:flutter/material.dart';

void main() => runApp(new PickYourProf());

class PickYourProf extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'PickYourProf',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: const MaterialColor(0xFFbf5700, const <int, Color> {
          50:  const Color(0xFFbf5700),
          100: const Color(0xFFbf5700),
          200: const Color(0xFFbf5700),
          300: const Color(0xFFbf5700),
          400: const Color(0xFFbf5700),
          500: const Color(0xFFbf5700),
          600: const Color(0xFFbf5700),
          700: const Color(0xFFbf5700),
          800: const Color(0xFFbf5700),
          900: const Color(0xFFbf5700),
        }),
      ),
      home: new HomePage(title: 'PickYourProf'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Find the best professor.',
              style: new TextStyle(
                fontSize: 24.0,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: new _CourseForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseForm extends StatefulWidget {
  @override
  _CourseFormState createState() {
    return new _CourseFormState();
  }
}

class _CourseData {
  String department = '';
  String courseNumber = '';
}

class _CourseFormState extends State<_CourseForm> {
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
                decoration: new InputDecoration(
                  labelText: 'Department',
                  hintText: 'Ex: CS'
                ),
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
                decoration: new InputDecoration(
                  labelText: 'Course Number',
                  hintText: 'Ex: 314'
                ),
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
                    Scaffold
                      .of(context)
                      .showSnackBar(
                      new SnackBar(
                        content: Text(
                          'Getting information for ${_data.department} ${_data.courseNumber}'
                        )
                      )
                    );
                  }
                },
                child: new Text(
                  'Submit',
                  style: new TextStyle(
                      color: Colors.white
                  ),
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
