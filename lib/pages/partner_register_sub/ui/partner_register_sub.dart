import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goldfarm/models/farmer_model.dart';
import 'package:goldfarm/pages/farmer_register_sub/service/farmer_sub_register_service.dart';
import 'package:goldfarm/pages/farmer_upload_kyc/ui/farmer_upload_kyc.dart';
import 'package:goldfarm/pages/partner_upload_kyc/service/upload_kyc_service.dart';
import 'package:goldfarm/pages/partner_upload_kyc/ui/partner_upload_kyc.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:provider/provider.dart';

class PartnerRegisterSub extends StatefulWidget {
  final String uid;

  const PartnerRegisterSub({Key key, this.uid}) : super(key: key);

  @override
  _PartnerRegisterSubState createState() => _PartnerRegisterSubState();
}

class _PartnerRegisterSubState extends State<PartnerRegisterSub> {
  final Geolocator geolocator = Geolocator();

  var _currencies = [
    "Seeds",
    "Inputs",
    "Mechaniation",
    "Logistics",
    "Labour",
    "Other"
  ];

  Position _currentPosition;

  TextEditingController _stateController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _talukaController = TextEditingController();
  TextEditingController _villageController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _turnoverController = TextEditingController();

  String _currentSelectedValue;

  @override
  Widget build(BuildContext context) {
    final database =
        Provider.of<PartnerUploadKycService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate("register")?? Const.register,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: database.getPartner(uid: widget.uid),
                builder: (context, snapshot) {

                  _stateController.text = snapshot.data["state"];
                  _districtController.text = snapshot.data["district"];
                  _cityController.text = snapshot.data["city"];
                  _talukaController.text = snapshot.data["taluka"];
                  _villageController.text = snapshot.data["village"];
                  if (snapshot.data["turnover"] != null) {
                    _turnoverController.text =
                        snapshot.data["turnover"].toString();
                  }

                  if (snapshot.data["latitude"] != null) {
                    _latitudeController.text =
                        snapshot.data["latitude"].toString();
                  }
                  if (snapshot.data["longitude"] != null) {
                    _longitudeController.text =
                        snapshot.data["longitude"].toString();
                  }

                  return ListView(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          geolocator
                              .getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.best)
                              .then((Position position) async {
                            setState(() {
                              _currentPosition = position;
                            });

                            List<Placemark> p =
                            await geolocator.placemarkFromCoordinates(
                                _currentPosition.latitude,
                                _currentPosition.longitude);

                            print(p[0].toJson());

                            setState(() {
                              _stateController.text = p[0].administrativeArea;
                              _districtController.text =
                                  p[0].subAdministrativeArea;
                              _cityController.text = p[0].locality;
                              _latitudeController.text =
                                  p[0].position.latitude.toString();
                              _longitudeController.text =
                                  p[0].position.longitude.toString();
                              _talukaController.text = p[0].subLocality;
                              _villageController.text =p[0].thoroughfare;
                            });
                          }).catchError((e) {
                            print(e);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black38, width: 1),
                                  left: BorderSide(
                                      color: Colors.black38, width: 1),
                                  top: BorderSide(
                                      color: Colors.black38, width: 1),
                                  right: BorderSide(
                                      color: Colors.black38, width: 1))),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.my_location),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalizations.of(context).translate("selectLocation")?? Const.selectLocation,
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Flexible(
                                  child: new TextField(
                                    controller: _latitudeController,
                                    decoration:
                                        InputDecoration(labelText: AppLocalizations.of(context).translate("latitude")?? Const.latitude),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: new TextField(
                                    controller: _longitudeController,
                                    decoration:
                                        InputDecoration(labelText: AppLocalizations.of(context).translate("Longitude")?? Const.Longitude),
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              decoration: InputDecoration(labelText:AppLocalizations.of(context).translate("state")?? Const.state),
                              controller: _stateController,
                            ),
                            TextField(
                              controller: _districtController,
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context).translate("district")?? Const.district),
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("city")?? Const.city),
                              controller: _cityController,
                            ),
                            TextField(
                              controller: _talukaController,
                              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("taluka")?? Const.taluka),
                            ),
                            TextField(
                              controller: _villageController,
                              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("village")?? Const.village),
                            ),
                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration:
                                      InputDecoration(labelText: AppLocalizations.of(context).translate("cetagory")?? Const.cetagory),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: snapshot.data["category"]!= null ?snapshot.data["category"]: _currentSelectedValue,
                                      isDense: true,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _currentSelectedValue = newValue;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: _currencies.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            TextField(
                              controller: _turnoverController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context).translate("turnOver")?? Const.turnOver),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 50,
                      child: RaisedButton(
                        onPressed: () {
                          resetText();
                        },
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
                        onPressed: () {
                          if (_latitudeController.text == '') {
                            Fluttertoast.showToast(
                                msg:  AppLocalizations.of(context).translate("latitudeError")?? Const.latitudeError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_longitudeController.text == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("longitudeError")?? Const.longitudeError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_stateController.text == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("stateError")?? Const.stateError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_districtController.text == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("districtError")?? Const.districtError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_cityController.text == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("cityError")?? Const.cityError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_talukaController.text == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("talukaError")?? Const.talukaError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_villageController.text == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("villageError")?? Const.villageError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_currentSelectedValue == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("categoryError")?? Const.categoryError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_turnoverController.text == '') {
                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("turnOverError")?? Const.turnOverError,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);
                          } else {
                            PartnerSubRegisterService.updatePartner(
                                double.parse(_latitudeController.text),
                                double.parse(_longitudeController.text),
                                _stateController.text,
                                _districtController.text,
                                _cityController.text,
                                _talukaController.text,
                                _villageController.text,
                                widget.uid,
                                _currentSelectedValue,
                                _turnoverController.text);

                            Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate("update")?? Const.update,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PartnerKycUpload(fid: widget.uid)),
                            );
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context).translate("saveContinue")?? Const.saveContinue,
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(ColorAsset.acentColor),
                      ))),
            ],
          )
        ],
      ),
    );
  }

  resetText() {
    setState(() {
      _latitudeController.clear();
      _longitudeController.clear();
      _stateController.clear();
      _cityController.clear();
      _districtController.clear();
      _talukaController.clear();
      _villageController.clear();
    });
  }
}
