import 'package:flutter/material.dart';
import 'package:pick_your_prof/data/course_data.dart';
import 'package:pick_your_prof/widgets/result_card.dart';
import 'package:pick_your_prof/data/professor.dart';
import 'package:pick_your_prof/util/algorithm.dart';

class ResultsScreen extends StatefulWidget {
  CourseData courseQuery; //Holds the CourseData object passed in from the previous screen
  ResultsScreen(this.courseQuery); //Constructor for the current screen, requires a CourseData object

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Professor> _professors;

  @override
  void initState() {
    super.initState();
    getProfessors(widget.courseQuery).then((professors) {
      setState(() {
        _professors = professors;
      });
    });
  }

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
          ResultCard(Professor('Michael Scott', 4.83, 'http://www.ratemyprofessors.com/ShowRatings.jsp?tid=137818')),
          ResultCard(Professor('Gordon Novak', 3.7, 'http://www.ratemyprofessors.com/ShowRatings.jsp?tid=1297191')),
          ResultCard(Professor('Lucas', 1.3, '')),
        ],
      ),
    );
  }
}
