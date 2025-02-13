import 'package:flutter/material.dart';
import 'package:login/screens/chat.dart';
import 'package:login/screens/profile.dart';
import 'package:login/screens/setting.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 90,bottom: 30),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 22),
                        _buildTextField(
                          label: 'Name',
                          hintText: 'Enter your name, e.g: John Doe',
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'Email',
                          hintText:
                          'Enter your email, e.g: johndoe@gmail.com',
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'Phone number',
                          hintText: 'Enter your Phone number: +0112*',
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'Password',
                          hintText:
                          'Enter your password, at least 8 character',
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'Confirm Password',
                          hintText:
                          'Enter your password, at least 8 character',
                          obscureText: true,
                        ),
                        SizedBox(height: 25),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff6D6A6A),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 130, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            onPressed: () {
                              // Add your registration logic here
                            },
                            child: GestureDetector(
                              onTap: (){Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  ChatScreen()),
                              );},
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]));
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}