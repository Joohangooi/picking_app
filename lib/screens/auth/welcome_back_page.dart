import 'package:flutter/material.dart';
import 'package:picking_app/screens/auth/sign_up_page.dart';
import 'package:picking_app/services/AuthService.dart';
import 'package:picking_app/services/jwt_service.dart';
import 'package:picking_app/screens/main/picking_main.dart';
// import 'register_page.dart';

class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget company_logos = const Image(
        width: 120,
        height: 120,
        image: AssetImage(
            'assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'));
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

    Widget loginButton = Align(
      alignment: Alignment.centerRight,
      child: Stack(
        children: [
          Material(
            child: Container(
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   border: Border.all(
              //     color: Colors.black, // Adjust border color as needed
              //     width: 0.5, // Adjust border width as needed
              //   ),
              // ),
              child: IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
                color: Colors.black,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    // Call the login API using the AuthService
                    final authService = AuthService();
                    final response = await authService.loginUser(
                      email.text,
                      password.text,
                    );

                    // If authentication is successful, handle the response accordingly
                    final token = response['token'];

                    final jwtService = jwt_service();
                    await jwtService.storeToken(token);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PickingMainPage()),
                    );
                  } catch (e) {
                    // Extract the relevant part of the exception message
                    final errorMessage =
                        e.toString().split('Error: Exception: ')[1];
                    // Handle the authentication failure
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Authentication Failed'),
                          content: Text(errorMessage),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ),
          ),
          if (isLoading) // Show loading indicator if isLoading is true
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );

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
                fillColor: Colors.white,
              ),
              controller: email,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: ' Password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              ),
              style: const TextStyle(fontSize: 16.0),
              obscureText: true,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: loginButton,
        )
      ],
    );

    Widget registerAcc = Positioned(
      bottom: 35, // Adjust the value as needed
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Not a member? ',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: Text(
                'Create account',
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget forgotPassword = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Forgot your password? ',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            InkWell(
              onTap: () {
                // Show an alert box when tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Reset Password'),
                      content: const Text('This feature is not available now.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Reset password',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                    "assets/background_imgs/picking-bg-1.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.65),
                  BlendMode.lighten,
                ),
                repeat: ImageRepeat.noRepeat,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 70,
                      bottom: 20,
                    ),
                    child: company_logos,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: welcomeBack,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 15),
                    child: subTitle,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 10, right: 30),
                    child: loginForm,
                  ),
                ],
              ),
            ),
          ),
          registerAcc,
          forgotPassword,
        ],
      ),
    );
  }
}
