import 'package:flutter/material.dart';
import 'package:hire_me/help_page.dart';
import 'package:hire_me/service/permissions_page.dart';
import 'package:hire_me/service/themeprovider.dart';
import 'package:hire_me/view/Edit_profile_view.dart';
import 'package:hire_me/view/change_password_view.dart';
import 'package:provider/provider.dart';
import '../AdminControlPage.dart';
import '../controller/profile_page_controller.dart';
import '../service/profile_provider.dart';
import '../widgets/theme_selector.dart';

class ProfilePage extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int) updatePageIndex;

  const ProfilePage({super.key, required this.scrollController, required this.updatePageIndex});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileController = ProfileController(context);

    return Scaffold(
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Blob data is heavy and so not available now")),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          child: CircleAvatar(
                            radius: 57,
                            backgroundImage: NetworkImage(profileProvider.profilePicture ??  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9G6Km-mfLzmKUTF8Xd7iKzaqzJ_kHdiWl7Q&s"),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "${profileProvider.username}",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Role: ${profileProvider.role}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // List of profile options
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),

                _buildSectionTitle("Account", context),

                _buildProfileOption(
                  context,
                  icon: Icons.person_outline,
                  title: "Edit Profile",
                  subtitle: "Update your personal details",
                  onTap: () => profileController.navigateTo(EditProfileView()),
                ),

                _buildProfileOption(
                  context,
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  subtitle: "Update your password for security",
                  onTap: () => profileController.navigateTo(ChangePassword()),
                ),

                const SizedBox(height: 20),

                _buildSectionTitle("Preferences", context),

                _buildProfileOption(
                  context,
                  icon: Icons.notifications_outlined,
                  title: "Permission Settings",
                  subtitle: "Manage your permissions",
                  onTap: () => profileController.navigateTo(PermissionSettings()),
                ),

                _buildProfileOption(
                  context,
                  icon: Icons.color_lens_outlined,
                  title: "Theme",
                  subtitle: "Choose your preferred theme",
                  onTap: () => showThemeSelector(context, themeProvider),
                ),

                const SizedBox(height: 20),

                _buildSectionTitle("Activity", context),

                _buildProfileOption(
                  context,
                  icon: Icons.history_outlined,
                  title: "Service History",
                  subtitle: "Check your past services",
                  onTap: () => profileController.showToast("coming soon"),
                ),

                _buildProfileOption(
                  context,
                  icon: Icons.star_outline,
                  title: "Your Reviews",
                  subtitle: "Manage and view your reviews",
                  onTap: () => profileController.showToast("coming soon"),
                ),
                if (profileProvider.role == 'admin')
                  _buildProfileOption(
                    context,
                    icon: Icons.admin_panel_settings,
                    iconColor: Colors.red,
                    title: "Admin Control",
                    subtitle: "Manage employees, admins, and customers",
                    onTap: () => profileController.navigateTo(AdminControlPage()),
                  ),

                const SizedBox(height: 20),

                _buildSectionTitle("Support", context),

                _buildProfileOption(
                  context,
                  icon: Icons.help_outline,
                  title: "Help & Feedback",
                  subtitle: "Contact us for assistance",
                  onTap: () => profileController.navigateTo(HelpScreen(scrollController: widget.scrollController)),
                ),

                _buildSectionTitle("Logout", context),

                _buildProfileOption(
                  context,
                  icon: Icons.login_outlined,
                  iconColor: Colors.red,
                  title: "Log Out",
                  titleColor: Colors.red,
                  subtitle: "Log out of your account",
                  onTap: () => profileController.showLogoutDialog(profileProvider),
                ),

               SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }


  ////////////////////////////////////////// Widgets from here ///////////////////////////////////////////////
  ////////////////////////////////////////// Widgets from here ///////////////////////////////////////////////

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }



  Widget _buildProfileOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        Color? iconColor,
        Color? titleColor,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(15),
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
            Icon(icon, size: 28, color: iconColor ?? Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
