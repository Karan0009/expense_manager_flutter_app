import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/custom_input_field.dart';
import 'package:expense_manager/core/widgets/loader.dart';
import 'package:expense_manager/features/dashboard/viewmodel/dashboard_main_category_list_viewmodel/dashboard_main_category_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainCatListViewWithSearch extends ConsumerStatefulWidget {
  static final String routePath = '/main-cat-view';
  final bool showCreateButton;
  final String createButtonText;
  final void Function() createButtonOnTap;
  final String searchHintText;
  const MainCatListViewWithSearch({
    super.key,
    required this.showCreateButton,
    required this.createButtonOnTap,
    required this.createButtonText,
    required this.searchHintText,
  });

  @override
  ConsumerState<MainCatListViewWithSearch> createState() =>
      _MainCatListViewWithSearchState();
}

class _MainCatListViewWithSearchState
    extends ConsumerState<MainCatListViewWithSearch> {
  final searchCategoryController = TextEditingController();
  late Future<List<dynamic>> items;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Main Category',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        backgroundColor: ColorsConfig.bgColor1,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorsConfig.textColor4,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ref.watch(dashboardMainCategoryListViewModelProvider).when<Widget>(
            data: (data) {
              if (data == null) {
                return Text(
                  'Err',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsConfig.bgColor1.withValues(alpha: 0.9),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 12),
                        CustomInputField(
                          hintText: widget.searchHintText,
                          controller: searchCategoryController,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(
                            size: 25,
                            Icons.search,
                            color: ColorsConfig.color2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.categories.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(data.categories[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: ColorsConfig.color5,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.flutter_dash,
                                        size: 35,
                                        color: ColorsConfig.textColor2,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Tooltip(
                                        preferBelow: true,
                                        message: data.categories[index].name,
                                        child: SizedBox(
                                          width: 220,
                                          child: Text(
                                            data.categories[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showCreateButton)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: CustomButton(
                        onPressed: widget.createButtonOnTap,
                        isLoading: false,
                        buttonText: widget.createButtonText,
                        prefixIcon: Icon(Icons.add_rounded),
                        containerHeight: 60,
                        containerWidth: 200,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor:
                              ColorsConfig.bgColor1.withValues(alpha: 0.7),
                          textStyle:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: ColorsConfig.color4,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        containerPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        containerStyle: BoxDecoration(
                          color: ColorsConfig.bgColor1.withValues(alpha: 0.7),
                          border: Border.all(
                            color: ColorsConfig.color4,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              );
            },
            error: (error, stackTrace) => Text(
              'Err',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            loading: () => Center(
              child: Loader(),
            ),
          ),
    );
  }
}
