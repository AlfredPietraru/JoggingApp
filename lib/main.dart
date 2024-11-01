import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/client.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/pages/landing_page.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/pages/map_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final client = AuthenticationClient();
  final userRepository = UserRepository(
      authenticationClient: client,
      prefs: await SharedPreferences.getInstance());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit(
                  userRepository: userRepository,
                )),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => userRepository),
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return Container(
            child: switch (status) {
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
