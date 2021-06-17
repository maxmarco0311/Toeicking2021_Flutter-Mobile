import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/config/custom_router.dart';
import 'package:toeicking2021/repositories/auth/auth_repositories.dart';
import 'package:toeicking2021/screens/screens.dart';

import 'blocs/blocs.dart';
import 'blocs/simple_bloc_observer.dart';
import 'repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 全域設定stringify
  EquatableConfig.stringify = kDebugMode;
  // 宣告自訂的SimpleBlocObserver()
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<APIRepository>(
          create: (_) => APIRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SentenceBundleBloc>(
            create: (context) => SentenceBundleBloc(
              apiRepository: context.read<APIRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: '多益金',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.teal,
              iconTheme: const IconThemeData(color: Colors.white),
              textTheme: const TextTheme(
                headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
