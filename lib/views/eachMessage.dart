import 'package:flutter/material.dart';
import 'package:go_home/components/InspectionView.dart';

class EachMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Container(
                color: Colors.red,
                child: Column(),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.grey,
                child: Column(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
