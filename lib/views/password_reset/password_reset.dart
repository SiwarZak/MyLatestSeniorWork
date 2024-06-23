import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/utils/app_colors.dart';
import 'package:tejwal/utils/snackbar_util.dart';

class PasswordResetPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: const Offset(0, 40), // Start position: slide in from the top
              end: const Offset(0, 0), // End position: original position
            ),
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: offset,
                child: child,
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pal1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Image.asset('assets/images/logo2.png', height: 300),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'أدخل إيميلاً لنرسل لك رابط إعادة ضبط كلمة المرور',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'الإيميل',
                            fillColor: Colors.white.withOpacity(0.8),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: authProvider.isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.greenShade,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  //TODO: There is something wrong about this. It sends the email if it is real gmail or other messagaing platform. But what about the fact that signing in with Google Does not require any password?
                                   onPressed: () {
                                    if (_emailController.text.isNotEmpty) {
                                      authProvider.sendPasswordResetEmail(
                                        email: _emailController.text,
                                        onSuccess: () {
                                          showSnackBar(context, 'تم إرسال الرابط إلى إيميلك', AppColors.camel);
                                        },
                                        onError: (error) {
                                          showSnackBar(context, 'خطأ: $error', Colors.red);
                                        },
                                      );
                                    } else {
                                      showSnackBar(context, 'يرجى إدخال الإيميل', Colors.red);
                                    }
                                   },
                                  child: const Text(
                                    'إرسال الإيميل',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}