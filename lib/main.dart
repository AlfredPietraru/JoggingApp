import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/notification_service.dart';
import 'package:jogging/pages/landing_page.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/pages/map/map_page.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'firebase_options.dart';
import 'package:disposebag/disposebag.dart' show DisposeBagConfigs;
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DisposeBagConfigs.logger = null;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String? notificationToken = await NotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final prefs = await SharedPreferences.getInstance();
  if (notificationToken!.isNotEmpty) {
    prefs.setString("notificationToken", notificationToken);
  }
  final userRepository = UserRepository(
    prefs: RxSharedPreferences(
      prefs,
      const RxSharedPreferencesDefaultLogger(),
    ),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppCubit(
              userRepository: userRepository,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final status = context.select((AppCubit cubit) => cubit.state.status);

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return Container(
            child: switch (status) {
              AppStatus.lostConnection => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              AppStatus.unauthenticated => const LandingPage(),
              AppStatus.initializing => const Scaffold(
                  body: Center(child: CircularProgressIndicator())),
              AppStatus.authenticated => const MapPage(),
            },
          );
        },
      ),
    );
  }
}
