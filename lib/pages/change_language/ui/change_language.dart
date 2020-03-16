import 'package:flutter/material.dart';
import 'package:goldfarm/main.dart';
import 'package:goldfarm/pages/homepage/widgets/drawer.dart';
import 'package:goldfarm/pages/splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/colors.dart';
import '../../../utils/const.dart';
import '../../../utils/localization/localizations.dart';

class ChangeLanguage extends DrawerContent {
  final String title;
  ChangeLanguage({Key key, this.title});
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: widget.title == "HomePage"
                  ? Image.asset(
                      "images/logo.png",
                      width: 40,
                      height: 40,
                    )
                  : Text(widget.title),
              leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: widget.onMenuPressed),
            ),
            body: Column(children: [
              Expanded(
                  child: ListView(children: [
                Container(
                  color: Color(ColorAsset.acentColor),
                  height: 200,
                  padding: EdgeInsets.only(top: 20),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "images/logo.png",
                              height: 100,
                              width: 100,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("welcomeSub") ??
                                    Const.welcomeSub,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("version") ??
                                    Const.version,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        alignment: Alignment.bottomCenter,
                      )
                    ],
                  ),
                ),
                Center(
                    child: Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Color(ColorAsset.acentColor),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: InkWell(
                    child: Text(
                      "ENGLISH",
                      style: TextStyle(
                          color: Color(0xffE9E514),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      var prefs = await SharedPreferences.getInstance();
                      prefs.setString('languageCode', "en");
                      prefs.setString('countryCode', "");
                      MyApp.setLocale(context, Locale("en"));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    },
                  ),
                )),
                Center(
                    child: Container(
                  // margin: EdgeInsets.only(top:2),
                  padding: EdgeInsets.only(left:25,right: 25,top: 15,bottom: 15),
                  decoration: BoxDecoration(
                      color: Color(ColorAsset.acentColor),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: InkWell(
                    child: Text(
                      "TAMIL",
                      style: TextStyle(
                          color: Color(0xffE9E514),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      var prefs = await SharedPreferences.getInstance();
                      prefs.setString('languageCode', "ta");
                      prefs.setString('countryCode', "");
                      MyApp.setLocale(context, Locale("ta"));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    },
                  ),
                )),
              ]))
            ])));
  }
}

/*child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: widget.title == "HomePage" ? Image.asset("images/logo.png",width: 40,height: 40,):Text(widget.title),
          leading: IconButton(icon: Icon(Icons.menu,color: Colors.black87,), onPressed: widget.onMenuPressed),
        ),
        body: ListView(
          children: <Widget>[
            InkWell(
              child: Text("English"),
              onTap: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setString('languageCode', "en");
                prefs.setString('countryCode', "");
                MyApp.setLocale(context, Locale("en"));
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
              },
            ),
            InkWell(
              child: Text("Tamil"),
              onTap: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setString('languageCode', "ta");
                prefs.setString('countryCode', "");
                MyApp.setLocale(context, Locale("ta"));
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
              },
            ),
          ],
        ),
      ),
*/
