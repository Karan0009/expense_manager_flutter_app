import 'package:expense_manager/config/router.dart';
import 'package:expense_manager/config/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: NOT WORKING
  // final container = await initializeSharedPreferences();
  // runApp(UncontrolledProviderScope(
  //   container: container,
  //   child: MyApp(),
  // ));

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppThemes.darkThemeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

// TODO: NOT WORKING
// Future<ProviderContainer> initializeSharedPreferences() async {
//   final container = ProviderContainer();
//   await container
//       .read(authViewModelProvider.notifier)
//       .initializeLocalRepository();

//   return container;
// }
