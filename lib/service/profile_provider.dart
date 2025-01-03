import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  String _id = '';
  String _username = '';
  String _email = '';
  String? _phoneNumber;
  String? _profilePicture;
  String? _address;
  String? _role;
  String? _createdAt;
  String? _updatedAt;

  bool _isLoggedIn = false;

  // Getters
  String get id => _id;
  String get username => _username;
  String get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get profilePicture => _profilePicture;
  String? get address => _address;
  String? get role => _role;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  bool get isLoggedIn => _isLoggedIn;

  // Constructor to initialize and load profile
  ProfileProvider() {
    _loadProfile();
  }

  /// Load profile data from SharedPreferences
  Future<void> _loadProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileData = prefs.getString('profile_data');

      // If profile data exists, load it
      if (profileData != null) {
        final Map<String, dynamic> data = jsonDecode(profileData);

        _id = data['_id'] ?? '';
        _username = data['username'] ?? '';
        _email = data['email'] ?? '';
        _phoneNumber = data['phone_number'];
        _profilePicture = data['profile_picture'];
        _address = data['address'];
        _role = data['role'];
        _createdAt = data['createdAt'];
        _updatedAt = data['updatedAt'];

        // Load login status
        _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  /// Save profile data to SharedPreferences
  Future<void> saveProfileData(
      String username,
      String email,
      String phoneNumber,
      String? profilePicture,
      String? address,
      String? role,
      ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Create the profile data map
      final Map<String, dynamic> data = {
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'profile_picture': profilePicture,
        'address': address,
        'role': role,
      };

      // Save profile data as a JSON string
      await prefs.setString('profile_data', jsonEncode(data));

      // Save the individual values locally
      _id = '';
      _username = username;
      _email = email;
      _phoneNumber = phoneNumber;
      _profilePicture = profilePicture;
      _address = address;
      _role = role;
      _createdAt = null;
      _updatedAt = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving profile data: $e');
    }
  }


  /// Save login status
  Future<void> updateLoginStatus(bool status) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _isLoggedIn = status;
      await prefs.setBool('isLoggedIn', status);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating login status: $e');
    }
  }

  /// Clear profile and authentication data
  Future<void> clearProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.remove('profile_data');
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('isLoggedIn');

      _id = '';
      _username = '';
      _email = '';
      _phoneNumber = null;
      _profilePicture = null;
      _address = null;
      _role = null;
      _createdAt = null;
      _updatedAt = null;

      _isLoggedIn = false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing profile: $e');
    }
  }

  /// Update user profile picture
  Future<void> updateProfilePicture(String? url) async {
    try {
      _profilePicture = url;
      notifyListeners();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileData = prefs.getString('profile_data');

      if (profileData != null) {
        final Map<String, dynamic> data = jsonDecode(profileData);
        data['profile_picture'] = url;
        await prefs.setString('profile_data', jsonEncode(data));
      }
    } catch (e) {
      debugPrint('Error updating profile picture: $e');
    }
  }

  /// Update user address
  Future<void> updateAddress(String? newAddress) async {
    try {
      _address = newAddress;
      notifyListeners();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? profileData = prefs.getString('profile_data');

      if (profileData != null) {
        final Map<String, dynamic> data = jsonDecode(profileData);
        data['address'] = newAddress;
        await prefs.setString('profile_data', jsonEncode(data));
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
    }
  }
}
