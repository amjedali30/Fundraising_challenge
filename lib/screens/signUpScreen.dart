import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constent/app_colors.dart';
import '../constent/app_responsive_size.dart';
import '../constent/app_size.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  Future<void> _signUp() async {
    if (_usernameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final username = _usernameController.text.trim();
      final phoneNumber = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').add({
        'username': username,
        'phoneNumber': phoneNumber,
        'passwordHash': password,
      });
      setState(() {
        isLoad = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      setState(() {
        isLoad = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalied Details...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppResponsiveSizes responsiveSizes = AppResponsiveSizes(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background image filling the screen, rotated upside down
              Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Transform.rotate(
                    angle: 3.14159, // 180 degrees in radians
                    child: Image.asset(
                      'assets/bg1.jpeg', // Replace with your image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Positioned(
              //     top: MediaQuery.of(context).size.height * 0.05,
              //     left: 20,
              //     child: IconButton(
              //         color: Colors.white,
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //         iconSize: 30,
              //         icon: Icon(Icons.arrow_back))),
              Container(
                width: double.infinity,
                height: 300,
                child: Image(
                  image: AssetImage("assets/image1.png"),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.25, // Start from halfway
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.fontLarge,
                              color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle:
                                TextStyle(color: AppColors.textSecondary),
                            suffixIcon: Icon(
                              Icons.shield_outlined,
                              color: AppColors.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.textFieldColor3,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle:
                                TextStyle(color: AppColors.textSecondary),
                            suffixIcon: Icon(
                              Icons.call,
                              color: AppColors.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.textFieldColor3,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.textFieldColor3,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor1,
                            shape: const StadiumBorder(),
                            fixedSize: Size(
                              responsiveSizes.dynamicWidth(30),
                              responsiveSizes.dynamicHeight(2),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoad = true;
                            });
                            if (isLoad = true) {
                              _signUp();
                            }
                          },
                          child: Text(
                            isLoad ? 'Sign In....' : 'Sign In',
                            style: TextStyle(
                                color: AppColors.textFieldColor3,
                                fontSize: responsiveSizes.dynamicFont(3)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account?   ',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: AppSizes.fontSmall,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Log In',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: AppSizes.fontMedium,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  bool isLoad = false;
}
