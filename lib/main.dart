
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // استيراد provider
import 'firebase_options.dart';
import 'global/theme/theme_data/theme_data_light.dart';
import 'global/theme/theme_data/theme_data_dark.dart';
import 'model/AddHospitalProvider.dart';
import 'model/AuthProvider.dart';
import 'model/BookingModel.dart';
import 'model/RegetoProvider.dart';
import 'model/ResetPasswordProvider.dart';
import 'model/SuperUserPanel.dart';
import 'model/Super_Admin_RequestProvider.dart';
import 'model/Themedarkandlightmode.dart';
import 'model/balance_provider.dart';
import 'model/updateuser.dart';
import 'screen/Screens/super_admin/adminbalance.dart';
import 'screen/Screens/users/add balance.dart';
import 'screen/Screens/users/homeScrenn.dart';
import 'screen/login/login.dart';
import 'screen/Screens/super_admin/SuperAdmin.dart';
import 'screen/Screens/super_admin/SuperAdminValidities.dart';
import 'screen/Screens/super_admin/add.dart';
import 'screen/login/registration.dart';
import 'screen/login/reset_password.dart';
import 'screen/onboarding/onboarding_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => RegetoProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (context) => BookingModel()),
        ChangeNotifierProvider(create: (context) => RequestsProvider()),
        ChangeNotifierProvider(create: (context) => SuperUserPanelProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => HospitalProvider()),
        ChangeNotifierProvider(create: (context) => BalanceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على الـ ThemeProvider من الـ Provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode
              ? getThemeDataDark()
              : getThemeDatalight(),
          // home: const OnboardingScreen(),

          initialRoute: OnboardingScreen.screenRoute,

          routes: {
            "OnboardingScreen": (context) => const OnboardingScreen(),
            "LoginScreen": (context) => const LoginScreen(),
            "ResetPassword": (context) => const ResetPassword(),
            "RegistrationScreen": (context) => const RegistrationScreen(),
            "MyHomePage": (context) => MyHomePage(),
            "AddHospitalPage": (context) => const AddHospitalPage(),
            "SuperUserPanelScreen": (context) => const SuperUserPanelScreen(),
            "Validities": (context) => Validities(),
            "AddBalance": (context) => AddBalance(),
            "AdminPage": (context) => AdminPage(),
          },
        );
      },
    );
  }
}
