import 'package:flutter/material.dart';
import 'package:hire_me/api/api_root.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final String apiUrl = "${api_root}/employees";
  final String addEmployeeApiUrl = "${api_root}/register";
  final String deleteEmployeeApiUrl = "${api_root}/employees";
  final String blockEmployeeApiUrl = "${api_root}/block"; // Block API

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Added for password
  final TextEditingController _addressController = TextEditingController(); // Added for address
  final TextEditingController _profilePictureController = TextEditingController(); // Added for profile picture

  bool isLoading = true;
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          employees = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load employees');
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

  // Delete employee function
  Future<void> deleteEmployee(String employeeId) async {
    try {
      final response = await http.delete(
        Uri.parse('$deleteEmployeeApiUrl/$employeeId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          employees.removeWhere((employee) => employee['_id'] == employeeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Block employee function (similar to delete)
  Future<void> blockEmployee(String employeeId) async {
    try {
      // Find the employee using the employeeId
      final employee = employees.firstWhere((emp) => emp['_id'] == employeeId);
      final email = employee['email'];

      final response = await http.post(
        Uri.parse(blockEmployeeApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,  // Send email instead of employeeId
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print the full response for debugging

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Remove employee from the list after blocking
        setState(() {
          employees.removeWhere((employee) => employee['_id'] == employeeId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee blocked successfully')),
        );
      } else {
        // Throw exception with error details
        throw Exception('Failed to block employee: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> addEmployee() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse(addEmployeeApiUrl),
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
            const SnackBar(content: Text('Employee added successfully')),
          );

          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _roleController.clear();
          _passwordController.clear(); // Clear the password field
          _addressController.clear(); // Clear the address field
          _profilePictureController.clear(); // Clear the profile picture field

          Navigator.pop(context);
          fetchEmployees();
        } else {
          throw Exception('Failed to add employee');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Employee'),
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
                      onPressed: addEmployee,
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
        title: const Text("Employee Management"),
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddEmployeeDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Employee', style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : employees.isEmpty
                ? const Center(child: Text("No employees found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(employee['username'], style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${employee['email']}"),
                        Text("Role: ${employee['role']}"),
                        Text("Phone: ${employee['phone_number']}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteEmployee(employee['_id']),
                        ),
                        IconButton(
                          icon: Icon(Icons.block, color: Colors.orange),
                          onPressed: () => blockEmployee(employee['_id']),
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
