import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_review/app/router/app_router.dart';
import 'package:meme_review/app/theme/app_theme.dart';
import 'package:meme_review/core/constants/app_constants.dart';
import 'package:meme_review/core/di/injection.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';

class MemeArenaApp extends StatefulWidget {
  const MemeArenaApp({super.key});

  @override
  State<MemeArenaApp> createState() => _MemeArenaAppState();
}

class _MemeArenaAppState extends State<MemeArenaApp> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
    _router = createAppRouter(_authCubit);
  }

  @override
  void dispose() {
    // AuthCubit is a GetIt singleton; do not close it with the widget tree.
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: _authCubit,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: _router,
      ),
    );
  }
}
