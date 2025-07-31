import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/features/shared_raw_transaction/viewmodel/shared_raw_transaction_viewmodel.dart';
import 'package:expense_manager/features/splash_screen/view/pages/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class SharedRawTransactionView extends ConsumerStatefulWidget {
  static const String routePath = '/shared-raw-transaction';
  // todo: image and text data shared from router
  final List<SharedMediaFile> images;
  final String? text;
  const SharedRawTransactionView({
    super.key,
    this.images = const [],
    this.text,
  });

  @override
  ConsumerState<SharedRawTransactionView> createState() =>
      _SharedRawTransactionViewState();
}

class _SharedRawTransactionViewState
    extends ConsumerState<SharedRawTransactionView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();

      // If no images or text are shared, do not proceed
      if (widget.images.isEmpty && widget.text == null) {
        return;
      }

      final vm = ref.read(sharedRawTransactionViewModelProvider.notifier);
      await vm.createRawUserTransaction(
        type: widget.images.isNotEmpty
            ? AppConfig.rawTransactionTypeWAImage
            : AppConfig.rawTransactionTypeWAText,
        data: widget.images.isNotEmpty ? widget.images[0].path : widget.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          // 💥 Close Button at top right
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                } else {
                  context.pushReplacement(SplashScreenView.routePath);
                }
              },
              child: const Icon(Icons.close, size: 32, color: Colors.white),
            ),
          ),

          // 💥 Main Content
          ref.watch(sharedRawTransactionViewModelProvider)?.when(
                  data: (data) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/check_mark.png',
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Transaction Shared Successfully',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 20),
                          Text(
                            'Error Sharing Transaction',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  }) ??
              const SizedBox.shrink(),
        ],
      ),
    );
  }
}
