import 'package:flutter/material.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  // Form key to manage form state
  final _formKey = GlobalKey<FormState>();

  // Controllers for form inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddEmployeeDialog,
          ),
        ],
      ),
      body: Center(child: Text('Employee List will be displayed here')),
    );
  }

  // Show the add employee dialog when button is pressed
  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Employee'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _positionController,
                    decoration: InputDecoration(labelText: 'Position'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a position';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Placeholder function for form submission
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, show a success message (currently just a placeholder)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Employee added (form submission is void for now)')),
      );

      // Clear the form fields after submission
      _nameController.clear();
      _positionController.clear();
      _emailController.clear();

      // Close the dialog
      Navigator.pop(context);
    }
  }
}
