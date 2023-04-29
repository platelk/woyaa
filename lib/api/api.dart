import 'package:dio/dio.dart';
import 'package:flutter_svg/avd.dart';

import '../models/user.dart';

const baseApiURL = "http://localhost:8080";

final apiHttpClient = Dio(); // With default `Options`.

var accessToken = "";

void configureDio() {
  // Set default configs
  // apiHttpClient.options.baseUrl = baseApiURL;
  apiHttpClient.options.connectTimeout = const Duration(seconds: 5);
  apiHttpClient.options.receiveTimeout = const Duration(seconds: 3);
}

Future<String> LogIn(String email) async {
  final res = await apiHttpClient.post("/api/v1/login/email", data: {'email': email});
  accessToken = res.data["access_token"] as String;

  return accessToken;
}

Future<User> GetMe(String token) async {
  print("get me");
  final res = await apiHttpClient.get("/api/v1/user/me", options: Options(headers: {"authorization": "Bearer $token"}));

  return User.fromDynamic(res.data["me"]);
}

Future<User> GetUser(String token, int userID) async {
  print("get user $userID");
  final res = await apiHttpClient.get("/api/v1/user", options: Options(headers: {"authorization": "Bearer $token"}), queryParameters: {"id": userID});

  return User.fromDynamic(res.data["user"]);
}

Future<List<int>> GetSwipeList(String token) async {
  print("get swipe");
  final res = await apiHttpClient.get("/api/v1/user/swipable", options: Options(headers: {"authorization": "Bearer $token"}));

  return ((res.data["users"] as List<dynamic>).map((e) =>  e as int)).toList();
}

Future<void> Swipe(String token, int swipedUser, bool swipedRight) async {
  print("swipe user $swipedRight right ? $swipedRight");

  final res = await apiHttpClient.get("/api/v1/user/swipe", options: Options(headers: {"authorization": "Bearer $token"}), data: {"swiped_user": swipedUser, "swiped_right": swipedRight});

  return;
}