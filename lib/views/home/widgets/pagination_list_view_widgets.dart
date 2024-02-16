part of '../home_screen.dart';

class _ItemBuilder extends StatefulWidget {
  final tacm.Detail detail;
  final HomeViewModel homeViewModel;

  const _ItemBuilder({
    required this.detail,
    required this.homeViewModel,
  });

  @override
  State<_ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<_ItemBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCardViewModel>(
        builder: (context, homeCardViewModel, _) {
      return InkWell(
        onTap: () async {
          ResponseType? res = await showModalBottomSheet<ResponseType?>(
            context: context,
            builder: (context) => ChangeNotifierProvider.value(
              value: widget.homeViewModel,
              builder: (context, _) =>
                  ChangeNotifierProvider<AddUpdateBottomSheetViewModel>(
                create: (context) => AddUpdateBottomSheetViewModel(),
                builder: (context, _) => _AddUpdateBottomSheet(
                  editType: EditType.update,
                  detail: widget.detail,
                ),
              ),
            ),
          );
          widget.homeViewModel.onAddUpdate(res);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _commonHeightPadding,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(widget.detail.value.replaceAll('\n', ' ').trim()),
              ),
              _commonHeightPadding,
              if (homeCardViewModel.translatedText != null)
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(homeCardViewModel.translatedText!),
                  ),
                ),
              Visibility(
                  visible: homeCardViewModel.translatedText == null,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ValueListenableBuilder<bool>(
                        valueListenable: homeCardViewModel.isLoading,
                        builder: (context, isLoading, _) {
                          if (isLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            );
                          }
                          return TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => homeCardViewModel
                                .readInHindiButtonOnPressed(widget.detail),
                            child: const Text('Read In Hindi'),
                          );
                        }),
                  )),
            ],
          ),
        ),
      );
    });
  }

  Widget get _commonHeightPadding => const SizedBox(height: 8.0);

  @override
  void dispose() {
    super.dispose();
  }
}

class _FirstPageErrorIndicatorBuilder extends StatelessWidget {
  final dynamic error;
  final void Function() onTryAgain;

  const _FirstPageErrorIndicatorBuilder({
    this.error,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Something Went Wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.all(10),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: onTryAgain,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class _NewPageErrorIndicatorBuilder extends StatelessWidget {
  final dynamic error;
  final void Function() onTryAgain;

  const _NewPageErrorIndicatorBuilder({
    this.error,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15.0),
        ),
        onPressed: onTryAgain,
        child: const Icon(
          Icons.refresh,
          size: 30.0,
        ),
      ),
    );
  }
}

class _FirstPageProgressIndicatorBuilder extends StatelessWidget {
  const _FirstPageProgressIndicatorBuilder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _NewPageProgressIndicatorBuilder extends StatelessWidget {
  const _NewPageProgressIndicatorBuilder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _NoItemsFoundIndicatorBuilder extends StatelessWidget {
  const _NoItemsFoundIndicatorBuilder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Items Found'),
    );
  }
}

class _NoMoreItemsIndicatorBuilder extends StatelessWidget {
  final void Function()? onPressed;

  const _NoMoreItemsIndicatorBuilder({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.green,
        padding: const EdgeInsets.all(8.0),
      ),
      child: const Text(
        'Add More',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
