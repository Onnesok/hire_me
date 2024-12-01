import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// TODO: kisui lagbe na.... just template... ja lagbe fix and add those
class ProfileProvider with ChangeNotifier {
  String _accessToken = '';
  String _refreshToken = '';
  bool _isLoggedIn = false;
  File? _pickedImage;
  String _fullName = 'Mr Anonymous';
  String _email = 'Email not loaded';
  String? _studentId;
  String? _position;
  String? _department;
  String? _avatarUrl;
  String? _bloodGroup;
  String? _gender;
  String? _org;
  String? _dateOfBirth;
  String? _secondaryEmail;
  String? _facebookProfile;
  String? _linkedinLink;
  String? _instaLink;     // used for github link in backend
  bool _isVerified = false;
  bool _isAdmin = false;
  String? _bracuStart;
  String? _rsStatus;
  String? _phoneNumber;
  String? _address;

  // Getters for profile fields
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  bool get isLoggedIn => _isLoggedIn;
  File? get pickedImage => _pickedImage;
  String get fullName => _fullName;
  String get email => _email;
  String? get studentId => _studentId;
  String? get position => _position;
  String? get department => _department;
  String? get avatarUrl => _avatarUrl;
  String? get bloodGroup => _bloodGroup;
  String? get gender => _gender;
  String? get org => _org;
  String? get dateOfBirth => _dateOfBirth;
  String? get secondaryEmail => _secondaryEmail;
  String? get facebookProfile => _facebookProfile;
  String? get linkedinLink => _linkedinLink;
  String? get bracuStart => _bracuStart;
  String? get rsStatus => _rsStatus;
  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  bool get isVerified => _isVerified;
  bool get isAdmin => _isAdmin;
  String? get instaLink => _instaLink;

  // Constructor: Load profile data when provider is initialized
  ProfileProvider() {
    _loadProfile();
  }

  /// Load profile data from SharedPreferences
  Future<void> _loadProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileData = prefs.getString('profile_data');

      if (profileData != null) {
        final Map<String, dynamic> data = jsonDecode(profileData);

        // Load the profile data
        _refreshToken = prefs.getString('refresh_token') ?? '';
        _accessToken = prefs.getString('access_token') ?? '';
        _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        _fullName = data['name'] ?? 'Mr Anonymous';
        _email = data['email'] ?? 'Email not loaded';
        _studentId = data['student_id'];
        _position = data['position'];
        _department = data['department'];
        _avatarUrl = data['avatar'];
        _bloodGroup = data['blood_group'];
        _gender = data['gender'];
        _org = data['org'];
        _dateOfBirth = data['date_of_birth'];
        _secondaryEmail = data['secondary_email'];
        _facebookProfile = data['facebook_profile'];
        _linkedinLink = data['linkedin_link'];
        _bracuStart = data['bracu_start'];
        _rsStatus = data['rs_status'];
        _phoneNumber = data['phone_number'];
        _address = data['address'];
        _isVerified = data['is_verified'] ?? false;
        _isAdmin = data['is_admin'] ?? false;
        _instaLink = data['insta_link'];

        // Load profile image if path exists and file is valid
        final String? imagePath = prefs.getString('profile_image');
        if (imagePath != null && File(imagePath).existsSync()) {
          _pickedImage = File(imagePath);
        } else {
          _pickedImage = null;
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }


  // Logout clear things
  // Updated clear to reset all fields
  Future<void> clear() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear all sensitive data from SharedPreferences
      await prefs.remove('profile_data');
      await prefs.remove('profile_image');
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('isLoggedIn');
      await prefs.remove('email');
      await prefs.remove('name');

      // Reset the local variables to their initial state
      _accessToken = '';
      _refreshToken = '';
      _isLoggedIn = false;
      _pickedImage = null;
      _fullName = 'Mr Anonymous';
      _email = 'Email not loaded';
      _studentId = null;
      _position = null;
      _department = null;
      _avatarUrl = null;
      _bloodGroup = null;
      _gender = null;
      _org = null;
      _dateOfBirth = null;
      _secondaryEmail = null;
      _facebookProfile = null;
      _linkedinLink = null;
      _bracuStart = null;
      _rsStatus = null;
      _phoneNumber = null;
      _address = null;
      _isVerified = false;
      _isAdmin = false;
      _instaLink = null;

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }


  Future<void> updateLoginStatus(bool status) async {
    _isLoggedIn = status;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', status);
    notifyListeners();
  }
  Future<void> _loadLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Load the saved login status
    notifyListeners();
  }


  Future<void> storeAccessToken(String token) async {
    _accessToken = token;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', token);
  }

  Future<void> storeRefreshToken(String token) async {
    _refreshToken = token;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('refresh_token', token);
  }

  /// Save complete profile data to SharedPreferences
  Future<void> saveProfileData(Map<String, dynamic> data) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_data', jsonEncode(data));

      _fullName = data['name'] ?? 'Mr Anonymous';
      _email = data['email'] ?? 'Email not loaded';
      _studentId = data['student_id'];
      _position = data['position'];
      _department = data['department'];
      _avatarUrl = data['avatar'];
      _bloodGroup = data['blood_group'];
      _gender = data['gender'];
      _org = data['org'];
      _dateOfBirth = data['date_of_birth'];
      _secondaryEmail = data['secondary_email'];
      _facebookProfile = data['facebook_profile'];
      _linkedinLink = data['linkedin_link'];
      _bracuStart = data['bracu_start'];
      _rsStatus = data['rs_status'];
      _phoneNumber = data['phone_number'];
      _address = data['address'];
      _isVerified = data['is_verified'] ?? false;
      _isAdmin = data['is_admin'] ?? false;
      _instaLink = data['insta_link'];

      notifyListeners();
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }

  /// Update profile image and persist to SharedPreferences
  Future<void> updateImage(File? newImage) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (newImage != null) {
        await prefs.setString('profile_image', newImage.path);
        _pickedImage = newImage;
      } else {
        await prefs.remove('profile_image');
        _pickedImage = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error updating image: $e');
    }
  }

  /// Update user's email and save it persistently
  Future<void> storeEmail(String email) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      _email = email;
      notifyListeners();
    } catch (e) {
      print('Error updating email: $e');
    }
  }

  /// Update user's full name and save it persistently
  Future<void> updateName(String name) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      _fullName = name;
      notifyListeners();
    } catch (e) {
      print('Error updating name: $e');
    }
  }

  Future<void> updateUserProfile(String name, String email) async {
    _fullName = name;
    _email = email;
    notifyListeners();
  }
}