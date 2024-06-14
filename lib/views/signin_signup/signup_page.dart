import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/utils/router/app_routes.dart';
import 'package:tejwal/views/signin_signup/widgets/form_field_widget.dart';
import 'package:tejwal/views/signin_signup/login_page.dart';
import 'package:tejwal/utils/snackbar_util.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/pal10.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0), 
                  child: Image.asset('assets/images/logo2.png', height: 300),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FormFieldWidget(
                          controller: _fullNameController,
                          hintText: 'الاسم الكامل',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم الكامل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        FormFieldWidget(
                          controller: _emailController,
                          hintText: 'البريد الإلكتروني',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'الرجاء إدخال بريد إلكتروني صالح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        FormFieldWidget(
                          controller: _passwordController,
                          hintText: 'كلمة المرور',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        FormFieldWidget(
                          controller: _confirmPasswordController,
                          hintText: 'تأكيد كلمة المرور',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال تأكيد كلمة المرور';
                            }
                            if (value != _passwordController.text) {
                              return 'كلمة المرور غير متطابقة';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.0),
                        _buildTermsAndConditions(),
                        SizedBox(height: 15.0),
                        authProvider.isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                style: _buttonStyle(Colors.green),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() && _agreedToTOS) {
                                    authProvider.signUp(
                                      fullName: _fullNameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      onSuccess: () {
                                        Navigator.of(context).pushNamed(AppRoutes.userInterests);
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => UserInterestsPage()),
                                        // );
                                      },
                                      onError: (message) {
                                        showSnackBar(context, message, Colors.red);
                                      },
                                    );
                                  } else if (!_agreedToTOS) {
                                    showSnackBar(context, 'يجب الموافقة على الشروط والأحكام وسياسة الخصوصية', Colors.red);
                                  }
                                },
                                child: Text('سجل الان', style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                        SizedBox(height: 15.0),
                        _buildLoginText(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.white, 
          ),
          child: Checkbox(
            value: _agreedToTOS,
            activeColor: Colors.green, 
            checkColor: Colors.white,
            onChanged: (bool? value) {
              setState(() {
                _agreedToTOS = value!;
              });
            },
          ),
        ),
        Expanded(
          child: Text(
            'بالتسجيل، أنت توافق على الشروط والأحكام وسياسة الخصوصية',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Text(
        'هل لديك حساب بالفعل؟ تسجيل الدخول',
        style: TextStyle(color: Colors.white70, fontSize: 14, decoration: TextDecoration.underline),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.green, 
      backgroundColor: color, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    );
  }
}
