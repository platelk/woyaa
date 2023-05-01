import 'package:dio/dio.dart';
import 'package:flutter_svg/avd.dart';
import 'package:woyaa/models/question.dart';

import '../models/table.dart';
import '../models/user.dart';

const baseApiURL = "https://anaxyoann.fr";

final apiHttpClient = Dio(); // With default `Options`.

var accessToken = "";

void configureDio() {
  // Set default configs
  apiHttpClient.options.baseUrl = baseApiURL;
  apiHttpClient.options.connectTimeout = const Duration(seconds: 5);
  apiHttpClient.options.receiveTimeout = const Duration(seconds: 3);
}

Future<String> LogIn(String email) async {
  final res =
      await apiHttpClient.post("/api/v1/login/email", data: {'email': email});
  accessToken = res.data["access_token"] as String;

  return accessToken;
}

Future<User> GetMe(String token) async {
  final res = await apiHttpClient.get("/api/v1/user/me",
      options: Options(headers: {"authorization": "Bearer $token"}));

  return User.fromDynamic(res.data["me"]);
}

Future<User> GetUser(String token, int userID) async {
  final res = await apiHttpClient.get("/api/v1/user",
      options: Options(headers: {"authorization": "Bearer $token"}),
      queryParameters: {"id": userID});

  return User.fromDynamic(res.data["user"]);
}

class SwipeList {
  final List<int> toSwipe;
  final List<int> swiped;

  const SwipeList({required this.toSwipe, required this.swiped});
}

Future<SwipeList> GetSwipeList(String token) async {
  final res = await apiHttpClient.get("/api/v1/user/swipable",
      options: Options(headers: {"authorization": "Bearer $token"}));

  return SwipeList(
      toSwipe:
          List.from((res.data["users"] as List<dynamic>).map((e) => e as int)),
      swiped: List.from(
          (res.data["swiped_users"] as List<dynamic>).map((e) => e as int)));
}

class SwipeResult {
  bool foundMyTable = false;
  bool notFoundMyTable = false;
  bool foundNotMyTable = false;
  bool notFoundNotMyTable = false;

  SwipeResult({this.foundMyTable = false, this.notFoundMyTable = false, this.foundNotMyTable = false, this.notFoundNotMyTable = false});
}

Future<SwipeResult> Swipe(String token, int swipedUser, bool swipedRight) async {
  final res = await apiHttpClient.post("/api/v1/user/swipe",
      options: Options(headers: {"authorization": "Bearer $token"}),
      data: {"swiped_user": swipedUser, "swiped_right": swipedRight});

  return SwipeResult(foundMyTable: res.data["found_my_table"], notFoundMyTable: res.data["not_found_my_table"], foundNotMyTable: res.data["found_not_my_table"], notFoundNotMyTable: res.data["not_found_not_my_table"]);
}

Future<Map<String, Table>> GetTables(String token) async {
  final res = await apiHttpClient.get("/api/v1/table",
      options: Options(headers: {"authorization": "Bearer $token"}));

  return {
    for (var t in (res.data["tables"] as List).map(Table.fromDynamic))
      (t).name: t
  };
}

Future<List<Question>> GetAllQuestions(String token) async {
  final res = await apiHttpClient.get("/api/v1/questions",
      options: Options(headers: {"authorization": "Bearer $token"}));

  return [
    for (var t in (res.data["questions"] as List)) Question.fromDynamic(t)
  ];
}

Future<QuestionAnswerResult> AnswerQuestion(String token, int questionID, List<int> userIDs) async {
  final res = await apiHttpClient.post("/api/v1/user/answer",
      options: Options(headers: {"authorization": "Bearer $token"}), data: {"question_id": questionID, "proposed_user_ids": userIDs});

  return QuestionAnswerResult.fromDynamic(res.data);
}
