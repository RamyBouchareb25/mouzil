import 'dart:async';

import 'package:tomboula/features/admin/presentation/views/panel.dart';
import 'package:tomboula/features/auth/presentation/views/authpage.dart';
import 'package:tomboula/features/auth/providers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tomboula/features/auth/data/repositories/login_state.dart';
import 'package:tomboula/features/home/presentation/views/home.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final routerNotifier = RouterNotifier(ref);
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: routerNotifier,
      routes: routerNotifier._routes,
      redirect: routerNotifier._redirectLogic,
    );
  },
);

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen<LoginState>(loginControllerProvider, (_, __) {
      notifyListeners();
    });
  }

  FutureOr<String?> _redirectLogic(BuildContext context, GoRouterState state) {
    final loginState = _ref.read(loginControllerProvider);
    final areWeLoggingIn = state.topRoute?.path == '/login';
    final areWeSigningUp = state.topRoute?.path == '/sign-up';
    final isGettingStarted = state.topRoute?.path == '/start';
    if (loginState is LoginInitial) {
      switch (state.topRoute?.path) {
        case '/sign-up':
          return null;
        case '/login':
          return null;
        default:
          return '/login'; // Redirect to login page if not logged in
      }
    }

    if (loginState is LoginLoading) {
      return null;
    }

    if (loginState is LoginFailure) {
      return null;
    }

    if ((areWeLoggingIn || areWeSigningUp || isGettingStarted) &&
        loginState is LoginSuccess) return '/';

    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: "/",
          name: "home",
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path: "/sign-up",
          name: "Sign Up",
          builder: (context, state) => const Authpage(initialIndex: 1),
        ),
        GoRoute(
          path: "/login",
          name: "Login",
          builder: (context, state) => const Authpage(),
        ),
        GoRoute(
          path: "/admin",
          name: "Admin Panel",
          builder: (context, state) => const AdminPanel(),
        ),
      ];
}

Widget defaultSlideTransition(Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
    child: child,
  );
}
