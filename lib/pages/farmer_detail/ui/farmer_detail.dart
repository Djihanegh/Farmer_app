import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goldfarm/models/loan_model.dart';
import 'package:goldfarm/pages/farmer_detail/service/farmerdetail_service.dart';
import 'package:goldfarm/pages/farmer_upload_kyc/service/upload_kyc_service.dart';
import 'package:goldfarm/pages/homepage/ui/homepage.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/loading.dart';
import 'package:goldfarm/utils/localization/localizations.dart';
import 'package:goldfarm/utils/prefrence.dart';
import 'package:goldfarm/utils/sliderout.dart';
import 'package:provider/provider.dart';
import 'package:goldfarm/pages/farmer_detail/provider/farmer_detail_provider.dart';

class FarmerDetail extends StatefulWidget {
  final String uid;

  const FarmerDetail({Key key, this.uid}) : super(key: key);

  @override
  _FarmerDetailState createState() => _FarmerDetailState();
}

class _FarmerDetailState extends State<FarmerDetail> {
  List<String> crops = [];

  String city, mobile, name, farmer_uid, acer, agent_uid, crop;
  int creditLimit, gf_code;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<UploadKycService>(context, listen: false);
    final farmerDetailDatabase =
        Provider.of<FarmerDetailService>(context, listen: false);
    var provider = Provider.of<FarmerDetailProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(ColorAsset.acentColor),
        title: Text(
          AppLocalizations.of(context).translate("farmerDetail")?? Const.farmerDetail,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
          stream: database.getFarmer(uid: widget.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(child: Center(child: LoadingInDicator()));
            } else if (snapshot.connectionState == ConnectionState.active) {
              city = snapshot.data["city"];
              mobile = snapshot.data["mobile"];
              farmer_uid = snapshot.data["farmer_uid"];
              name = snapshot.data["name"];
              gf_code = snapshot.data["gf_code"];

              return Column(children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        color: Color(ColorAsset.acentColor),
                        height: 230,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: new BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: new DecorationImage(
                                        image: new NetworkImage(
                                            snapshot.data["profile"]),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(50.0)),
                                      border: new Border.all(
                                        color: Colors.white,
                                        width: 4.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data["name"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Mobile: ${snapshot.data["mobile"]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "GF Code: ${snapshot.data["gf_code"]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "City: ${snapshot.data["city"]}",
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              child: Card(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DropdownButton<String>(
                                      items: crops.map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        provider.setCropValue(value);
//                                        Firestore.instance.collection('Crops').document(value).get().then((value){
//                                          numberOfAcers.clear();
//                                          for(String j in value.data.keys){
//                                            setState(() {
//                                              numberOfAcers.add(j);
//                                            });
//                                          }
//
//                                        });
                                      },
                                      value: provider.cropValue,
                                      underline: Container(),
                                      hint: Text(
                                        "Select Crops",
                                        style: TextStyle(color: Colors.black87),
                                        textAlign: TextAlign.center,
                                      ),
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Card(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DropdownButton<String>(
                                      items: Const.numberOfAcers.map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        provider.setAcers(value);
                                      },
                                      value: provider.acerValue,
                                      underline: Container(),
                                      hint: Text(
                                        "Select Acers",
                                        style: TextStyle(color: Colors.black87),
                                        textAlign: TextAlign.center,
                                      ),
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder(
                        stream: farmerDetailDatabase.getCropAndAcers(
                            cropname: provider.cropValue),
                        builder: (context, snapshot) {
                          try {
                            creditLimit = provider.acerValue != null
                                ? snapshot.data[provider.acerValue]
                                : 0;
                          } catch (e) {
                            print(e);
                          }
                          return Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Card(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                        child: Text(
                                      "₹ ${provider.acerValue != null ? snapshot.data[provider.acerValue] : "${0}"}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(ColorAsset.acentColor)),
                                    )),
                                  ),
                                ))
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            height: 50,
                            child: RaisedButton(
                              onPressed: () {
                                provider.setAcers(null);
                                provider.setCropValue(null);
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
                              onPressed: () async {
                                agent_uid = await PrefManager.getUserId();
                                if (provider.acerValue == null &&
                                    provider.cropValue == null) {
                                  Fluttertoast.showToast(
                                      msg: "Select Crop And Acers",
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_LONG);
                                } else {
                                  farmerDetailDatabase
                                      .generateLoan(Loan(
                                          acer: provider.acerValue,
                                          city: city,
                                          mobile: mobile,
                                          timestamp:
                                              FieldValue.serverTimestamp(),
                                          name: name,
                                          farmer_uid: farmer_uid,
                                          gf_code: gf_code,
                                          agent_uid: agent_uid,
                                          credit_limit: creditLimit,
                                          crop: provider.cropValue))
                                      .whenComplete(() {
                                    provider.setAcers(null);
                                    provider.setCropValue(null);

                                    Fluttertoast.showToast(
                                        msg: "Loan Generated",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM);

                                    Navigator.of(context).pop();
                                  });
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
              ]);
            } else {
              return Container(
                child: Center(
                  child: Text(AppLocalizations.of(context).translate("error")?? Const.error),
                ),
              );
            }
          }),
    );
  }

  void getData() {
    Firestore.instance.collection('Crops').getDocuments().then((value) {
      for (int i = 0; i <= value.documents.length; i++) {
        setState(() {
          crops.add(value.documents[i].documentID);
        });
      }
    });
  }

}
