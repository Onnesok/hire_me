import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../widgets/custom_input_field.dart';

//TODO: 377-394,213-220 LINES TEXT FIELD CHANGE TO CUSTOM
class HelpScreen extends StatelessWidget {
  final ScrollController scrollController;
  const HelpScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(  // Wrap the entire content in SingleChildScrollView
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Section
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 78,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: const CircleAvatar(
                      radius: 75,
                      backgroundImage: AssetImage('assets/help_3.jpg'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Text Section
              Text(
                "Tell us how we can help you?",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We are here 24/7 to serve you. Please call us using 12434.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Action Boxes --CHAT
              _buildActionBox(
                context,
                image: 'assets/chat_1.jpg',
                title: "Let's Chat",
                subtitle: "Start conversation",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Action Box--TALK
              _buildActionBox(
                context,
                image: 'assets/help.jpg',
                title: "Let's Talk",
                subtitle: "Talk with our experts!",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TalkPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Action Box- FAQ
              _buildActionBox(
                context,
                image: 'assets/faq_2.jpg',
                title: "Service Request",
                subtitle: "Have a request? Tell us!",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReqPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBox(
      BuildContext context, {
        required String image,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar Image
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(width: 16),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController phoneNumberController;
  late TextEditingController queryController;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    queryController = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String initialCountry = 'BD';
    PhoneNumber number = PhoneNumber(isoCode: initialCountry);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              initialValue: number,
              textFieldController: TextEditingController(),
              inputDecoration: InputDecoration(
                hintText: 'Enter phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: queryController,
                    hintText: 'Write your query here.',
                    icon: Icons.message,
                    isPassword: false,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class TalkPage extends StatelessWidget {
  const TalkPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Talk"),
      ),
      body: const Center(
        child: Icon(Icons.call),
      ),
    );
  }
}

class ReqPage extends StatefulWidget {
  const ReqPage({super.key});

  @override
  _ReqPageState createState() => _ReqPageState();
}

class _ReqPageState extends State<ReqPage> {
  final TextEditingController contactNumberController = TextEditingController();

  // List of service name and areas
  final List<String> serviceNames = ['Plumbing', 'Electrician', 'Cleaning', 'Painting', 'Gardening', 'Carpentry', 'Maid Service', 'Pest Control', 'AC Repair',];
  final List<String> serviceAreas = ['Mohakhali', 'Savar','Bashundhara', 'Mirpur', 'Gulshan', 'Banani',];


  // Selected area
  String? selectedServiceName;
  String? selectedArea;

  void _submitForm() {
    print('Service Name: $selectedServiceName');
    print('Service Area: $selectedArea');
    print('Contact Number: ${contactNumberController.text}');
    Navigator.pop(context); // Navigate back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Request"),
      ),
      body: SingleChildScrollView( // Allows vertical scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for Service Name
              DropdownButtonFormField<String>(
                value: selectedServiceName,
                hint: const Text(
                  'Select Service Name',
                  style: TextStyle(
                    color: Colors
                        .grey, // Static hint color matching other boxes
                  ),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // Ensures the box is white in all themes
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.white, // Matches the other boxes' borders
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black, // Static text color for dark mode readability
                ),
                items: serviceNames.map((serviceName) {
                  return DropdownMenuItem<String>(
                    value: serviceName,
                    child: Text(
                      serviceName,
                      style: const TextStyle(
                        color: Colors.grey, // Ensures text inside dropdown matches
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedServiceName=value;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Dropdown for Service Area
              DropdownButtonFormField<String>(
                value: selectedArea,
                hint: const Text(
                  'Select Service Area',
                  style: TextStyle(
                    color: Colors
                        .grey, // Static hint color matching other boxes
                  ),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // Ensures the box is white in all themes
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors
                          .white, // Matches the Service Name box border
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors
                      .black, // Static text color for dark mode readability
                ),
                items: serviceAreas.map((area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(
                      area,
                      style: const TextStyle(
                        color: Colors.grey, // Ensures text inside dropdown matches
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedArea = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // TextField for Contact Number
              CustomInputField(
                controller: contactNumberController,
                hintText: 'Contact Number',
                icon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your contact number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}