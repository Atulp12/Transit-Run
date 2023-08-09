// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:transit_run_app/resources/auth_methods.dart';
import 'package:transit_run_app/screens/login_screen.dart';
import 'package:transit_run_app/screens/route_screen.dart';
import 'package:transit_run_app/utils/colors.dart';
import 'package:transit_run_app/utils/utils.dart';
import 'package:transit_run_app/widgets/textfield_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String selectedValue = '';
  bool _isLoading = false;

  final List<String> accountType = [
    'Student',
    'Driver',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _nameController.text,
      usertype: selectedValue,
    );

    setState(() {
      _isLoading = false;
    });
    if (res != 'Success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      // if (selectedValue == accountType[0]) {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => const StudentScreen()),
      //       (route) => false);
      // } else if (selectedValue == accountType[1]) {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => const DriverScreen()),
      //       (route) => false);
      // } else {
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => const HomeScreen()),
      //       (route) => false);
      // }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const RouteContainer())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Container(),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 9, bottom: 10),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            'Please fill the input below here',
                            style: TextStyle(
                                color: text1Color, fontFamily: 'Poppins'),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFieldInput(
                          textEditingController: _nameController,
                          hintText: 'Enter your name',
                          textInputType: TextInputType.text,
                          icon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFieldInput(
                          textEditingController: _emailController,
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress,
                          icon: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFieldInput(
                          textEditingController: _passwordController,
                          hintText: 'Enter your password',
                          textInputType: TextInputType.text,
                          isPass: true,
                          icon: const Icon(Icons.lock_outline),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        DropdownButtonFormField(
                          hint: const Text('Select a role'),
                          style: const TextStyle(
                              fontFamily: 'Poppins', fontSize: 16),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                          ),
                          dropdownColor: backgroundColor,
                          value: accountType[0],
                          validator: (value) =>
                              value == null ? "Select a role" : null,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              selectedValue = newValue;
                            });
                          },
                          items: accountType.map((accountType) {
                            return DropdownMenuItem(
                              value: accountType,
                              child: Text(accountType),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: InkWell(
                            onTap: signUpUser,
                            child: Container(
                              width: 230,
                              height: 60,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  color: tealColor),
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: text1Color,
                                    ))
                                  : const Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          fontSize: 17),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      color: text1Color, fontFamily: 'Poppins'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: tealColor,
                                        fontFamily: 'Poppins'),
                                  ),
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
          },
        ),
      ),
    );
  }
}
