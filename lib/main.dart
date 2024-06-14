import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tejwal/controllers/home_cubit/home_cubit.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:tejwal/views/favorites/farvorites_page.dart';
import 'package:tejwal/views/getStartedPage/get_started_page.dart';
import 'package:tejwal/views/my_trips/my_trips_page.dart';
import 'package:tejwal/views/other_pages/bottom_navigation_bar.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tejwal/utils/router/app_router.dart';
import 'package:tejwal/utils/router/app_routes.dart';
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
            title: 'Flutter E-Commerce App',
            theme: ThemeData(
              textTheme: GoogleFonts.cairoTextTheme(),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: authProvider.currentUser != null ? BottomNavigationbar() : GetStartedPage(),
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}