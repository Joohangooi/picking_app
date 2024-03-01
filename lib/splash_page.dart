import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:picking_app/screens/auth/welcome_back_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity; // Declare an animation variable for opacity
  late AnimationController
      controller; // Declare an animation controller variable

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration of 2500 milliseconds (2.5 seconds)
    // and use `this` (the current widget) as the vsync
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);

    // Define an opacity animation from 1.0 (fully opaque) to 0.0 (fully transparent)
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)

      // Add a listener to the opacity animation
      ..addListener(() {
        // Whenever the value of the animation changes, call setState()
        // to rebuild the widget with the new opacity value
        setState(() {});
      });

    // Start the animation and wait for it to complete
    controller.forward().then((_) {
      // Once the animation is complete, call the navigationPage() function
      navigationPage();
    });
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is removed from the tree
    controller.dispose();
    super.dispose();
  }

  void navigationPage() {
    // Navigator.of(context)
    //     .pushReplacement(MaterialPageRoute(builder: (_) => WelcomeBackPage()));
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(color: Colors.green[500]),
        child: SafeArea(
          child: Scaffold(
            body: Center(
              // Wrap with Center widget
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align column content vertically
                children: <Widget>[
                  Expanded(
                    child: Opacity(
                      opacity: opacity.value,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/company_logos/GBS_Logo_220pxby220px_300dpi.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Opacity(
                          opacity: opacity.value,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(text: 'Powered by '),
                                  TextSpan(
                                      text: 'Greenstem Sdb Bhd',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[600]))
                                ]),
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
