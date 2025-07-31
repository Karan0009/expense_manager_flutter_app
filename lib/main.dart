import 'package:expense_manager/config/router.dart';
import 'package:expense_manager/config/themes/app_themes.dart';
import 'package:expense_manager/core/helpers/connectivity_service.dart';
import 'package:expense_manager/core/helpers/local_db_service.dart';
import 'package:expense_manager/core/helpers/share_service.dart';
import 'package:expense_manager/features/shared_raw_transaction/view/pages/shared_raw_transaction_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await LocalDbService().deleteDb();
  // Initialize the database
  await LocalDbService().database;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();

      initGlobalServices();
    });
  }

// init global services here
  void initGlobalServices() async {
    SharingService().init(onDataReceived: (images, text) {
      if (images.isNotEmpty || (text != null && text.isNotEmpty)) {
        router.pushNamed(SharedRawTransactionView.routePath, extra: {
          'images': images,
          'text': text,
        });
      }
    });

    await ConnectivityService().init();
  }

  @override
  void dispose() {
    super.dispose();
    SharingService().dispose();
    ConnectivityService().dispose();
  }

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
