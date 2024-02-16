part of '../home_screen.dart';

class _AddUpdateBottomSheet extends StatefulWidget {
  final EditType editType;
  final tacm.Detail? detail;

  const _AddUpdateBottomSheet({
    required this.editType,
    this.detail,
  });

  @override
  State<_AddUpdateBottomSheet> createState() => _AddUpdateBottomSheetState();
}

class _AddUpdateBottomSheetState extends State<_AddUpdateBottomSheet> {
  @override
  void initState() {
    addUpdateBottomSheetViewModel =
        Provider.of<AddUpdateBottomSheetViewModel>(context, listen: false);
    addUpdateBottomSheetViewModel.initializeAddUpdateBottomSheet(
        editType: widget.editType, detail: widget.detail);

    super.initState();
  }

  late final AddUpdateBottomSheetViewModel addUpdateBottomSheetViewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddUpdateBottomSheetViewModel>(
        builder: (context, addUpdateBottomSheetViewModel, _) {
      return BottomSheet(
        onClosing: () {},
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        builder: (context) => Form(
          key: addUpdateBottomSheetViewModel.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'close',
                  iconSize: 30,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller:
                          addUpdateBottomSheetViewModel.textEditingController,
                      validator:
                          addUpdateBottomSheetViewModel.tAndCFieldValidator,
                      minLines: 1,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Enter Terms and Conditions',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.mic_sharp),
                          onPressed: () async {
                            bool isSpeechPermissionGranted =
                                await addUpdateBottomSheetViewModel
                                    .checkSpeechPermissionIsGranted(context);
                            if (isSpeechPermissionGranted) {
                              if (!context.mounted) return;
                              var res = await showDialog<String?>(
                                context: context,
                                builder: (context) => ChangeNotifierProvider<
                                    SpeechListeningDialogViewModel>(
                                  create: (context) =>
                                      SpeechListeningDialogViewModel(),
                                  builder: (context, _) =>
                                      const _SpeechListeningDialog(),
                                ),
                              );
                              if (res != null && res.isNotEmpty) {
                                addUpdateBottomSheetViewModel
                                    .textEditingController.text = res;
                              }
                            }
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder<bool>(
                        valueListenable:
                            addUpdateBottomSheetViewModel.isLoading,
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
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: addUpdateBottomSheetViewModel
                                .readInHindiButtonOnPressed,
                            child: const Text('Read In Hindi'),
                          );
                        }),
                    if (addUpdateBottomSheetViewModel.translatedText != null)
                      Text(addUpdateBottomSheetViewModel.translatedText!),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () => addUpdateBottomSheetViewModel
                      .addUpdateButtonOnPressed(context),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: Text(
                    (widget.editType == EditType.update) ? 'Update' : 'Add',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    addUpdateBottomSheetViewModel.disposeAppUpdateBottomSheet();
    super.dispose();
  }
}
