import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hire_me/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:hire_me/service/themeprovider.dart';

class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    await dotenv.load(fileName: ".env");
    String? appId = dotenv.env['ONESIGNAL_APP_ID'];
    String? apiKey = dotenv.env['API_KEY'];
    if (appId != null) {
      var url = Uri.parse('https://onesignal.com/api/v1/notifications?app_id=$appId');

      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Basic $apiKey',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          notifications = data['notifications'];
        });
      } else if (response.statusCode == 403) {
        print('Forbidden: Please check your API key and permissions.');
      } else {
        print('Failed to fetch notifications: ${response.statusCode}');
      }
    } else {
      throw Exception('ONESIGNAL_APP_ID not found in .env');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: notifications.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          var notification = notifications[index];

          // Debugging: Print the notification structure to check keys
          print(notification);

          // Extract data (using headings.en for title)
          String heading = notification['headings']?['en'] ?? 'No Title';
          String content = notification['contents']?['en'] ?? 'No Content';
          String imageUrl = notification['global_image'] ?? '';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            child: ListTile(
              leading: imageUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Icons.notifications,
                color: isDarkMode ? Colors.white : Colors.blue,
              ),
              title: Text(
                heading,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              contentPadding: EdgeInsets.all(16),
              onTap: () {
                // Handle notification tap
                print('Notification tapped: $heading');
              },
            ),
          );
        },
      ),
    );
  }
}
