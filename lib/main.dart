import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/provider/network_status_provider.dart';
import 'core/provider/validation_provider.dart';
import 'features/Authentication/presentation/provider/authentication_provider.dart';
import 'features/ChangePasswordInProfile/presentation/provider/change_password_provider.dart';
import 'features/EventDashboard/presentation/provider/event_dashboard_provider.dart';
import 'features/Home/presentation/provider/home_provider.dart';
import 'features/LandingEvent/presentation/provider/landing_event_provider.dart';
import 'features/LandingSearchEvents/presentation/provider/search_event_provider.dart';
import 'features/SplashScreen/presentation/pages/splashscreen.dart';
import 'features/User/presentation/provider/user_provider.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //? dependency injection = di



  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ValidationProvider()),
        ChangeNotifierProvider(
          create: (context) => di.myInjection<AuthenticationProvider>(),
        ),
        ChangeNotifierProvider(create: (_) => NetworkStatusProvider()),
        ChangeNotifierProvider(create: (_) => di.myInjection<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => di.myInjection<LandingEventProvider>()),
        ChangeNotifierProvider(create: (_) => di.myInjection<SearchEventsProvider>()),
        ChangeNotifierProvider(create: (_) => di.myInjection<EventDashboardProvider>()),
        ChangeNotifierProvider(create: (_) => di.myInjection<ChangePasswordProvider>()),
        ChangeNotifierProvider(create: (_) => di.myInjection<UserProvider>()),
      ],
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
