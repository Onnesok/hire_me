import 'package:flutter/material.dart';
import 'package:hire_me/service/themeprovider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Filtering dropdowns variables
  String? selectedService;
  String? selectedArea;
  String? selectedDate;

  List<String> serviceList=[
    'Plumbing',
    'Electrician',
    'Cleaning',
    'Painting',
    'Gardening',
    'Carpentry',
    'Maid Service',
    'Pest Control',
    'AC Repair',
  ];
  List<String> areaList = ['Mohakhali', 'Savar', 'Bashundhara', 'Mirpur', 'Gulshan', 'Banani'];
  List<String> dateList = ['Today', 'Tomorrow', 'Next Week'];

  // show or hide filter_variables
  bool _filtersVisible = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
        child: Column(
          children: [
            Hero(
              tag: 'searchBar',
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Show/Hide Filters Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filtersVisible = !_filtersVisible;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(themeProvider.isDarkMode ? Colors.grey : Colors.blue),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 18,horizontal:24)),
              ),
              child: Text(
                _filtersVisible ? 'Hide Filters' : 'Show Filters',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3 filter section---only visible if _filtersVisible is true)
            if (_filtersVisible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Dropdown
                    DropdownButton<String>(
                      value: selectedService,
                      hint: Text('Select Service'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedService = newValue;
                        });
                      },
                      items: serviceList.map<DropdownMenuItem<String>>((String service) {
                        return DropdownMenuItem<String>(
                          value: service,
                          child: Text(service),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    // Area Dropdown
                    DropdownButton<String>(
                      value: selectedArea,
                      hint: Text('Select Area'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedArea = newValue;
                        });
                      },
                      items: areaList.map<DropdownMenuItem<String>>((String area) {
                        return DropdownMenuItem<String>(
                          value: area,
                          child: Text(area),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    // Date Dropdown
                    DropdownButton<String>(
                      value: selectedDate,
                      hint: Text('Select Date'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDate = newValue;
                        });
                      },
                      items: dateList.map<DropdownMenuItem<String>>((String date) {
                        return DropdownMenuItem<String>(
                          value: date,
                          child: Text(date),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}