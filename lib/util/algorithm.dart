import 'package:pick_your_prof/data/professor.dart';
import 'package:pick_your_prof/data/course_data.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:path/path.dart';

Future<List<Professor>> getProfessors(CourseData courseData) async {
  String databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'grade_data.db');

  await deleteDatabase(path);

  ByteData data = await rootBundle.load(join('assets', 'grades.db'));
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await new File(path).writeAsBytes(bytes);

  Database db = await openDatabase(path);

  List<Map> profRows = await db.rawQuery("""
      SELECT prof AS name, a1, a2, a3, b1, b2, b3, c1, c2, c3, d1, d2, d3, f
      FROM agg
      WHERE dept = ? AND course_nbr = ?
      ORDER BY name
  """, [courseData.department, courseData.courseNumber]);
  print(profRows);

  List<String> profNames = [];
  List<List<double>> percentages = [];
  profRows.forEach((row) {
    // Reorder name into first name last name
    List<String> splitName = row['name'].split(new RegExp(r'\s+'));
    String finalName = splitName[1] + ' ' + splitName[0];
    profNames.add(finalName);
    // Stores info of percentage of each class that got each grade
    int totalStu = 0;
    row.forEach((k, numStu) {
      if (k != 'name')
        totalStu += numStu;
    });
    List<double> currPerc = [];
    row.forEach((k, numStu) {
      if (k != 'name')
        currPerc.add(numStu / totalStu);
    });
    percentages.add(currPerc);
  });

  List<Professor> professors = [];
  List<double> scores = getScores(profNames, percentages);
  for (int i = 0; i < profNames.length; i++) {
    professors.add(Professor(profNames[i], scores[i], ''));
  }
  professors.sort((a, b) => b.score.compareTo(a.score));
  print(professors);
  return professors;
}

List<double> getScores(List<String> profNames, List<List<double>> percentages) {
  List<double> scores = [];
  double score, avgGpa;
  for (int i = 0; i < profNames.length; i++) {
    final List<double> GPA = [4.0, 4.0, 3.67, 3.33, 3.0, 2.67, 2.33, 2.0, 1.67, 1.33, 1.0, 0.67, 0.0];
    avgGpa = 0.0;
    for (int j = 0; j < percentages[i].length; j++) {
      avgGpa += percentages[i][j] * GPA[j];
    }
    avgGpa *= 5 / 4;

    score = avgGpa * 2;
    scores.add(score);
  }
  return scores;
}