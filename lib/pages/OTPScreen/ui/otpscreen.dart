import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goldfarm/pages/OTPScreen/widgets/otp_input.dart';
import 'package:goldfarm/pages/homepage/ui/homepage.dart';
import 'package:goldfarm/pages/profilepage/ui/profilepage.dart';
import 'package:goldfarm/pages/OTPScreen/service/otpservice.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:goldfarm/utils/prefrence.dart';
import 'package:goldfarm/utils/sliderout.dart';

import '../../../utils/colors.dart';
import '../../../utils/const.dart';

class OTPScreen extends StatefulWidget {
  final String verficationId;
  final String mobileno;

  const OTPScreen({Key key, this.verficationId, this.mobileno})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _verificationId;

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.green, hintText: '******');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Image.asset(
                        Const.logo,
                        width: 140,
                        height: 140,
                        fit: BoxFit.fill,
                      ),
                      /*Padding(
                          padding: const EdgeInsets.only(bottom: 8, top: 10),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("welcomeSub")?? Const.welcomeSub,
                            style: TextStyle(
                                color: Color(ColorAsset.acentColor),
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          )),*/
                     /* Text(
                        AppLocalizations.of(context).translate("version")?? Const.version,
                        style: TextStyle(color: Colors.black38, fontSize: 18),
                      )*/
                    ],
                  ),
                 /* Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("mobileVerification")?? Const.mobileVerification,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),*/
                 /* Text(
                      AppLocalizations.of(context)
                          .translate("mobileVerificationSub")?? Const.mobileVerificationSub,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(ColorAsset.lightBlackColor))),*/
                 /* Padding(
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
                    padding: const EdgeInsets.all(25.0),
                    child: PinInputTextField(
                      pinLength: 6,
                      decoration: _pinDecoration,
                      controller: _pinEditingController,
                      autoFocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmit: (pin) {
                        if (pin.length == 6) {
                        } else {}
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*Text(AppLocalizations.of(context).translate("dontReceiveOTP")?? Const.dontReceiveOTP),*/
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: Text(
                          AppLocalizations.of(context).translate("resendOTP")?? Const.resendOTP,
                          style: TextStyle(color: Color(ColorAsset.acentColor)),
                        ),
                        onTap: () {
                          _onVerifyCode(context, widget.mobileno);
                        },
                      ),
                    ],
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
                            _onFormSubmitted();
                          },
                          child: Text(AppLocalizations.of(context).translate("verifyAndProceed")?? Const.verifyAndProceed.toUpperCase(),
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

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: widget.verficationId,
        smsCode: _pinEditingController.text);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) async {
      if (value.user != null) {
        var data = OTPService.verifyUser(uid: value.user.uid);
        data.listen((event) {
//          print(event["profile"]);

          try {
            if (event["profile"] != null) {
              PrefManager.setUserId(value.user.uid);
              Navigator.pop(context);
              Navigator.of(context).push(SlideRightRoute(
                  page: HomePage(
                fireuser: value.user.uid,
              )));
            } else {
              Navigator.pop(context);
              Navigator.of(context).push(SlideRightRoute(
                  page: ProfilePage(
                user: value.user,
              )));
            }
          } catch (e) {
            Navigator.pop(context);
            Navigator.of(context).push(SlideRightRoute(
                page: ProfilePage(
              user: value.user,
            )));
          }
        });
      } else {
        print(AppLocalizations.of(context).translate("otpValidationError")?? Const.otpValidationError);
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("otpValidationError")?? Const.otpValidationError,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((error) {
      print(AppLocalizations.of(context).translate("somthingWrong")?? Const.somthingWrong);
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("somthingWrong")?? Const.somthingWrong,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG);
    });
  }

  void _onVerifyCode(BuildContext context, String mobileno) async {
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
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: mobileno,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
