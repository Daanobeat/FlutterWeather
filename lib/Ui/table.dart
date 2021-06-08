import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Table(
            children: [
              TableRow(children:[
                Column(children: [SizedBox(width:150,child: Text(tableDescription,textAlign: TextAlign.left,))]),
                // Column(children: [Text(tableDescription,textAlign: TextAlign.left)]),
                Column(children: [SizedBox(width:double.infinity,child: Text(tableValue))]),
              ],
              ),
            ]
        ));
  }
  String tableDescription;
  String tableValue;
  TableDetail(this.tableDescription,this.tableValue);
}