# HireMe: Connecting People to Opportunities
![](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/Mockup.png)

**HireMe** is a mobile application that bridges the gap between underprivileged workers and the IT world, empowering them with more job opportunities. It also simplifies hiring for users by offering a wide range of services in one app.



## 🛠️ **Tech Stack**
- **Frontend**: Flutter
- **Backend**: Node.js, Express.js
- **Database**: MongoDB Atlas

---

## 🗃️ **Backend** :

[Backend Here](https://github.com/Onnesok/hireme_api)

## Demo

| Home (Dark) | Home (light) | Profile page |Login page |Help Page|Booking|Admin privilege|
|------------|-----------------|--------------------|--------------------|--------------------|--------------------|--------------------|
|![Home](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/1.jpg) | ![Home](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/19.jpg) | ![profile](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/5.jpg) | ![Login](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/16.jpg) | ![Help](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/21.jpg) | ![Help](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/6.jpg) | ![Admin](https://github.com/Onnesok/hire_me/blob/main/assets/mockups/13.jpg) 

## File structure

```tree
lib/
├── cart_page.dart 
├── help_page.dart
├── home.dart
├── main.dart
├── profile_page.dart
├── search_page.dart
│
├── api/
│   └── api_root.dart
│
├── controller/
│   ├── banner_controller.dart
│   ├── login_controller.dart
│   ├── map_page_controller.dart
│   ├── notification_page_controller.dart
│   └── registration_controller.dart
│
├── model/
│   ├── banner_model.dart
│   ├── login_model.dart
│   ├── map_page_model.dart
│   ├── notification_page_model.dart
│   └── registration_model.dart
│
├── service/
│   ├── local_notification.dart
│   ├── login_api_service.dart
│   ├── profile_provider.dart
│   └── themeprovider.dart
│
├── theme/
│   └── app_theme.dart
│
├── view/
│   ├── banner_list_view.dart
│   ├── login_view.dart
│   ├── map_page_view.dart
│   ├── notification_page_view.dart
│   └── registration_view.dart
│
└── widgets/
    ├── appbar_home_widget.dart
    ├── bottom_appbar.dart
    ├── custom_input_field.dart
    └── home_ItemGridView_widget.dart

```

For updated file structure use ``gitingest``

## 🚀 **How to Get Started**
**Clone the Repository**
   ```bash
   git clone https://github.com/your-repo/hireme.git
   cd hireme
   ```