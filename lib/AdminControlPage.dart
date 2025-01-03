import 'package:flutter/material.dart';
import 'employee_page.dart';
import 'admin_page.dart';
import 'customer_page.dart';

class AdminControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Admin Control'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Users',
              style: Theme.of(context).textTheme.headlineSmall,  // Updated
            ),
            const SizedBox(height: 20),
            _buildControlOption(
              context,
              title: 'Employee',
              description: 'Manage employee details',
              onTap: () {
                // Navigate to employee list page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeePage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildControlOption(
              context,
              title: 'Admin',
              description: 'Manage admin details',
              onTap: () {
                // Navigate to admin list page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildControlOption(
              context,
              title: 'Customer',
              description: 'Manage customer details',
              onTap: () {
                // Navigate-->customerList page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlOption(BuildContext context,
      {required String title,
        required String description,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.group, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),  // Updated
                  const SizedBox(height: 4),
                  Text(description, style: Theme.of(context).textTheme.bodyMedium),  // Updated
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
