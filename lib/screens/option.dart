import 'package:flutter/material.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  void _onProfileTap(BuildContext context) {
    // TODO: Navigate to profile page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profile tapped')));
  }

  void _onSettingsTap(BuildContext context) {
    // TODO: Navigate to settings page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Settings tapped')));
  }

  void _onLogoutTap(BuildContext context) {
    // TODO: Implement logout logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Logged out')));
              // Add actual logout logic here
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => _onProfileTap(context),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => _onSettingsTap(context),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _onLogoutTap(context),
          ),
        ],
      ),
    );
  }
}
