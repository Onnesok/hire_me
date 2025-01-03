import 'package:flutter/material.dart';
import 'package:hire_me/view/service_booking_page2_view.dart';
import 'package:intl/intl.dart';
import '../controller/service_booking_page1_controller.dart';
import '../model/servicce_booking_page1_model.dart';

class ServiceBookingView extends StatefulWidget {
  final String service;

  const ServiceBookingView({required this.service, Key? key}) : super(key: key);

  @override
  _ServiceBookingViewState createState() => _ServiceBookingViewState();
}

class _ServiceBookingViewState extends State<ServiceBookingView> {
  DateTime _selectedDate = DateTime.now();
  List<dynamic> availableProviders = [];
  bool isLoading = false;
  late ServiceBookingController1 _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceBookingController1(ServiceBookingModel1());
    _fetchProviders();
  }

  // Fetch providers from the controller
  Future<void> _fetchProviders() async {
    setState(() {
      isLoading = true;
    });
    var providers = await _controller.fetchProviders(context, widget.service, _selectedDate);
    setState(() {
      availableProviders = providers;
      isLoading = false;
    });
  }

  // Generate a list of dates for the slider
  List<DateTime> _generateDates() {
    DateTime today = DateTime.now();
    return List.generate(30, (index) => today.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    List<DateTime> dateList = _generateDates();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.service} Availability'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/ui/hire.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
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
                              serviceName: widget.service,
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
