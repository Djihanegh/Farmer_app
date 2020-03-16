import 'package:flutter/material.dart';
import 'package:goldfarm/pages/homepage/widgets/mainwidget.dart';

class HomePage extends StatefulWidget {
  final String fireuser;

  const HomePage({Key key, this.fireuser}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainWidget(fireUser: widget.fireuser,context: context),
    );
  }
}
