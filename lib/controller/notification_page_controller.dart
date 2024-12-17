import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/notification_page_model.dart';

class NotificationController {
  Future<List<NotificationModel>> fetchNotifications() async {
    await dotenv.load(fileName: ".env");
    String? appId = dotenv.env['ONESIGNAL_APP_ID'];
    String? apiKey = dotenv.env['API_KEY'];

    if (appId != null) {
      var url = Uri.parse('https://onesignal.com/api/v1/notifications?app_id=$appId');

      var response = await http.get(
        url,
        headers: {'Authorization': 'Basic $apiKey'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> notificationsJson = data['notifications'];

        return notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } else {
      throw Exception('ONESIGNAL_APP_ID not found in .env');
    }
  }
}
