import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goldfarm/models/farmer_model.dart';
import 'package:goldfarm/pages/OTPScreen/widgets/otp_input.dart';
import 'package:goldfarm/pages/farmer_register/provider/farmerregister_provider.dart';
import 'package:goldfarm/pages/farmer_register/service/farmerregister_service.dart';
import 'package:goldfarm/pages/homepage/ui/homepage.dart';
import 'package:goldfarm/pages/homepage/widgets/drawer.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:goldfarm/utils/prefrence.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum SingingCharacter { Male, Female }

class FarmerRegister extends DrawerContent {
  FarmerRegister({Key key, this.title});

  final String title;

  @override
  _FarmerRegisterState createState() => _FarmerRegisterState();
}

class _FarmerRegisterState extends State<FarmerRegister> {
  SingingCharacter _character = SingingCharacter.Male;
  TextEditingController _pinEditingController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController alterMobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;

  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.green, hintText: '******');

  File _image;

  Future getImage() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    var image = await ImageCropper.cropImage(
        sourcePath: image2.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Color(ColorAsset.acentColor),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _image = image;
      print(_image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: widget.title == "HomePage"
                ? Image.asset(
                    "images/logo.png",
                    width: 40,
                    height: 40,
                  )
                : Text(
                    widget.title,
                    style: TextStyle(color: Colors.black),
                  ),
            leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black87,
                ),
                onPressed: widget.onMenuPressed),
          ),
          body: Column(children: [
            Expanded(
              child: ListView(
                children: [buildForm(context)],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                    child: Container(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context).translate("reset")?? Const.reset,
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xffA9A9A9),
                        ))),
                Expanded(
                    child: Container(
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_image == null) {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)
                                      .translate("uploadImage")?? Const.uploadImage,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            } else if (nameController.text == '') {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)
                                      .translate("enterNameError")?? Const.enterNameError,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            } else if (mobileController.text == '') {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)
                                      .translate("mobileNOError")?? Const.mobileNOError,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            } else if (mobileController.text.length < 10) {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)
                                      .translate("mobileNOError")?? Const.mobileNOError,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            } else if (alterMobileController.text.length < 10) {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)
                                      .translate("alterMobile")?? Const.alterMobile,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            } else if (ageController.text == '') {
                              Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context)
                                      .translate("ageError")?? Const.ageError,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            } else {
                              bool data =
                                  await FarmerRegisterService.validateNumber(
                                      "+91${mobileController.text}");
                              if (data) {
                                _onVerifyCode(context, mobileController.text);
                                modelBotomSheetMenu(context);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              } else {
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context).translate("mobileRegister")?? Const.mobileRegister,
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_LONG);
                              }
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("saveContinue")?? Const.saveContinue,
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(ColorAsset.acentColor),
                        ))),
              ],
            )
          ])),
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Text(
                  AppLocalizations.of(context).translate("photo")?? Const.photo,
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
                ),
                alignment: Alignment.center,
              ),
              Center(
                  child: _image == null
                      ? InkWell(
                          onTap: () async {
                            await getImage();
                          },
                          child: Image.asset(
                            "images/farmuser.png",
                            height: 80,
                            width: 80,
                            fit: BoxFit.fill,
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.file(
                              _image,
                              height: 90,
                              width: 90,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate("name")?? Const.name),
                controller: nameController,
              ),
              TextField(
                maxLength: 10,
                controller: mobileController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context).translate("mobileNumber")?? Const.mobileNumber),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context).translate("alterMobile")?? Const.alterMobile),
                maxLength: 10,
                controller: alterMobileController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                maxLength: 2,
                controller: ageController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate("age")?? Const.age),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate("gender")?? Const.gender,
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: SingingCharacter.Male,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        Text(AppLocalizations.of(context).translate("male")?? Const.male),
                        Radio(
                          value: SingingCharacter.Female,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        Text(AppLocalizations.of(context).translate("female")?? Const.female)
                      ],
                    )
                  ],
                ),
              ),
              Consumer<FarmerRegisterProvider>(builder: (_, notifier, __) {
                if (notifier.isLoading()) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return notifier.fuser == null
                      ? Container()
                      : notifier.fuser.fold(
                          (failure) => failure == null
                              ? Container()
                              : Text(failure.toString()), (post) {
                          if (post == null) {
                            return Container();
                          } else {
                            Fluttertoast.showToast(
                                msg: post,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                textColor: Colors.black38,
                                fontSize: 16.0);

                            return Container();
                          }
                        });
                }
              }),
            ],
          ),
        )
      ],
    );
  }

  void modelBotomSheetMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("enterOtpSentTo")?? Const.enterOtpSentTo,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                  height: 50,
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).translate("cancle")?? Const.cancle,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Color(0xffA9A9A9),
                                  ))),
                          Expanded(
                              child: Container(
                                  height: 50,
                                  child: RaisedButton(
                                    onPressed: () {
                                      _onFormSubmitted(context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("saveContinue")?? Const.saveContinue,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Color(ColorAsset.acentColor),
                                  ))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
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
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91$mobileno",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted(BuildContext context) async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) async {
      if (value.user != null) {
        print("Sucess ${value.user.phoneNumber}");

        var provider =
            Provider.of<FarmerRegisterProvider>(context, listen: false);

        var image =
            await provider.uploadImage(_image, "Farmer/${value.user.uid}/");

        var agent_id = await PrefManager.getUserId();

        await provider.addFarmerProfile(
            value.user.uid,
            nameController.text,
            int.parse(ageController.text),
            image,
            FieldValue.serverTimestamp(),
            "+91${alterMobileController.text}",
            "+91${mobileController.text}",
            agent_id,
            _character.toString().substring(17));

        Navigator.of(context).pop();

        FocusScope.of(context).requestFocus(FocusNode());

        print("User is: ${provider.fuser.toString()}");

        navigationPage();
      } else {
        print(AppLocalizations.of(context).translate("otpValidationError")?? Const.otpValidationError);
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("otpValidationError")?? Const.otpValidationError,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((error) {
      print("Something went wrong $error");
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context).translate("somthingWrong")?? Const.somthingWrong,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG);
    });
  }

  Future<void> navigationPage() async {
    var uid = await PrefManager.getUserId();
    Navigator.of(context).push(_createRoute(uid));
  }

  Route _createRoute(String uid) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(
        fireuser: uid,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
