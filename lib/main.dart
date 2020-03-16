import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goldfarm/pages/business_partner_register/provider/partnerregister_provider.dart';
import 'package:goldfarm/pages/farmer_register/provider/farmerregister_provider.dart';
import 'package:goldfarm/pages/farmer_upload_kyc/service/upload_kyc_service.dart';
import 'package:goldfarm/pages/homepage/services/homepageservice.dart';
import 'package:goldfarm/pages/partner_upload_kyc/service/upload_kyc_service.dart';
import 'package:goldfarm/pages/profilepage/provider/profile_provider.dart';
import 'package:goldfarm/pages/splashscreen/splashscreen.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:provider/provider.dart';
import 'package:goldfarm/pages/farmer_detail/provider/farmer_detail_provider.dart';
import 'package:goldfarm/pages/farmer_detail/service/farmerdetail_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  static void setLocale(BuildContext context, Locale newLocale) async {
    print('setLocale()');
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());

    state.setState(() {
      state.locale = newLocale;
    });
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('initState()');

    this._fetchLocale().then((locale) {
      print(" local is : $locale");
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('languageCode') == null) {
      prefs.setString('languageCode', 'en');
      prefs.setString('countryCode', '');
      return Locale(prefs.getString('languageCode'), prefs.getString('countryCode'));
    }

    print('_fetchLocale():' +
        (prefs.getString('languageCode') +
            ':' +
            prefs.getString('countryCode')));

    return Locale(
        prefs.getString('languageCode'), prefs.getString('countryCode'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => FarmerRegisterProvider()),
        ChangeNotifierProvider(create: (_) => PartnerRegisterProvider()),
        ChangeNotifierProvider(create: (_) => FarmerDetailProvider()),
        Provider<HomePageService>(
          create: (_) => HomePageService(),
        ),
        Provider<UploadKycService>(
          create: (_) => UploadKycService(),
        ),
        Provider<PartnerUploadKycService>(
          create: (_) => PartnerUploadKycService(),
        ),
        Provider<FarmerDetailService>(
          create: (_) => FarmerDetailService(),
        ),
      ],
      child: MaterialApp(
        title: 'Goldfarm FieldApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            platform: TargetPlatform.iOS,
            accentColor: Color(ColorAsset.acentColor),
            primaryColor: Color(ColorAsset.acentColor)),
        home: SplashScreen(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English
          const Locale('ta', ''), // Hindi
        ],
        locale: locale,
      ),
    );
  }
}
