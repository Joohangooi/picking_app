import 'package:flutter/material.dart';
import 'package:picking_app/screens/auth/welcome_back_page.dart';
import 'package:picking_app/services/jwt_service.dart'; // Import your jwt_service file

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  AppBarWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            // Implement logout functionality here
            await jwt_service().deleteToken();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomeBackPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
