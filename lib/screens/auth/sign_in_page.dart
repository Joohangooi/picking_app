import 'package:flutter/material.dart';
import 'package:picking_app/screens/auth/sign_up_page.dart';
import 'package:picking_app/services/AuthService.dart';
import 'package:picking_app/services/jwt_service.dart';
import 'package:picking_app/screens/main/picking_main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _logo,
                  const SizedBox(height: 20),
                  _header(context),
                  const SizedBox(height: 40),
                  _inputField(context),
                  const SizedBox(height: 40),
                  _forgotPassword(context),
                  const SizedBox(height: 40),
                  _signup(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _header(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Powered by ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'Greenstem Software Business',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: email,
          decoration: InputDecoration(
            hintText: "user@greenstem.com",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: password,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
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
                    builder: (context) => const PickingMainPage()),
              );
            } catch (e) {
              // Extract the relevant part of the exception message
              final errorMessage = e.toString().split('Error: Exception: ')[1];
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
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
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
        "Forgot password?",
        style: TextStyle(color: Colors.green),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(color: Colors.green[700]),
          ),
        )
      ],
    );
  }

  final Widget _logo = const Image(
      width: 120,
      height: 120,
      image:
          AssetImage('assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'));
}
