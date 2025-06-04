import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_gmbh_assignment/blocs/user/user_bloc.dart';
import 'package:nineti_gmbh_assignment/cubit/theme_cubit.dart';
import 'package:nineti_gmbh_assignment/repositories/user_repository.dart';
import 'package:nineti_gmbh_assignment/screens/user_detail/user_detail_screen.dart';
import 'package:nineti_gmbh_assignment/screens/user_list/user_list_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => UserBloc(UserRepository())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    UserBloc(RepositoryProvider.of<UserRepository>(context)),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(), // ✅ ThemeCubit provider
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'User Hive',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.blue,
                  // foregroundColor: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Colors.black,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.blue,
                  // foregroundColor: Colors.white,
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                textTheme: const TextTheme(
                  bodyMedium: TextStyle(color: Colors.white),
                ),
              ),
              themeMode: themeMode,
              initialRoute: '/',
              routes: {
                '/': (context) => const UserListScreen(),
                '/user_detail': (context) => const UserDetailScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
