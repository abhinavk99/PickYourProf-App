import 'package:flutter/material.dart';
import 'package:pick_your_prof/data/course_data.dart';

class ResultsScreen extends StatefulWidget {
  CourseData courseQuery; //Holds the CourseData object passed in from the previous screen
  ResultsScreen(this.courseQuery); //Constructor for the current screen, requires a CourseData object

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
