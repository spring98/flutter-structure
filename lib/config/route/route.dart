import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:structure/config/di/di_setup.dart';
import 'package:structure/feature/home/view/home_view_model.dart';
import 'package:structure/feature/home/view/index.dart';

enum ViewRoute {
  home,
}

extension RouteName on ViewRoute {
  String get name {
    return switch (this) {
      ViewRoute.home => 'home',
    };
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final kRouter = GoRouter(
  initialLocation: '/',
  observers: [
    routeObserver,
  ],
  routes: [
    /// Auth
    GoRoute(
      path: '/',
      name: 'Home',
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (context) => getIt<HomeViewModel>(),
          child: const HomeView(),
        );
      },
    ),
  ],
);
