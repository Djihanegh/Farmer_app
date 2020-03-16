import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goldfarm/models/user_model.dart';
import 'package:goldfarm/pages/homepage/ui/homepage.dart';
import 'package:goldfarm/pages/profilepage/provider/profile_provider.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:goldfarm/utils/prefrence.dart';
import 'package:goldfarm/utils/sliderout.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:goldfarm/utils/loading.dart';

import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;

  const ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var whatsappController = TextEditingController();

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
  void initState() {
    super.initState();

    if (widget.user != null) {
      whatsappController.text = widget.user.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProfileProvider>(context);
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          width >= 400
                              ? Image.asset(
                                  Const.logo,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  Const.logo,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 40),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("profileVarification")?? Const.profileVarification,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Text(
                              AppLocalizations.of(context)
                                  .translate("mobileVerificationSub")?? Const.mobileVerificationSub,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(ColorAsset.lightBlackColor))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            Center(
                                child: _image == null
                                    ? InkWell(
                                        onTap: () async {
                                          await getImage();
                                          FirebaseUser user = await FirebaseAuth
                                              .instance
                                              .currentUser();
                                          provider.uploadImage(_image,
                                              "FieldAgent/${user.uid}/");
                                        },
                                        child: width >= 400
                                            ? Image.asset(
                                                "images/fieldappuser.png",
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.asset(
                                                "images/fieldappuser.png",
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
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          child: Image.file(
                                            _image,
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: nameController,
                                    decoration: new InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(15),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color(ColorAsset.acentColor),
                                              width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black38,
                                              width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0)),
                                        hintText: "Name",
                                        hintStyle: TextStyle(
                                            color:
                                                Color(ColorAsset.acentColor))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration: new InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(15),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color(ColorAsset.acentColor),
                                              width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black38,
                                              width: 1.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black38,
                                                width: 1.0)),
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            color:
                                                Color(ColorAsset.acentColor))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                        ),
                                        padding: EdgeInsets.all(18),
                                        onPressed: () async {
                                          if (_image == null) {
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(context).translate("uploadImage")?? Const.uploadImage,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIos: 1,
                                                textColor: Colors.black38,
                                                fontSize: 16.0);
                                          } else if (nameController.text ==
                                              '') {
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(context).translate("enterNameError")?? Const.enterNameError,
                                                gravity: ToastGravity.BOTTOM,
                                                toastLength: Toast.LENGTH_LONG);
                                          } else if (emailController.text ==
                                              '') {
                                            Fluttertoast.showToast(
                                                msg: AppLocalizations.of(context).translate("enterEmailError")?? Const.enterEmailError,
                                                gravity: ToastGravity.BOTTOM,
                                                toastLength: Toast.LENGTH_LONG);
                                          } else if (!EmailValidator.validate(
                                              emailController.text)) {
                                            Fluttertoast.showToast(
                                                msg:  AppLocalizations.of(context).translate("emailInvalid")?? Const.emailInvalid,
                                                gravity: ToastGravity.BOTTOM,
                                                toastLength: Toast.LENGTH_LONG);
                                          } else if (whatsappController.text ==
                                              '') {
                                            Fluttertoast.showToast(
                                                msg:  AppLocalizations.of(context).translate("enterwhatsappError")?? Const.enterwhatsappError,
                                                gravity: ToastGravity.BOTTOM,
                                                toastLength: Toast.LENGTH_LONG);
                                          } else {
                                            provider.setLoading(true);

                                            FirebaseUser userID =
                                                await FirebaseAuth.instance
                                                    .currentUser();
                                            var user = User(
                                                name: nameController.text
                                                    .toLowerCase(),
                                                email: emailController.text,
                                                number: whatsappController.text,
                                                profile: provider.imageUrl,
                                                timestamp: FieldValue
                                                    .serverTimestamp(),
                                                agent_uid: userID.uid);

                                            provider.addUserProfile(
                                                user, widget.user.uid);

                                            PrefManager.setUserId(userID.uid);

                                            Navigator.of(context).pop();

                                            Navigator.of(context)
                                                .push(SlideRightRoute(
                                                    page: HomePage(
                                              fireuser: userID.uid,
                                            )));
                                          }
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .translate("letsgetStarted")?? Const.letsgetStarted,
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: Color(ColorAsset.acentColor),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<ProfileProvider>(builder: (_, notifier, __) {
                  if (notifier.isLoading()) {
                    return Center(child: LoadingInDicator());
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
            )
          ],
        ),
      ),
    );
  }
}
