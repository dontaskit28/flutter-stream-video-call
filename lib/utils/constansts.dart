import 'package:flutter_stream_video_call/models/user_model.dart';

String get apiKey => "5qy99tygpw6j";
String get getCallId => 'call-testing';

List<CustomUserType> users = [
  CustomUserType(
    name: "User 1",
    role: "admin",
    userId: "user-1",
    userToken:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidXNlci0xIiwiZXhwIjoxNzE5MTE5NDM5LCJpYXQiOjE3MTkxMTU4Mzd9.iYOqo0M7UVsKmm-g8wLwox5TMyC9YGSzsmzd6_nSPRg",
  ),
  CustomUserType(
    name: "User 2",
    role: "admin",
    userId: "user-2",
    userToken:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidXNlci0yIiwiZXhwIjoxNzE5MTE5NDM5LCJpYXQiOjE3MTkxMTU4Mzd9.A9nyqXtKeuxp08_iYQzknCNM_Ku_lHPsRp8iPABKQIQ",
  ),
];
