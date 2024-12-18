# HireMe: Connecting People to Opportunities

**HireMe** is a mobile application that bridges the gap between underprivileged workers and the IT world, empowering them with more job opportunities. It also simplifies hiring for users by offering a wide range of services in one app.

---

## 📱 **App Features**

### 1. **Service Categories**
Easily hire skilled professionals for:
- **Housekeeping**
- **Driving**
- **Delivery Services**
- **Caretaking**

### 2. **Flexible Filters**
Find the perfect worker by:
- Selecting the type of service needed.
- Choosing specific dates using an intuitive **Airbnb-style calendar**.
- Sorting workers by ratings and reviews.

### 3. **Profile-Based Booking**
Each worker has a detailed profile with:
- Ratings and reviews from past employers.
- Personal availability calendar to book services instantly.

---

## 🌟 **Our Vision**
HireMe aims to:
- Provide underprivileged individuals with better job opportunities.
- Create a platform that connects skilled workers to the IT ecosystem.
- Make hiring quick and easy for everyone.

---

## 🛠️ **Tech Stack**
- **Frontend**: Flutter
- **Backend**: Node.js, Express.js
- **Database**: MySQL / MongoDB

---

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

## 🚀 **How to Get Started**
**Clone the Repository**
   ```bash
   git clone https://github.com/your-repo/hireme.git
   cd hireme
   ```