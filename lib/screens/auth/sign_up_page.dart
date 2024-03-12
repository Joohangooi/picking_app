import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picking_app/blocs/signup_bloc.dart';
import 'package:picking_app/screens/auth/sign_in_page.dart';
import 'package:picking_app/services/AuthService.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _addressController = TextEditingController();
  final _companyController = TextEditingController();

  late SignupBloc _signupBloc;

  @override
  void initState() {
    super.initState();
    _signupBloc = SignupBloc();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    _signupBloc.close();
    super.dispose();
  }

  void _resetSignupBloc() {
    _signupBloc.close();
    _signupBloc = SignupBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => _signupBloc,
        child: Scaffold(
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
                  child: BlocListener<SignupBloc, SignupState>(
                    listener: (context, state) async {
                      if (state is SignupSuccess) {
                        print("Successful signup!");
                        try {
                          final authService = AuthService();
                          final response = await authService.registerUser(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _phoneNumController.text,
                              _addressController.text,
                              _companyController.text);
                          if (response == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Signup successful'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          } else if (response == 409) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email Address Existence!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            _signupBloc.add(const TriggerEmailError(
                                "Email Address Existance!"));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Signup failed'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          print(e.toString());
                        } finally {}
                      } else if (state is SignupFailure) {
                        print("Failed signup!");
                      }
                    },
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              const SizedBox(height: 50.0),
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
                                    fontSize: 15, color: Colors.grey[800]),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: <Widget>[
                              const SizedBox(height: 20),
                              BlocBuilder<SignupBloc, SignupState>(
                                buildWhen: (previous, current) =>
                                    previous is SignupFailure ||
                                    current is SignupFailure,
                                builder: (context, state) {
                                  return TextFormField(
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
                                      errorText: (state is SignupFailure)
                                          ? state.name
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<SignupBloc, SignupState>(
                                buildWhen: (previous, current) =>
                                    previous is SignupFailure ||
                                    current is SignupFailure,
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: _emailController,
                                    onChanged: (value) {
                                      if (value != _emailController.text) {
                                        _resetSignupBloc();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none,
                                      ),
                                      fillColor: Colors.white.withOpacity(0.6),
                                      filled: true,
                                      prefixIcon: const Icon(Icons.email),
                                      errorText: (state is SignupFailure)
                                          ? (state.email ??
                                              state.emailDuplicateError)
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<SignupBloc, SignupState>(
                                buildWhen: (previous, current) =>
                                    previous is SignupFailure ||
                                    current is SignupFailure,
                                builder: (context, state) {
                                  return TextFormField(
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
                                      errorText: (state is SignupFailure)
                                          ? state.password
                                          : null,
                                    ),
                                    obscureText: true,
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<SignupBloc, SignupState>(
                                buildWhen: (previous, current) =>
                                    previous is SignupFailure ||
                                    current is SignupFailure,
                                builder: (context, state) {
                                  return TextFormField(
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
                                      errorText: (state is SignupFailure)
                                          ? state.phoneNum
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<SignupBloc, SignupState>(
                                buildWhen: (previous, current) =>
                                    previous is SignupFailure ||
                                    current is SignupFailure,
                                builder: (context, state) {
                                  return TextFormField(
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
                                      errorText: (state is SignupFailure)
                                          ? state.address
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<SignupBloc, SignupState>(
                                buildWhen: (previous, current) =>
                                    previous is SignupFailure ||
                                    current is SignupFailure,
                                builder: (context, state) {
                                  return TextFormField(
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
                                      errorText: (state is SignupFailure)
                                          ? state.company
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            child: ElevatedButton(
                              onPressed: () {
                                _signupBloc.add(
                                  SignupFormSubmitted(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    phoneNum: _phoneNumController.text,
                                    address: _addressController.text,
                                    company: _companyController.text,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.green[500],
                              ),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.green[900],
                                      fontSize: 18,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
