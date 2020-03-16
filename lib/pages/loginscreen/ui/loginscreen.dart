import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goldfarm/pages/OTPScreen/ui/otpscreen.dart';
import 'package:goldfarm/pages/homepage/ui/homepage.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:goldfarm/utils/sliderout.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var phoneNumberControler = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  String countryCode = "+91";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(Const.logo,width: 140,height: 140,fit: BoxFit.fill,),
                     /* Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 10),
                        child: Text(
                            AppLocalizations.of(context).translate("welcomeSub")?? Const.welcomeSub,
                          style: TextStyle(
                              color: Color(ColorAsset.acentColor),
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        )
                      ),*/
                     /* Text(
                        AppLocalizations.of(context).translate("version")?? Const.version,
                        style: TextStyle(color: Colors.black38, fontSize: 18),
                      )*/
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Text(
                      AppLocalizations.of(context).translate("mobileVerification")?? Const.mobileVerification,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  /*Text(
                      AppLocalizations.of(context).translate("mobileVerificationSub")?? Const.mobileVerificationSub,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(ColorAsset.lightBlackColor))),*/
                  /*Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Text(
                        AppLocalizations.of(context).translate("enterMobileNO")?? Const.enterMobileNO,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(ColorAsset.lightBlackColor))),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        CountryCodePicker(
                          onChanged: (value) {
                            print(value.code);
                            setState(() {
                              countryCode = value.dialCode;
                            });
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: new TextField(
                              controller: phoneNumberControler,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Enter Mobile Number",
                              ),
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.all(18),
                          onPressed: () {
                            if (phoneNumberControler.text == '') {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context).translate("phoneIsEmpty")?? Const.phoneIsEmpty,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  fontSize: 16.0);
                            } else if (phoneNumberControler.text.length < 10) {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context).translate("phoneMust")?? Const.phoneMust,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  fontSize: 16.0);
                            } else {
                              _onVerifyCode(context,"${countryCode}${phoneNumberControler.text}");
                            }
                          },
                          child: Text(AppLocalizations.of(context).translate("getOtp")?? Const.getOtp.toUpperCase(),
                              style: TextStyle(color: Colors.white)),
                          color: Color(ColorAsset.acentColor),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

   void _onVerifyCode(BuildContext context,String mobileno) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          print(value.user.phoneNumber);
        } else {
          print(AppLocalizations.of(context).translate("otpValidationError")?? Const.otpValidationError);
        }
      }).catchError((error) {
        print(AppLocalizations.of(context).translate("somthingWrong")?? Const.somthingWrong);
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(authException.message);
      Fluttertoast.showToast(
          msg: authException.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
      print(AppLocalizations.of(context).translate("checkOTP")?? Const.checkOTP);

      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("checkOTP")?? Const.checkOTP,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      Navigator.pop(context);
      navigationPage();
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "${countryCode}${phoneNumberControler.text}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
//llo
  void navigationPage() {
    Navigator.of(context).push(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => OTPScreen(verficationId: _verificationId,mobileno: "${countryCode}${phoneNumberControler.text}"),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}
