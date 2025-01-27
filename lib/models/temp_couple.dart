import 'package:couples_client_app/core/utils/functions.dart';

class TempCouple {
  final String code;
  final DateTime startDate;

  TempCouple(this.code, this.startDate);

  factory TempCouple.fromJson(Map<String, dynamic> json){
    return TempCouple(
      (json["code"] as int).toString(), 
      unixToDate(json["startDate"])
    );
  }
}