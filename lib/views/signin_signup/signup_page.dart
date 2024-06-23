import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/controllers/signup_cubit/signup_cubit.dart';
import 'package:tejwal/utils/router/app_routes.dart';
import 'package:tejwal/utils/snackbar_util.dart';
import 'package:tejwal/views/signin_signup/login_page.dart';
import 'package:tejwal/views/signin_signup/widgets/form_field_widget.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = false;

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
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
                const SizedBox(height: 30.0),
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
                        const SizedBox(height: 15.0),
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
                        const SizedBox(height: 15.0),
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
                        const SizedBox(height: 15.0),
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
                        const SizedBox(height: 30.0),
                        _buildTermsAndConditions(),
                        const SizedBox(height: 15.0),
                        BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            if (state is SignupLoading) {
                              return const CircularProgressIndicator();
                            } else if (state is SignupSuccess) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                //Navigator.of(context).pushNamed(AppRoutes.userInterests); //Commented bacuase it saused a problem when loging out after signing up for first time. Which is routing the user to interests page instead of login page
                              });
                            } else if (state is SignupFailure) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showSnackBar(context, state.error, Colors.red);
                              });
                            }
                            return ElevatedButton(
                              style: _buttonStyle(Colors.green),
                              onPressed: () {
                                if (_formKey.currentState!.validate() && _agreedToTOS) {
                                  context.read<SignupCubit>().signUp(
                                        fullName: _fullNameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                  Navigator.of(context).pushNamed(AppRoutes.userInterests);
                                } else if (!_agreedToTOS) {
                                  showSnackBar(context, 'يجب الموافقة على الشروط والأحكام وسياسة الخصوصية', Colors.red);
                                }
                              },
                              child: const Text('سجل الان', style: TextStyle(fontSize: 18, color: Colors.white)),
                            );
                          },
                        ),
                        const SizedBox(height: 15.0),
                        _buildLoginText(context),
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
          child: StatefulBuilder(
            builder: (context, setState) {
              return Checkbox(
                value: _agreedToTOS,
                activeColor: Colors.green,
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  setState(() {
                    _agreedToTOS = value!;
                  });
                },
              );
            },
          ),
        ),
        const Expanded(
          child: Text(
            'بالتسجيل، أنت توافق على الشروط والأحكام وسياسة الخصوصية',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: const Text(
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
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    );
  }
}

