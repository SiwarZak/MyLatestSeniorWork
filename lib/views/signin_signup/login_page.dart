import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/utils/router/app_routes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                image: AssetImage('assets/images/pal10.jpg'),
                fit: BoxFit.cover,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'مرحبًا بعودتك،',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'البريد الالكتروني',
                              fillColor: Colors.white.withOpacity(0.8),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'كلمة المرور',
                              fillColor: Colors.white.withOpacity(0.8),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'هل نسيت كلمة السر؟',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4DD54F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _signIn(context);
                                }
                              },
                              child: authProvider.isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text('تسجيل الدخول', style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Center(
                            child: Text(
                              'أو',
                              style: TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.g_translate, color: Colors.white),
                              label: Text(
                                'تسجيل الدخول بواسطة Google',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.orange, // Orange color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ليس لديك حساب؟",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {
                                   Navigator.of(context).pushNamed(AppRoutes.signUp);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => SignUpPage()), // Navigate to Signup page
                                  // );
                                },
                                child: Text(
                                  'انشاء حساب',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  void _signIn(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.signIn(
      email: email,
      password: password,
      onSuccess: () {
        Navigator.of(context).pushNamed(AppRoutes.bottomNavigationbar);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const BottomNavigationbar()),
        // );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    );
  }
}
