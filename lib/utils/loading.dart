import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:goldfarm/utils/colors.dart';

class LoadingInDicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: Color(
        ColorAsset.acentColor,
      ),
    );
  }
}
