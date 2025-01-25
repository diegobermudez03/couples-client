import 'package:couples_client_app/core/utils/functions.dart';
import 'package:couples_client_app/core/utils/interfaces.dart';

class UserModel implements JSONble{
  final String firstName;
  final String lastName;
  final Gender gender;
  final String countryCode;
  final String languageCode;
  final DateTime birthDate;

  UserModel(this.firstName, this.lastName, this.gender, this.countryCode, this.languageCode, this.birthDate);
  
  @override
  Map<String, dynamic> toJSON() {
    return {
      "firstName" : firstName,
      "lastName"  : lastName,
      "gender" : gender == Gender.male ? 'male' : 'female',
      "birthDate" : dateToUnix(birthDate),
      "countryCode" : countryCode,
      "languageCode" : languageCode,
    };
  }
}


enum Gender{
  male, female
}