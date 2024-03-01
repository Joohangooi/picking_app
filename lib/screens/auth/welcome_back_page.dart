import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:picking_app/app_properties.dart';

// import 'register_page.dart';

class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  Widget company_logos = const Image(
      width: 120,
      height: 120,
      image:
          AssetImage('assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'));

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = const Text(
      'Welcome Back',
      style: TextStyle(
          color: Colors.black,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Text(
      'Login to your account ',
      style: TextStyle(
        color: Colors.grey[800],
        fontSize: 16.0,
      ),
    );

    Widget loginButton = Material(
        child: Center(
            child: IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_right,
        size: 30,
      ),
      color: Colors.black,
      onPressed: () {},
    )));

    Widget loginForm = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                hintText: 'user@greenstem.com',
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              controller: email,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: 'User Password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              ),
              style: const TextStyle(fontSize: 16.0),
              obscureText: true,
            ),
          ],
        ),
        loginButton
      ],
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Forgot your password? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Text(
              'Reset password',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: greenStemBg,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 80, bottom: 20), // Add padding on the top
                  child: company_logos,
                ),
                welcomeBack,
                subTitle,
                loginForm,
                forgotPassword
              ],
            ),
          )
        ],
      ),
    );
  }
}
