import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // للتحكم في عرض/إخفاء كلمة المرور
  bool _stayLoggedIn = false; // حالة checkbox
  String selectedLanguage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // جزء "Login Account" بخلفية سوداء
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30,),
                Row(
                  children: [
                    const Text(
                      "Login Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // تكبير الخط قليلاً
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'assets/images/User.png',
                      width: 40,
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Image.asset(
                      'assets/images/egypt.png',
                      width: 30,
                    ),
                    PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            selectedLanguage =
                                value; // تغيير اللغة عند الاختيار
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white, // لون الأيقونة
                          size: 30, // حجم الأيقونة
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'English',
                                child: Text('English'),
                              ),
                              PopupMenuItem(
                                value: 'Arabic',
                                child: Text('العربية'),
                              ),
                            ])
                  ],
                ),
                const Text(
                  "Welcome back To Application",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13, // تكبير النص قليلاً
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Text("Login",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      )),
                ),
              ],
            ),
          ),

          // باقي الصفحة بخلفية بيضاء
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // حقل البريد الإلكتروني
                    const TextField(
                      style:
                          TextStyle(color: Colors.black), // النص باللون الأسود
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18, // تكبير النص الوصفي
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // حقل كلمة المرور مع زر عرض كلمة المرور
                    TextField(
                      obscureText: !_isPasswordVisible, // إظهار/إخفاء النص
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Checkbox "Stay logged in?" وخيار "Forgot Password"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _stayLoggedIn,
                              onChanged: (value) {
                                setState(() {
                                  _stayLoggedIn = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              "Stay logged in?",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // زر تسجيل الدخول
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6D6A6A),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(50), // حواف أقل استدارة
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, // تكبير النص قليلاً
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // رابط التسجيل
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account yet? Register",
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                            ),
                            children: const [
                              TextSpan(
                                text: " here",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            endIndent: 5,
                            indent: 10,
                            color: Colors.grey, // لون الخط
                            thickness: 1, // سماكة الخط
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20),
                          child: Text('Or login with',
                              style: GoogleFonts.quicksand(
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              )),
                        ),
                        const Expanded(
                          child: Divider(
                            endIndent: 5,
                            indent: 10,
                            color: Colors.grey, // لون الخط
                            thickness: 1, // سماكة الخط
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset("assets/images/apple.png"),
                          Image.asset("assets/images/google.png"),
                          Image.asset("assets/images/facebook.png"),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
