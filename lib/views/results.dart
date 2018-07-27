import 'package:flutter/material.dart';
import 'package:pick_your_prof/data/course_data.dart';
import 'package:pick_your_prof/widgets/result_card.dart';

class ResultsScreen extends StatefulWidget {
  CourseData courseQuery; //Holds the CourseData object passed in from the previous screen
  ResultsScreen(this.courseQuery); //Constructor for the current screen, requires a CourseData object

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ResultCard('Michael Scott', '4.83', 'http://www.ratemyprofessors.com/ShowRatings.jsp?tid=137818'),
          ResultCard('Gordon Novak', '3.7', 'http://www.ratemyprofessors.com/ShowRatings.jsp?tid=1297191'),
          ResultCard('Lucas', '1.3', 'https://www.google.com/'),
        ],
      ),
    );
  }
}
