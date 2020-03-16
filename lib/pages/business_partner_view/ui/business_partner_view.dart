import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goldfarm/pages/partner_register_sub/ui/partner_register_sub.dart';
import 'package:goldfarm/utils/colors.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/loading.dart';
import 'package:goldfarm/pages/nodata_found/nodata_found.dart';
import 'package:goldfarm/utils/localization/localizations.dart';

class BusinessPartnerView extends StatefulWidget {
  final String searchValue;
  final int type;

  const BusinessPartnerView({Key key, this.searchValue, this.type})
      : super(key: key);

  @override
  _BusinessPartnerViewState createState() => _BusinessPartnerViewState();
}

class _BusinessPartnerViewState extends State<BusinessPartnerView> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return StreamBuilder(
      stream: widget.searchValue.isEmpty
          ? Firestore.instance.collection("Business Partner").snapshots()
          : (widget.type == 0)
          ? Firestore.instance
          .collection("Business Partner")
          .where("name", isEqualTo: widget.searchValue)
          .snapshots()
          : (widget.type == 1)
          ? Firestore.instance
          .collection("Business Partner")
          .where("mobile", isEqualTo: widget.searchValue)
          .snapshots()
          : (widget.type == 2)
          ? Firestore.instance
          .collection("Business Partner")
          .where("gf_code",
          isGreaterThanOrEqualTo:
          int.parse(widget.searchValue))
          .snapshots()
          : Firestore.instance
          .collection("Business Partner")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(child: Center(child: LoadingInDicator()));
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.documents.isEmpty) {
            return NoDataFound();
          }else{
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, pos) {
                  var data = snapshot.data.documents;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PartnerRegisterSub(
                                    uid: data[pos].data["partner_uid"])),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: width,
                          child: Card(
                            child: Stack(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'images/logo.png',
                                          image: snapshot
                                              .data.documents[pos].data["profile"],
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50.0),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 10),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.documents[pos]
                                                .data['name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "GF Code: ${snapshot.data.documents[pos]
                                                .data['gf_code']}",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "Mobile: ${snapshot.data.documents[pos]
                                                .data['mobile']}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                snapshot.data.documents[pos].data["detail"] ==
                                    "Sucess"
                                    ? Align(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "images/sucess.png",
                                        width: 15,
                                        height: 15,
                                        color: Color(ColorAsset.acentColor),
                                      ),
                                    ),
                                    alignment: Alignment.topRight)
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
      }else {
        return Container(
        child: Center(
        child: Text(AppLocalizations.of(context).translate("error")?? Const.error),
        ),
        );
        }
      },
    );
  }
}
