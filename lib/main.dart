import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/views/getStartedPage/get_started_page.dart';
import 'package:tejwal/views/other_pages/bottom_navigation_bar.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tejwal/utils/router/app_router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = Provider.of<AuthProvider>(context);
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("ar", "AE"),
            ],
            locale: const Locale("ar", "AE"),
            title: 'Tejwal',
            theme: ThemeData(
              textTheme: GoogleFonts.cairoTextTheme(),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: authProvider.currentUser != null ? const BottomNavigationbar() : const GetStartedPage(),
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}