import 'dart:convert';

UpdateUserModel updateUserModelFromJson(String str) =>
    UpdateUserModel.fromJson(json.decode(str));

String updateUserModelToJson(UpdateUserModel data) =>
    json.encode(data.toJson());

class UpdateUserModel {
  UpdateUserModel({
    required this.message,
   // required this.emailVerification,
    required this.status,
    required this.validity,
  });

  final String message;
 // final String emailVerification;
  final int status;
  final bool validity;

  factory UpdateUserModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserModel(
        message: json["message"],
       // emailVerification: json["email_verification"],
        status: json["status"],
        validity: json["validity"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    //"email_verification": emailVerification,
    "status": status,
    "validity": validity,
  };
}
