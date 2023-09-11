import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:woyaa/api/api.dart';
import 'package:woyaa/api/mock_data.dart';

void setupMock() {
  final dioAdapter = DioAdapter(
      dio: apiHttpClient, matcher: const UrlRequestMatcher(matchMethod: true));

  dioAdapter.onPost("/api/v1/login/email", (server) {
    print("email");
    server.reply(200, {"access_token": "mock_token"});
  });

  dioAdapter.onGet("/api/v1/user/me", (server) {
    print("me");
    server.reply(200, {"me": YoannUserJson});
  });

  dioAdapter.onGet("/api/v1/user", (server) {
    print("user");
    server.reply(200, {"user": KevinUserJson});
  });

  dioAdapter.onGet("/api/v1/user/swipable", (server) {
    print("swipable");
    server.reply(200, SwipableJson);
  });

  dioAdapter.onPost("/api/v1/user/swipe", (server) {
    print("swipe");
    server.reply(200, SwipeResultJson);
  });

  dioAdapter.onGet("/api/v1/table", (server) {
    print("table");
    server.reply(200, TableResultJson);
  });

  dioAdapter.onGet("/api/v1/questions", (server) {
    print("questions");
    server.reply(200, QuestionsResultJson);
  });
}
