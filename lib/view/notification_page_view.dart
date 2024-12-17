import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hire_me/service/themeprovider.dart';
import '../controller/notification_page_controller.dart';
import '../model/notification_page_model.dart';

class NotificationViewPage extends StatefulWidget {
  @override
  _NotificationViewPageState createState() => _NotificationViewPageState();
}

class _NotificationViewPageState extends State<NotificationViewPage> {
  late Future<List<NotificationModel>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    notificationsFuture = NotificationController().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ui/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<NotificationModel>>(
          future: notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No notifications available.'));
            } else {
              List<NotificationModel> notifications = snapshot.data!;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: ListTile(
                      leading: notification.imageUrl.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          notification.imageUrl,
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
                        notification.heading,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        notification.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16),
                      onTap: () {
                        print('Notification tapped: ${notification.heading}');
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
