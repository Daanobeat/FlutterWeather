import 'package:intl/intl.dart';

extension MilliSeconds on num {
  String parseSecondsToDate() {
    return (DateFormat('d.M.y').format((DateTime.fromMillisecondsSinceEpoch((this*1000)))));
  }
  String parseSecondsToTime() {
    return (DateFormat.Hm().format((DateTime.fromMillisecondsSinceEpoch((this*1000)))));
  }
  String addUnit(){
    return this.toString() + "°C";
  }
  String addPercent(){
    return this.toString() + "%";
  }
}