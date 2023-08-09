
import 'package:flutter/material.dart';
import 'package:transit_run_app/resources/auth_methods.dart';
import 'package:transit_run_app/screens/route_screen.dart';
import 'package:transit_run_app/screens/signup_screen.dart';
import 'package:transit_run_app/utils/colors.dart';
import 'package:transit_run_app/utils/utils.dart';
import 'package:transit_run_app/widgets/textfield_input.dart';
// import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  // int _tabTextIndexSelected = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "Success") {
      // FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // _firestore
      //     .collection('users')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .get()
      //     .then((DocumentSnapshot docs) {
      //   final data = docs.data() as Map<String, dynamic>;
      //   final role = data['usertype'] as String;
      //   if (role == 'Student') {
      //     return Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(builder: ((context) => const StudentScreen())),(route) => false);

      //   } else if (role == 'Driver') {
      //     return Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(builder: ((context) => const DriverScreen())),(route) => false);

      //   } else if (role == 'Admin') {
      //     return Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(builder: ((context) => const HomeScreen())),(route) => false

      //         );

      //   }
      // });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const RouteContainer())));
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
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
                          flex: 1,
                          child: Container(),
                        ),
                        Container(
                          height: 300,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/login_ui.png"),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 12),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            'Please sign in to continue',
                            style: TextStyle(
                                color: text1Color, fontFamily: 'Poppins'),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
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
                        Center(
                          child: InkWell(
                            onTap: loginUser,
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
                                      'LOGIN',
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
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: text1Color, fontFamily: 'Poppins'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const Text(
                                    "Sign up",
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
