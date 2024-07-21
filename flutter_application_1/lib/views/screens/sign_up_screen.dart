import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_auth_services.dart';
import 'package:flutter_application_1/views/screens/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerCheck =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                const Column(
                  children: [
                    Text(
                      'Sign up to chatbox',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                    ),
                    SizedBox(height: 17),
                    Column(
                      children: [
                        Text(
                          'Sign up using your email',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Color(0xFF797C7B)),
                        ),
                        Text(
                          'to join us',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Color(0xFF797C7B)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 240,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your email',
                            style: TextStyle(
                                color: Color(0xFF24786D),
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your password',
                            style: TextStyle(
                                color: Color(0xFF24786D),
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Confirm password',
                            style: TextStyle(
                                color: Color(0xFF24786D),
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          TextFormField(
                            controller: _passwordControllerCheck,
                            decoration: const InputDecoration(),
                            obscureText: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value != _passwordController.text) {
                                return 'Password doesn\'t match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 145,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              _passwordController.text ==
                                  _passwordControllerCheck.text) {
                            firebaseAuthServices.signUp(_emailController.text,
                                _passwordController.text);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(17),
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0xFF24786D),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text('Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(17),
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text('Log In',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Color(0xFF24786D))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
