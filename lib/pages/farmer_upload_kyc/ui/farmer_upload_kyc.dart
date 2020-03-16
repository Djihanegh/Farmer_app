import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goldfarm/pages/farmer_upload_kyc/service/upload_kyc_service.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FarmerKycUpload extends StatefulWidget {
  final String fid;

  const FarmerKycUpload({Key key, this.fid}) : super(key: key);

  @override
  _FarmerKycUploadState createState() => _FarmerKycUploadState();
}

class _FarmerKycUploadState extends State<FarmerKycUpload> {
  File adharfront, adharback, pancard, otherdoc;

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
      adharfront = image;
      print(adharfront.path);
    });
    return adharfront;
  }

  Future getAdharImage() async {
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
      adharback = image;
      print(adharback.path);
    });
    return adharback;
  }

  Future getPanCardImage() async {
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
      pancard = image;
      print(pancard.path);
    });
    return pancard;
  }

  Future getOtherDocumentImage() async {
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
      otherdoc = image;
      print(otherdoc.path);
    });
    return otherdoc;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<UploadKycService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          AppLocalizations.of(context).translate("uploadKyc")?? Const.uploadKyc,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: database.getFarmer(uid: widget.fid),
        builder: (context, snapshot) {
          return ListView(
            children: <Widget>[
              snapshot.data["adharfront"] == null
                  ? InkWell(
                      onTap: () {
                        getImage().then((value) {
                          UploadKycService.uploadFile(
                                  adharfront, "Farmer/${widget.fid}/Doc1/")
                              .then((value) {
                            var message = UploadKycService.addDoc(
                              image: value,
                              fid: widget.fid,
                              imagename: "adharfront",
                              meassage: "Pending"
                            );
                            Fluttertoast.showToast(
                                msg: message,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          });
                        });
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                AppLocalizations.of(context).translate("adharfront")?? Const.adharfront,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: adharfront == null
                                  ? Image.asset(
                                      "images/upload.png",
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.file(
                                      adharfront,
                                      width: 100,
                                      height: 100,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  AppLocalizations.of(context).translate("adharfront")?? Const.adharfront,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/sucess.png",
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Image.network(
                              snapshot.data["adharfront"],
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
              snapshot.data["adharback"] == null
                  ? InkWell(
                      onTap: () {
                        getAdharImage().then((value) {
                          UploadKycService.uploadFile(
                                  adharback, "Farmer/${widget.fid}/Doc2/")
                              .then((value) {
                            var message = UploadKycService.addDoc(
                              image: value,
                              fid: widget.fid,
                              imagename: "adharback",
                                meassage: "Pending"
                            );
                            Fluttertoast.showToast(
                                msg: message,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          });
                        });
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                AppLocalizations.of(context).translate("adharback")?? Const.adharback,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: adharback == null
                                  ? Image.asset(
                                      "images/upload.png",
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.file(
                                      adharback,
                                      width: 100,
                                      height: 100,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  AppLocalizations.of(context).translate("adharback")?? Const.adharback,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/sucess.png",
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Image.network(
                              snapshot.data["adharback"],
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
              snapshot.data["pancard"] == null
                  ? InkWell(
                      onTap: () {
                        getPanCardImage().then((value) {
                          UploadKycService.uploadFile(
                                  pancard, "Farmer/${widget.fid}/Doc3/")
                              .then((value) {
                            var message = UploadKycService.addDoc(
                              image: value,
                              fid: widget.fid,
                              imagename: "pancard",
                                meassage: "Pending"
                            );
                            Fluttertoast.showToast(
                                msg: message,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          });
                        });
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                AppLocalizations.of(context).translate("pancard")?? Const.pancard,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: pancard == null
                                  ? Image.asset(
                                      "images/upload.png",
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.file(
                                      pancard,
                                      width: 100,
                                      height: 100,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  AppLocalizations.of(context).translate("pancard")?? Const.pancard,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/sucess.png",
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Image.network(
                              snapshot.data["pancard"],
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
              snapshot.data["otherdoc"] == null
                  ? InkWell(
                      onTap: () {
                        getOtherDocumentImage().then((value) {
                          UploadKycService.uploadFile(
                                  otherdoc, "Farmer/${widget.fid}/Doc4/")
                              .then((value) {
                            var message = UploadKycService.addDoc(
                              image: value,
                              fid: widget.fid,
                              imagename: "otherdoc",
                                meassage: "Sucess"
                            );
                            Fluttertoast.showToast(
                                msg: message,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          });
                        });
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                AppLocalizations.of(context).translate("otheImage")?? Const.otheImage,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: otherdoc == null
                                  ? Image.asset(
                                      "images/upload.png",
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.file(
                                      otherdoc,
                                      width: 100,
                                      height: 100,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  AppLocalizations.of(context).translate("otheImage")?? Const.otheImage,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/sucess.png",
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Image.network(
                              snapshot.data["otherdoc"],
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
