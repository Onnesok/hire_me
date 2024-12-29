import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/help_page.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:hire_me/service/themeprovider.dart';
import 'package:hire_me/view/Edit_profile_view.dart';
import 'package:hire_me/widgets/bottom_appbar.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';
import 'AdminControlPage.dart'; // Add this import at the top

class ProfilePage extends StatelessWidget {
  final ScrollController scrollController;
  final Function(int) updatePageIndex;

  const ProfilePage({super.key, required this.scrollController, required this.updatePageIndex});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    void _navigateTo(Widget page) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    }
    void _toast(String msg) {
      Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER, backgroundColor: Colors.red);
    }

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // Appbar section ( Profile here )
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
                        // Handle profile picture change
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
                          child: const CircleAvatar(
                            radius: 57,
                            backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "${profileProvider.username}",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2
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
                  onTap: () {
                    _navigateTo(EditProfileView());
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  subtitle: "Update your password for security",
                  onTap: () {
                    _toast("coming soon");
                  },
                ),

                const SizedBox(height: 20),

                _buildSectionTitle("Preferences", context),
                _buildProfileOption(
                  context,
                  icon: Icons.notifications_outlined,
                  title: "Notification Settings",
                  subtitle: "Manage your notifications",
                  onTap: () {
                    _toast("coming soon");
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.color_lens_outlined,
                  title: "Theme",
                  subtitle: "Choose your preferred theme",
                  onTap: () {
                    _showThemeSelector(context, themeProvider);
                  },
                ),

                const SizedBox(height: 20),

                _buildSectionTitle("Activity", context),
                _buildProfileOption(
                  context,
                  icon: Icons.history_outlined,
                  title: "Service History",
                  subtitle: "Check your past services",
                  onTap: () {
                    _toast("coming soon");
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.star_outline,
                  title: "Your Reviews",
                  subtitle: "Manage and view your reviews",
                  onTap: () {
                    _toast("coming soon");
                  },
                ),
                if (profileProvider.role == 'admin')
                  _buildProfileOption(
                    context,
                    icon: Icons.admin_panel_settings,
                    iconColor: Colors.red,
                    title: "Admin Control",
                    subtitle: "Manage employees, admins, and customers",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminControlPage()),
                      );
                    },
                  ),

                const SizedBox(height: 20),

                _buildSectionTitle("Support", context),
                _buildProfileOption(
                  context,
                  icon: Icons.help_outline,
                  title: "Help Center",
                  subtitle: "Get assistance with your issues",
                  onTap: () {
                    _navigateTo(HelpScreen(scrollController: scrollController));
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.feedback_outlined,
                  title: "Feedback",
                  subtitle: "Share your feedback with us",
                  onTap: () {
                    _toast("coming soon");
                  },
                ),

                const SizedBox(height: 30),

                // Log Out Button
                _buildProfileOption(
                  context,
                  icon: Icons.logout,
                  title: "Log Out",
                  subtitle: "Log out of your account",
                  onTap: () => _showLogoutDialog(context),
                  iconColor: Colors.red,
                  titleColor: Colors.red,
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: theme.colorScheme.surface,
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            "Log Out",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to log out?",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 24,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You will need to log in again to access your account.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                profileProvider.updateLoginStatus(false);
                Fluttertoast.showToast(msg: "Logout successful");
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginController()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text(
                "Log Out",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showThemeSelector(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Theme",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
                Divider(thickness: 0.5, color: theme.colorScheme.onPrimaryContainer),
                _buildThemeTile(
                  context,
                  icon: Icons.wb_sunny,
                  title: "Light Theme",
                  description: "Bright and clear theme",
                  isSelected: themeProvider.themeMode == ThemeMode.light,
                  onTap: () {
                    themeProvider.toggleTheme(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                _buildThemeTile(
                  context,
                  icon: Icons.nightlight_round,
                  title: "Dark Theme",
                  description: "Elegant and eye-friendly",
                  isSelected: themeProvider.themeMode == ThemeMode.dark,
                  onTap: () {
                    themeProvider.toggleTheme(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
                _buildThemeTile(
                  context,
                  icon: Icons.brightness_auto,
                  title: "System Default",
                  description: "Follows your system preferences",
                  isSelected: themeProvider.themeMode == ThemeMode.system,
                  onTap: () {
                    themeProvider.toggleTheme(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8)
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
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
