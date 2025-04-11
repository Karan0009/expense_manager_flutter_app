import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/transaction_helpers.dart';
import 'package:expense_manager/core/widgets/skeleton_loader.dart';
import 'package:expense_manager/data/models/transactions/summarized_transaction.dart';
import 'package:expense_manager/features/dashboard/viewmodel/monthly_summary_viewmodel/monthly_summary_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpensesCarousel extends ConsumerStatefulWidget {
  const ExpensesCarousel({super.key});

  @override
  ConsumerState<ExpensesCarousel> createState() => _ExpensesCarouselState();
}

class _ExpensesCarouselState extends ConsumerState<ExpensesCarousel> {
  final catSummarizedExpenses = [];
  final itemsPerPage = 4;
  int _currentSlide = 0;
  final carouselSliderController = CarouselSliderController();
  // List<Widget> gridItems = [];

  List<Widget> _addCarouselDots(int totalSlides) {
    return [
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSlides, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentSlide = index;
                carouselSliderController.animateToPage(_currentSlide);
              });
            },
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentSlide == index
                    ? ColorsConfig.textColor5
                    : ColorsConfig.color5,
              ),
            ),
          );
        }),
      )
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(monthlySummaryViewModelProvider).when(
          data: (data) {
            if (data == null) {
              return _emptyStateWidget(context);
            }

            final totalCategories = [
              ...data.categorySummarizedTransactions,
            ];

            // final totalCategories = [
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions,
            //   ...data.categorySummarizedTransactions
            // ].asMap().entries.map((e) {
            //   return e.value.copyWith(
            //       subCategory: e.value.subCategory
            //           .copyWith(name: '${e.value.subCategory.name}-${e.key}'));
            // }).toList();

            final totalCount = totalCategories.length;

            if (totalCount == 0) {
              return _emptyStateWidget(context);
            }
            final totalSlides = (totalCount / itemsPerPage).ceil();
            List<Widget> slides = [];

            for (int i = 0; i < totalSlides; i++) {
              int start = i * itemsPerPage;
              int end = start + itemsPerPage;
              if (end > totalCategories.length) {
                end = totalCategories.length;
              }

              final slideItems = totalCategories.sublist(start, end);
              slides.add(buildGrid(slideItems));
            }
            return Column(
              children: [
                CarouselSlider(
                  carouselController: carouselSliderController,
                  options: CarouselOptions(
                    height: 120,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentSlide = index;
                      });
                    },
                  ),
                  items: slides, // Add multiple grids
                ),
                if (totalSlides > 1) ..._addCarouselDots(totalSlides)
              ],
            );
          },
          error: (err, _) => _emptyStateWidget(context),
          loading: () => _showSkeletonCardsGrid(),
        );
  }
}

Widget _emptyStateWidget(BuildContext context) => Text(
      'No Categories found',
      style: Theme.of(context).textTheme.bodyMedium,
    );

Widget _showSkeletonCardsGrid() {
  return SizedBox(
    width: double.infinity,
    height: 120,
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 60,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        // mainAxisSpacing: 8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return SkeletonLoader(width: 100, height: 40);
      },
    ),
  );
}

Widget buildGrid(List<SummarizedTransaction> items) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 60,
      crossAxisCount: 2,
      crossAxisSpacing: 1,
      // mainAxisSpacing: 8,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return gridItem(
        Icons.restaurant,
        items[index].subCategory.name,
        TransactionHelpers.formatStringAmount(
          items[index].totalAmount.toString(),
        ),
      );
    },
  );
}

Widget gridItem(IconData icon, String label, String amount) {
  return Row(
    children: [
      Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: getRandomColor(),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Icon(icon, size: 20, color: Colors.red),
        ),
      ),
      const SizedBox(width: 15),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorsConfig.textColor5,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: ColorsConfig.textColor4,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ],
      ),
    ],
  );
}

Color getRandomColor() {
  List<Color> colors = [
    ColorsConfig.lightBgColor1,
    ColorsConfig.lightBgColor2,
    ColorsConfig.lightBgColor3
  ];

  final random = Random();
  int randomIndex = random.nextInt(colors.length);

  return colors[randomIndex];
}
