import 'package:flutter/material.dart';
import 'package:goldfarm/utils/const.dart';
import 'package:goldfarm/utils/localization/localizations.dart';

class NoDataFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.system_update_alt,color: Colors.green,),
            Text(AppLocalizations.of(context).translate("opps")?? Const.opps,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87),),
            Text(AppLocalizations.of(context).translate("noDataFound")?? Const.noDataFound,style: TextStyle(fontSize: 14,),),
          ],
        ),
      ),
    );
  }
}
