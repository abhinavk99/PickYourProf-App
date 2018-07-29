import 'package:flutter/material.dart';
import 'package:pick_your_prof/data/course_data.dart';
import 'package:pick_your_prof/data/professor.dart';
import 'package:pick_your_prof/widgets/result_card.dart';
import 'package:pick_your_prof/util/algorithm.dart';

class ResultsScreen extends StatefulWidget {
  CourseData courseQuery; //Holds the CourseData object passed in from the previous screen
  ResultsScreen(this.courseQuery); //Constructor for the current screen, requires a CourseData object

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Professor> _professors;
  Widget _professorListWidget; //Will initialize as a progress indicator in initState but later updated via buildProfessorList();

  //Create the ListView holding the List of ResultCards based on a user's query
  Widget buildProfessorList() {
    return ListView.builder(
      itemCount: _professors.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          //Insert additional padding at the very top of the ListView for padding consistency
          return Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: ResultCard(_professors[index]),
          );
        } else {
          return ResultCard(_professors[index]);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _professorListWidget = CircularProgressIndicator();
    getProfessors(widget.courseQuery).then((professors) {
      setState(() {
        _professors = professors;
        _professorListWidget = buildProfessorList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: _professorListWidget,
    );
  }
}
