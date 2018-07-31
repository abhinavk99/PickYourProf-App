import 'package:pick_your_prof/data/professor.dart';
import 'package:pick_your_prof/data/course_data.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:path/path.dart' show join;
import 'package:http/http.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

List<String> profLinks = [];
List<double> profAvgGPA = [];

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
    List<String> splitName = row['name'].split(RegExp(r'\s+'));
    String finalName = formatToken(splitName[1]) + ' ' + formatToken(splitName[0]);
    profNames.add(finalName);
    // Stores info of percentage of each class that got each grade
    int totalStu = 0;
    row.forEach((k, numStu) {
      if (k != 'name') totalStu += numStu;
    });
    List<double> currPerc = [];
    row.forEach((k, numStu) {
      if (k != 'name') currPerc.add(numStu / totalStu);
    });
    percentages.add(currPerc);
  });

  List<Map<String, dynamic>> responses = await getProfessorsInfo(profNames);

  List<Professor> professors = [];
  List<double> scores = getScores(profNames, responses, percentages);
  for (int i = 0; i < profNames.length; i++) {
    professors.add(Professor(profNames[i], scores[i], profAvgGPA[i], profLinks[i]));
  }
  professors.sort((a, b) => b.score.compareTo(a.score));
  print(professors);
  profLinks = [];
  return professors;
}

List<double> getScores(List<String> profNames, List<Map<String, dynamic>> responses, List<List<double>> percentages) {
  // Gets the average of all the professor's metric averages
  int numProfs = 0;
  double sum = 0.0;
  List<double> metricAverages = [];
  double metricAverage;
  for (Map<String, dynamic> resp in responses) {
    if (resp['rating'] == null && resp['difficulty'] == null && resp['again'] == null) {
      metricAverages.add(-1.0);
    } else {
      numProfs++;
      normalizeMetrics(resp);
      metricAverage = getMetricAverage(resp);
      metricAverages.add(metricAverage);
      sum += metricAverage;
    }
  }
  double avg = sum / numProfs;

  List<double> scores = [];
  double score, avgGpa;
  for (int i = 0; i < profNames.length; i++) {
    if (metricAverages[i] == -1.0)
      metricAverages[i] = avg;

    const List<double> GPA = [4.0, 4.0, 3.67, 3.33, 3.0, 2.67, 2.33, 2.0, 1.67, 1.33, 1.0, 0.67, 0.0];
    avgGpa = 0.0;
    for (int j = 0; j < percentages[i].length; j++) {
      avgGpa += percentages[i][j] * GPA[j];
    }
    profAvgGPA.add(num.parse(avgGpa.toStringAsFixed(2)));
    avgGpa *= 5 / 4;

    score = numProfs != 0 ? avgGpa + metricAverages[i] : avgGpa * 2;
    scores.add(num.parse(score.toStringAsFixed(2)));
  }
  return scores;
}

double getMetricAverage(Map<String, dynamic> res) {
  double metricSum = 0.0;
  double numMetrics = 0.0;
  for (String prop in res.keys) {
    // Make rating worth more than difficulty and take again
    if (res[prop] != null) {
      if (prop == 'rating') {
        metricSum += res[prop];
        numMetrics++;
      } else {
        metricSum += res[prop] / 3;
        numMetrics += 1 / 3;
      }
    }
  }
  return metricSum / numMetrics;
}

// Normalize metrics in response to be out of 5.0 and fix types
void normalizeMetrics(Map<String, dynamic> res) {
  res['rating'] = res['rating'] != null ? double.parse(res['rating']) : null;
  // 5 - difficulty because we want to make higher difficulty be lower rating
  res['difficulty'] = res['difficulty'] != null ? 5 - double.parse(res['difficulty']) : null;
  // Again percentage / 20 to normalize it out of 5
  res['again'] = res['again'] != null ? double.parse(res['again']) / 20 : null;
  print(res);
}

String formatToken(String token) {
  if (token.length == 1) return token;
  token = token.substring(0, 1) + token.substring(1).toLowerCase();
  List<String> arr = token.split('-');
  return arr.length < 2 ? token : '${arr[0]}-${arr[1].substring(0, 1).toUpperCase()}${arr[1].substring(1)}';
}

const String BASE_URL = 'http://www.ratemyprofessors.com/search.jsp?queryoption=HEADER' +
'&queryBy=teacherName&schoolName=University+of+Texas+at+Austin&schoolID=1255&query=';

// Possible keys in the response map when getting professor info
const List<String> RESPONSE_KEYS = ['rating', 'difficulty', 'again'];

Future<List<Map<String, dynamic>>> getProfessorsInfo(List<String> profNames) async {
  List<Map<String, dynamic>> infoList = [];
  for (String name in profNames) {
    name = name.replaceAll(' ', '+');
    String link = BASE_URL + name;
    // Search for professor
    Response response = await get(link);
    Document document = parse(response.body);
    String htmas = document.querySelector('div.not-found-box').nextElementSibling.innerHtml;
    if (!htmas.contains('Your search')) {
      List<Element> listings = document.querySelectorAll('.listings');
      String endLink = listings[0].children[0].children[0].attributes['href'];
      // Scrape info of professor
      response = await get('http://www.ratemyprofessors.com' + endLink);
      document = parse(response.body);
      profLinks.add('http://www.ratemyprofessors.com' + endLink);
      Map<String, dynamic> responseMap = new Map<String, dynamic>();
      List<Element> divs = document.querySelectorAll('.grade');
      for (int i = 0; i < divs.length; i++) {
        if (i == 0) {
          Element ratingDiv = divs[i];
          if (ratingDiv != null) {
            String rating = ratingDiv.innerHtml.replaceAll(RegExp(r'\s+'), '');
            // Overall rating
            responseMap['rating'] = rating == 'N/A' ? null : rating;
          }
        } else if (i == 1) {
          Element difficultyDiv = document.querySelector('div.breakdown-section.difficulty .grade');
          if (difficultyDiv != null) {
            String difficulty = difficultyDiv.innerHtml.replaceAll(RegExp(r'\s+'), '');
            // Difficulty
            responseMap['difficulty'] = difficulty == 'N/A' ? null : difficulty;
          }
        } else if (i == 2) {
          Element againDiv = document.querySelector('div.breakdown-section.takeAgain .grade');
          if (againDiv != null) {
            String again  = againDiv.innerHtml.replaceAll(RegExp(r'\s+'), '');
            // Take again percentage
            responseMap['again'] = again == 'N/A' ? null : again;
          }
        }
      }
      infoList.add(responseMap);
    } else {
      profLinks.add('');
      infoList.add(Map<String, dynamic>());
    }
  }
  return infoList;
}
