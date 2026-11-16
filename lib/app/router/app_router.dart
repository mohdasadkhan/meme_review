import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_review/app/pages/home_page.dart';
import 'package:meme_review/core/constants/app_constants.dart';
import 'package:meme_review/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:meme_review/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:meme_review/features/profile/presentation/pages/profile_page.dart';

/// Application router. Public routes stay open; profile redirects guests.
GoRouter createAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppConstants.routeHome,
    refreshListenable: _AuthRefreshListenable(authCubit),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authCubit.state;
      final loggingIn = state.matchedLocation == AppConstants.routeSignIn;
      final onProfile = state.matchedLocation == AppConstants.routeProfile;

      if (authState.status == AuthStatus.unknown) {
        return null;
      }

      if (!authState.isAuthenticated && onProfile) {
        return AppConstants.routeSignIn;
      }

      if (authState.isAuthenticated && loggingIn) {
        return AppConstants.routeHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppConstants.routeSignIn,
        name: 'sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppConstants.routeProfile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(this._authCubit) {
    _authCubit.stream.listen((_) => notifyListeners());
  }

  final AuthCubit _authCubit;
}
