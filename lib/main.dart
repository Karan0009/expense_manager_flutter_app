import 'package:expense_manager/config/router.dart';
import 'package:expense_manager/config/themes/app_themes.dart';
import 'package:expense_manager/core/helpers/share_service.dart';
import 'package:expense_manager/features/shared_raw_transaction/view/pages/shared_raw_transaction_view.dart';
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
      SharingService().init(onDataReceived: (images, text) {
        if (images.isNotEmpty || (text != null && text.isNotEmpty)) {
          router.pushNamed(SharedRawTransactionView.routePath, extra: {
            'images': images,
            'text': text,
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
