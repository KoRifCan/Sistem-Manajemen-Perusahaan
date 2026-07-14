import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/routes/app_router.dart';

final router = AppRouter().router;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
