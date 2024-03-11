import 'package:flutter/material.dart';
import 'package:picking_app/screens/auth/welcome_back_page.dart';

class RegistrationDto {
  String? name;
  String? email;
  String? password;
  String? phoneNum;
  String? address;
  bool isApproved;
  String? company;

  RegistrationDto({
    this.name,
    @required this.email,
    @required this.password,
    this.phoneNum,
    this.address,
    this.isApproved = false,
    @required this.company,
  }) {}
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _registrationDto = RegistrationDto();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _addressController = TextEditingController();
  final _companyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    "assets/background_imgs/picking-bg-2.jpeg",
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.60),
                    BlendMode.lighten,
                  ),
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const SizedBox(height: 40.0),
                          const Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Create your account",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white.withOpacity(0.6),
                              filled: true,
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white.withOpacity(0.6),
                              filled: true,
                              prefixIcon: const Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              }
                              // Add additional email validation if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white.withOpacity(0.6),
                              filled: true,
                              prefixIcon: const Icon(Icons.password),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password";
                              }
                              // Add additional password validation if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _phoneNumController,
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white.withOpacity(0.6),
                              filled: true,
                              prefixIcon: const Icon(Icons.phone),
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty && value.length > 20) {
                                return "Phone number must not be longer than 20 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              hintText: "Address",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white.withOpacity(0.6),
                              filled: true,
                              prefixIcon: const Icon(Icons.location_on),
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty && value.length > 100) {
                                return "Address should not be longer than 100 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _companyController,
                            decoration: InputDecoration(
                              hintText: "Company",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white.withOpacity(0.6),
                              filled: true,
                              prefixIcon: const Icon(Icons.business),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your company name";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registrationDto.name = _nameController.text;
                              _registrationDto.email = _emailController.text;
                              _registrationDto.password =
                                  _passwordController.text;
                              _registrationDto.phoneNum =
                                  _phoneNumController.text;
                              _registrationDto.address =
                                  _addressController.text;
                              _registrationDto.company =
                                  _companyController.text;

                              // You can now use the _registrationDto object for further processing
                              // or submit it to an API endpoint
                              // print(_registrationDto.toJson());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green[500],
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeBackPage()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
