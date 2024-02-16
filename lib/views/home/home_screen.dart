import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../models/terms_and_conditions_model.dart' as tacm;
import '../../utilities/utilities.dart';
import '../../viewModels/home_view_model.dart';

part 'widgets/add_update_bottomSheet.dart';
part 'widgets/pagination_list_view_widgets.dart';
part 'widgets/speech_listening_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.loadHomeScreenData();
    super.initState();
  }

  late final HomeViewModel _homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text(
              'Terms And Conditions',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: PagedListView.separated(
            pagingController: homeViewModel.pagingController,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            builderDelegate: PagedChildBuilderDelegate<tacm.Detail>(
              itemBuilder: (context, detail, index) {
                return ChangeNotifierProvider(
                  create: (context) => HomeCardViewModel(),
                  builder: (context, _) => _ItemBuilder(
                    detail: detail,
                    homeViewModel: homeViewModel,
                  ),
                );
              },
              noItemsFoundIndicatorBuilder: (_) =>
                  const _NoItemsFoundIndicatorBuilder(),
              noMoreItemsIndicatorBuilder: (_) => _NoMoreItemsIndicatorBuilder(
                onPressed: () async {
                  ResponseType? res = await showModalBottomSheet<ResponseType?>(
                    context: context,
                    builder: (context) =>
                        ChangeNotifierProvider<AddUpdateBottomSheetViewModel>(
                      create: (context) => AddUpdateBottomSheetViewModel(),
                      builder: (context, _) =>
                          const _AddUpdateBottomSheet(editType: EditType.add),
                    ),
                  );
                  homeViewModel.onAddUpdate(res);
                },
              ),
              firstPageErrorIndicatorBuilder: (_) =>
                  _FirstPageErrorIndicatorBuilder(
                error: homeViewModel.pagingController.error,
                onTryAgain: () => homeViewModel.pagingController.refresh(),
              ),
              newPageErrorIndicatorBuilder: (_) =>
                  _NewPageErrorIndicatorBuilder(
                error: homeViewModel.pagingController.error,
                onTryAgain: () =>
                    homeViewModel.pagingController.retryLastFailedRequest(),
              ),
              firstPageProgressIndicatorBuilder: (_) =>
                  const _FirstPageProgressIndicatorBuilder(),
              newPageProgressIndicatorBuilder: (_) =>
                  const _NewPageProgressIndicatorBuilder(),
            ),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _homeViewModel.disposeHomeScreen();
    super.dispose();
  }
}
