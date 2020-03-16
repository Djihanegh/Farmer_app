import 'package:flutter/material.dart';
import 'package:goldfarm/pages/homepage/widgets/drawer.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';

class ContactUs extends DrawerContent {
  final String title;

  ContactUs({Key key, this.title});

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
            child: ListView(
              children: [
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
                                  AppLocalizations.of(context).translate("welcomeSub")?? Const.welcomeSub,
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
                                AppLocalizations.of(context).translate("version")?? Const.version,
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
                    child: Text(
                      "CONTACT US",
                      style: TextStyle(
                          color: Color(0xffE9E514),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Color(ColorAsset.acentColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              //"US: 50 Columbus Avenue, Unit 820, Tuckahoe, NY 10707",
                              "Inno sphere,4th floor, psg college of technology, peelamedu,coimbatore - 641004",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Color(ColorAsset.acentColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Icon(
                              Icons.phone_android,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              //"+19142809311",
                              " +19655205602",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
