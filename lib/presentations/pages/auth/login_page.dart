import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senandika/constants/route_constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A5ACD), // Medium purple
              Color(0xFF1565C0), // Indigo
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Blue header with Login text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 30,
                  left: 24,
                  right: 24,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Shrinks the touch area to the icon size
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login title
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Selamat Datang Kembali!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Meaningful Description
                    const Text(
                      'Lanjutkan perjalanan kesehatan mentalmu. Kami siap mendengarkan dan mendukungmu kapan saja.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.4, // Improves readability for multi-line text
                      ),
                    ),
                  ],
                ),
              ),

              // White form container
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          // Email field
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B0082), // Purple text
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Color(0xFF4B0082)),
                            decoration: InputDecoration(
                              hintText: 'Masukkan Email',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xFF4B0082),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Password field
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B0082), // Purple text
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Color(0xFF4B0082)),
                            decoration: InputDecoration(
                              hintText: 'Masukkan Password',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF4B0082),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF4B0082),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // Remember me and Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                      });
                                    },
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all(
                                      const Color(0xFF4B0082),
                                    ),
                                  ),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(color: Color(0xFF4B0082)),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to forgot password
                                },
                                child: const Text(
                                  'Lupa sandi?',
                                  style: TextStyle(
                                    color: Color(0xFF1565C0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // if (_formKey.currentState!.validate()) {
                                //   // Process login
                                // }

                                Get.toNamed(RouteConstants.home);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF1565C0,
                                ), // Dark blue
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // OR divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.withOpacity(0.5),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.withOpacity(0.5),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Google login button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                // Process Google login
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF4B0082),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Google icon placeholder
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/google_logo.png',
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Masuk dengan Google',
                                    style: TextStyle(
                                      color: Color(0xFF4B0082),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Belum memiliki akun? ',
                                style: TextStyle(color: Color(0xFF4B0082)),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to sign up page
                                  Get.toNamed(RouteConstants.sign_up);
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFF1565C0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
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
