import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class ResultCard extends StatelessWidget {
  String profName;
  String score;
  String ratemyprofLink; //Hold the link to his/her rate my professor page

  ResultCard(this.profName, this.score, this.ratemyprofLink);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    this.profName,
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                    ),
                  ),
                  FlatButton(
                    //Enable button only if link is available
                    onPressed: ratemyprofLink != '' ? () => _launchURL(context, ratemyprofLink) : null,
                    child: Text('More Info'),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Score: ' + this.score,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
            animation: new CustomTabsAnimation.slideIn()),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
