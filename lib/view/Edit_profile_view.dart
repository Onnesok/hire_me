import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/controller/edit_profile_controller.dart';
import 'package:hire_me/widgets/custom_input_field.dart';
import 'package:hire_me/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../model/Edit_profile_model.dart';
import '../service/profile_provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late EditProfileController _controller;
  UserModel? _user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = EditProfileController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _fetchUserData(profileProvider.email);
  }

  Future<void> _fetchUserData(String email) async {
    final user = await _controller.fetchUserData(email);
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phoneNumber;
        _addressController.text = user.address;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateUserData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    if (_user == null) return;

    final updatedUser = UserModel(
      username: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      role: _user!.role,
      profilePicture: _user!.profilePicture,
    );

    final success = await _controller.updateUserData(updatedUser, profileProvider);
    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
        body: const Center(child: Text("Failed to load user data")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/ui/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
            
                const SizedBox(height: 30),
            
                CircleAvatar(radius: 50, backgroundImage: NetworkImage(_user!.profilePicture)),

                SizedBox(height: 10,),

                Text("Name: ${_user?.username}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1, fontStyle: FontStyle.italic),),
                SizedBox(height: 15,),
            
                Divider(),
            
                Center(child: Text("${_user!.role} account", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            
                Divider(),
            
                const SizedBox(height: 10),
            
                CustomInputField(
                  controller: _nameController,
                  hintText: "Enter your name",
                  icon: Icons.person_outline,
                  validator: (value) => value?.isEmpty == true ? "Please enter your name" : null,
                ),
            
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(_emailController.text),
                ),
            
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:Row(
                    children: [
                      Icon(Icons.warning_amber, size: 12,color: Colors.red,),
                      SizedBox(width: 10,),
                      Text("Email can't be edited", style: TextStyle(fontSize: 12, letterSpacing: 2),),
                    ],
                  ),
                ),
            
                CustomInputField(
                  controller: _phoneController,
                  isNumeric: true,
                  hintText: "Enter your phone number",
                  icon: Icons.phone_outlined,
                  validator: (value) => value?.isEmpty == true ? "Please enter your phone number" : null,
                ),
            
                CustomInputField(
                  controller: _addressController,
                  hintText: "Enter your address",
                  icon: Icons.home_outlined,
                  validator: (value) => value?.isEmpty == true ? "Please enter your address" : null,
                ),
            
                const SizedBox(height: 20),
            
                AppTheme.gradientButton(
                  text: "Update",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateUserData();
                    } else {
                      Fluttertoast.showToast(msg: "Please fill in all required fields");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
