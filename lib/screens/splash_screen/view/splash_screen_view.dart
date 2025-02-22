import 'package:expense_manager/config/colors_config.dart';
import 'package:expense_manager/screens/splash_screen/controller/splash_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreenView extends ConsumerWidget {
  static const String routePath = '/';
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(splashScreenViewModelProvider);
    final viewModel = ref.read(splashScreenViewModelProvider.notifier);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          viewModel.checkIfUserLoggedIn(context);
          // final isMobile = constraints.maxWidth < 600;
          // final screenSize = MediaQuery.of(context).size;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/piggy_img.png',
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxWidth * 0.3,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: ColorsConfig.bgColor1,
    );
  }
}
