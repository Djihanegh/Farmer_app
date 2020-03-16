import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goldfarm/pages/business_partner_register/ui/business_partner_register.dart';
import 'package:goldfarm/pages/change_language/ui/change_language.dart';
import 'package:goldfarm/pages/contactus/ui/contactus.dart';
import 'package:goldfarm/pages/farmer_register/ui/farmer_register.dart';
import 'package:goldfarm/pages/homepage/services/homepageservice.dart';
import 'package:goldfarm/pages/homepage/widgets/drawer.dart';
import 'package:goldfarm/pages/homepage/widgets/home.dart';
import 'package:goldfarm/pages/loginscreen/ui/loginscreen.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainWidget extends StatefulWidget {
  MainWidget({Key key, this.title, this.fireUser, this.context}) : super(key: key);
  final String title;
  final String fireUser;
  final BuildContext context;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  HiddenDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = HiddenDrawerController(
      initialPage: MainPage(
        title: 'HomePage',
        context: widget.context
      ),
      items: [ 
        DrawerItem(
          text: Text(AppLocalizations.of(widget.context).translate("homePage")?? Const.homePage, style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),
          page: MainPage(
            title: AppLocalizations.of(widget.context).translate("homePage")?? Const.homePage,
            context: widget.context,
          ),
        ),
        DrawerItem(
          text: Text(
            AppLocalizations.of(widget.context).translate("farmerRegister")?? Const.farmerRegister,
            style: TextStyle(color: Colors.white),
          ),
          icon: Image.asset(
            "images/farm.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: FarmerRegister(
            title: AppLocalizations.of(widget.context).translate("farmerRegister")?? Const.farmerRegister,
          ),
        ),
        DrawerItem(
          text: Text(
            AppLocalizations.of(widget.context).translate("businessPartnerRegister")?? Const.businessPartnerRegister,
            style: TextStyle(color: Colors.white),
          ),
          icon: Image.asset(
            "images/partner.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: BusinessPartnerRegister(
            title: AppLocalizations.of(widget.context).translate("businessPartnerRegister")?? Const.businessPartnerRegister,
          ),
        ),
        DrawerItem(
          text: Text(
            AppLocalizations.of(widget.context).translate("changeLanguage")?? Const.changeLanguage,
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.language, color: Colors.white),
          page: ChangeLanguage(
            title: AppLocalizations.of(widget.context).translate("changeLanguage")?? Const.changeLanguage,
          ),
        ),
        DrawerItem(
          text: Text(
            AppLocalizations.of(widget.context).translate("contactUs")?? Const.contactUs,
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.contacts, color: Colors.white),
          page: ContactUs(
            title: AppLocalizations.of(widget.context).translate("contactUs")?? Const.contactUs,
          ),
        ),
        DrawerItem(
          text: Text(
            AppLocalizations.of(widget.context).translate("logout")?? Const.logout,
            style: TextStyle(color: Colors.white),
          ),
          icon: Image.asset(
            "images/logout.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          page: DrawerContent(),
          onPressed: ()  async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.clear();
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<HomePageService>(context, listen: false);

    return Scaffold(
      body: HiddenDrawer(
        controller: _drawerController,
        header: Align(
          alignment: Alignment.topLeft,
          child: StreamBuilder<Map>(
            stream: database.jobStream(uid: widget.fireUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Image.network(
                          snapshot.data["profile"] ?? '',
                          width: 70,
                          height: 70,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: 135,
                              child: Text(
                                snapshot.data["name"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                              width: 135,
                              child: Text(
                                snapshot.data["number"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                              width: 135,
                              child: Text(
                               AppLocalizations.of(context).translate("fieldOperator")?? Const.fieldOperator,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )),
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return Center(
                  child: Text(Const.error),
                );
              }
            },
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff177A41), Color(0xff177A41)],
            // tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
