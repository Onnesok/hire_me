import 'package:flutter/material.dart';
import 'package:hire_me/api/api_root.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final String apiUrl = "${api_root}/admins";
  final String addAdminApiUrl = "${api_root}/register";
  final String deleteAdminApiUrl = "${api_root}/admins";
  final String blockAdminApiUrl = "${api_root}/block"; // Block API

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Added for password
  final TextEditingController _addressController = TextEditingController(); // Added for address
  final TextEditingController _profilePictureController = TextEditingController(); // Added for profile picture

  bool isLoading = true;
  List<dynamic> admins = [];

  @override
  void initState() {
    super.initState();
    fetchAdmins();
  }

  Future<void> fetchAdmins() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          admins = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load admins');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Delete admin function
  Future<void> deleteAdmin(String adminId) async {
    try {
      final response = await http.delete(
        Uri.parse('$deleteAdminApiUrl/$adminId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          admins.removeWhere((admin) => admin['_id'] == adminId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete admin');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Block admin function (similar to delete)
  Future<void> blockAdmin(String adminId) async {
    try {
      // Find the admin using the adminId
      final admin = admins.firstWhere((ad) => ad['_id'] == adminId);
      final email = admin['email'];

      final response = await http.post(
        Uri.parse(blockAdminApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,  // Send email instead of adminId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Remove admin from the list after blocking
        setState(() {
          admins.removeWhere((admin) => admin['_id'] == adminId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin blocked successfully')),
        );
      } else {
        throw Exception('Failed to block admin');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> addAdmin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse(addAdminApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "username": _nameController.text,
            "email": _emailController.text,
            "password": _passwordController.text, // Plain text password
            "phone_number": _phoneController.text,
            "profile_picture": _profilePictureController.text,
            "address": _addressController.text,
            "role": _roleController.text,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin added successfully')),
          );

          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _roleController.clear();
          _passwordController.clear(); // Clear the password field
          _addressController.clear(); // Clear the address field
          _profilePictureController.clear(); // Clear the profile picture field

          Navigator.pop(context);
          fetchAdmins();
        } else {
          throw Exception('Failed to add admin');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showAddAdminDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Admin'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      icon: Icon(Icons.person),
                    ),
                    style: TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email),
                    ),
                    style: TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      icon: Icon(Icons.phone),
                    ),
                    style: TextStyle(color: Colors.black87),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _roleController,
                    decoration: const InputDecoration(
                      hintText: 'Role',
                      icon: Icon(Icons.work),
                    ),
                    style: TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a role';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true, // Make the password field hidden
                    style: TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: 'Address',
                      icon: Icon(Icons.location_on),
                    ),
                    style: TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _profilePictureController,
                    decoration: const InputDecoration(
                      hintText: 'Profile Picture URL',
                      icon: Icon(Icons.image),
                    ),
                    style: TextStyle(color: Colors.black87),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a profile picture URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: addAdmin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Submit', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Management"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddAdminDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Admin', style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : admins.isEmpty
                ? const Center(child: Text("No admins found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: admins.length,
              itemBuilder: (context, index) {
                final admin = admins[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(admin['username'], style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${admin['email']}"),
                        Text("Role: ${admin['role']}"),
                        Text("Phone: ${admin['phone_number']}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteAdmin(admin['_id']),
                        ),
                        IconButton(
                          icon: Icon(Icons.block, color: Colors.orange),
                          onPressed: () => blockAdmin(admin['_id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
