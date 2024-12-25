import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart'; // Assuming this is where CustomInputField is defined

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  // List of gender options
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  // Selected gender
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add Admin Button with text on the button itself
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _showAddAdminDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Admin',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(child: Text('Admin List will be displayed here')),
          ],
        ),
      ),
    );
  }

  // Show Add Admin Dialog with Form
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
                  // Name Input Field using CustomInputField
                  CustomInputField(
                    controller: _nameController,
                    hintText: 'Name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Address Input Field using CustomInputField
                  CustomInputField(
                    controller: _addressController,
                    hintText: 'Address',
                    icon: Icons.location_on,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Phone Input Field using CustomInputField
                  CustomInputField(
                    controller: _phoneController,
                    hintText: 'Phone',
                    icon: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // NID Input Field using CustomInputField
                  CustomInputField(
                    controller: _nidController,
                    hintText: 'NID',
                    icon: Icons.credit_card,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an NID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Role Input Field using CustomInputField
                  CustomInputField(
                    controller: _roleController,
                    hintText: 'Role',
                    icon: Icons.work,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a role';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Gender Dropdown
                  // Gender Dropdown
                  const Text('Gender:'),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    hint: const Text(
                      'Select Gender',
                      style: TextStyle(color: Colors.grey),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700] // Darker background for the dropdown in dark theme
                          : Colors.white,  // White background for light theme
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[500]! // Lighter border for dark theme
                              : Colors.grey[300]!, // Lighter border for light theme
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white // Text color for dark theme
                          : Colors.black, // Text color for light theme
                    ),
                    items: genderOptions.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Submit Button with text on the button itself
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Submit form method
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulate a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin added successfully')),
      );

      // Clear form inputs after submission
      _nameController.clear();
      _addressController.clear();
      _phoneController.clear();
      _nidController.clear();
      _roleController.clear();
      setState(() {
        selectedGender = null;
      });

      Navigator.pop(context); // Close the dialog
    }
  }
}
