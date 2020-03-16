import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goldfarm/animation/translate_animation.dart';
import 'package:goldfarm/pages/homepage/ui/homepage.dart';
import 'package:goldfarm/pages/loginscreen/ui/loginscreen.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:goldfarm/utils/prefrence.dart';
import 'package:goldfarm/utils/sliderout.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String fireuser;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: (Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TranslateAnimation(
                2,
                Image.asset(
                  Const.logo,
                  width: 140,
                  height: 140,
                  fit: BoxFit.fill,
                )),
            //hello
          /*  Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 10),
              child: TranslateAnimation(
                  2.5,
                  Text(
                    AppLocalizations.of(context).translate("fieldapp")?? Const.welcomeSub,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(ColorAsset.acentColor),
                      fontSize: 24,
                    ),
                  )),
            ),*/
           /* TranslateAnimation(
                2.7,
                Text(
                  AppLocalizations.of(context).translate("version")?? Const.version,
                  style: Theme.of(context).textTheme.headline,
                ))*/
          ],
        ),
      )),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
//    print("user id ${await PrefManager.getUserId()}");
    fireuser = await PrefManager.getUserId();
    if (fireuser == null) {
      Navigator.of(context).pop();
      Navigator.of(context).push(SlideRightRoute(page: LoginScreen()));
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).push(SlideRightRoute(
          page: HomePage(
        fireuser: fireuser,
      )));
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
}
