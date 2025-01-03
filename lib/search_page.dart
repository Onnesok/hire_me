import 'package:flutter/material.dart';
import 'package:hire_me/view/service_booking_page2_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hire_me/api/api_root.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedService = 'Plumber'; // Default service
  List<dynamic> availableProviders = [];
  bool isLoading = false;

  // Fetch providers from the API
  Future<void> _fetchProviders() async {
    setState(() {
      isLoading = true;
    });

    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    String apiUrl = "${api_root}/employees/work/free?date=${formattedDate}&role=${_selectedService}";
    print(apiUrl);

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          availableProviders = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch providers. Please try again later.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please check your connection.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Generate a list of dates for the slider
  List<DateTime> _generateDates() {
    DateTime today = DateTime.now();
    return List.generate(30, (index) => today.add(Duration(days: index)));
  }

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    List<DateTime> dateList = _generateDates();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Service Providers'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Service Dropdown
            Text(
              'Select a Service:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedService,
              onChanged: (value) {
                setState(() {
                  _selectedService = value!;
                });
                _fetchProviders();
              },
              items: ['Plumber',
                'Electrician',
                'Cleaner',
                'Painter',
                'Gardener',
                'Carpenter',
                'Maid Service',
                'Pest Control',
                'Ac Repair'] // Add your service list here
                  .map((service) => DropdownMenuItem(
                value: service,
                child: Text(service),
              ))
                  .toList(),
            ),

            // Date Selection
            SizedBox(height: 15),
            Divider(),
            Text(
              'Select a Date:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5),
            ),
            SizedBox(height: 10),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dateList.length,
                itemBuilder: (context, index) {
                  DateTime date = dateList[index];
                  bool isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                      _fetchProviders();
                    },
                    child: Container(
                      width: 60,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.white : Colors.black54,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Display Available Providers
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 6),
            Text(
              'Available Providers:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5),
            ),
            SizedBox(height: 10),

            isLoading
                ? Center(child: CircularProgressIndicator())
                : availableProviders.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/4076/4076549.png',
                    width: 150,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No providers available.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: availableProviders.length,
                itemBuilder: (context, index) {
                  var provider = availableProviders[index];
                  String name = provider['username'] ?? 'Unknown Provider';
                  String role = provider['role'] ?? 'Unknown Role';
                  String phone = provider['phone_number'] ?? 'No Phone Number';
                  String profilePicture = provider['profile_picture'] ?? 'https://via.placeholder.com/150';

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(profilePicture),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('$role\nPhone: $phone'),
                      trailing: Icon(Icons.check_circle, color: Colors.green),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceBookingDetails(
                              selectedDate: formattedDate,
                              employeeDetails: provider,
                              serviceName: _selectedService,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

