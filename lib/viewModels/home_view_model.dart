import "package:flutter/material.dart";
import "package:flutter_coding_assignment_pidilite_ventures/repositories/home_repository.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:permission_handler/permission_handler.dart";
import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";

import "../models/terms_and_conditions_model.dart" as tacm;
import "../services/on_device_translation_service.dart";
import "../utilities/utilities.dart";

class HomeViewModel extends ChangeNotifier {
  static final HomeViewModel _instance = HomeViewModel._internal();

  factory HomeViewModel() => _instance;

  HomeViewModel._internal();

  late final PagingController<int, tacm.Detail> pagingController;
  final int _perPageSize = 15;

  Map<String, dynamic>? _tAndCData;
  bool _isInitial = false;

  bool get isInitial => _isInitial;

  set isInitial(bool value) {
    _isInitial = value;
  }

  tacm.TermsAndConditionsModel get tAndCData =>
      tacm.TermsAndConditionsModel.fromJson(_tAndCData);

  set tAndCData(tacm.TermsAndConditionsModel termsAndConditionsModel) =>
      _tAndCData = termsAndConditionsModel.toJson();

  Future loadHomeScreenData() async {
    pagingController = PagingController<int, tacm.Detail>(firstPageKey: 0);
    pagingController
        .addPageRequestListener((pageKey) => fetchTAndCData(pageKey));
  }

  Future<void> fetchTAndCData(int pageKey) async {
    try {
      if (!isInitial) {
        isInitial = true;
        tAndCData = (await HomeRepository().getTAndCDataFromApi())!;
      }
      int end = pageKey + _perPageSize;
      List<tacm.Detail> items = tAndCData.details.sublist(
        pageKey,
        (end > tAndCData.details.length) ? tAndCData.details.length : end,
      );

      final bool isLastPage = items.length < _perPageSize;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + items.length;
        pagingController.appendPage(items, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  addTAndCData(String value) {
    List<tacm.Detail> details = tAndCData.details;
    int previousId =
        details.reduce((curr, next) => (curr.id > next.id) ? curr : next).id;
    details.add(
      tacm.Detail(
        userId: 11,
        id: previousId + 1,
        body: value,
      ),
    );
    tAndCData = tacm.TermsAndConditionsModel(details: details);
  }

  updateTAndCData(int id, String value) {
    tacm.TermsAndConditionsModel data = tAndCData;
    data.details.map((e) {
      if (e.id == id) {
        e.body = value;
      }
      return e;
    }).toList();
    tAndCData = data;
  }

  onAddUpdate(ResponseType? res) {
    if (res != null && res == ResponseType.success) {
      pagingController.refresh();
    }
  }

  void disposeHomeScreen() {
    pagingController.dispose();
  }
}

class HomeCardViewModel extends ChangeNotifier {
  String? translatedText;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void readInHindiButtonOnPressed(tacm.Detail detail) async {
    isLoading.value = true;

    translatedText =
        await OnDeviceTranslationService().translateText(detail.body ?? '');
    isLoading.value = false;
    notifyListeners();
  }
}

class AddUpdateBottomSheetViewModel extends ChangeNotifier {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  late TextEditingController textEditingController;
  late final EditType editType;
  late final tacm.Detail? detail;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? translatedText;

  SpeechToText speechToText = SpeechToText();

  Future initializeAddUpdateBottomSheet(
      {required EditType editType, required tacm.Detail? detail}) async {
    textEditingController = TextEditingController();
    this.editType = editType;
    this.detail = detail;
    switch (editType) {
      case EditType.add:
        break;
      case EditType.update:
        textEditingController.text = detail?.body ?? '';
        break;
      default:
        break;
    }
  }

  void readInHindiButtonOnPressed() async {
    if (textEditingController.text.isNotEmpty) {
      isLoading.value = true;
      translatedText = await OnDeviceTranslationService()
          .translateText(textEditingController.text);
      isLoading.value = false;
      notifyListeners();
    }
  }

  void addUpdateButtonOnPressed(BuildContext context) async {
    HomeViewModel homeViewModel = HomeViewModel();
    if (formKey.currentState!.validate()) {
      switch (editType) {
        case EditType.add:
          homeViewModel.addTAndCData(textEditingController.text);
          Navigator.pop<ResponseType>(context, ResponseType.success);
          break;
        case EditType.update:
          homeViewModel.updateTAndCData(detail!.id, textEditingController.text);
          Navigator.pop<ResponseType>(context, ResponseType.success);
          break;
        default:
          break;
      }
    }
  }

  Future<bool> checkSpeechPermissionIsGranted(BuildContext context) async {
    Permission speechPermission = Permission.speech;
    PermissionStatus speechPermissionStatus = await speechPermission.status;
    switch (speechPermissionStatus) {
      case PermissionStatus.permanentlyDenied:
        if (!context.mounted) break;
        await showMicPermissionDialogBox(context);
        break;
      case PermissionStatus.granted:
        break;
      default:
        await speechPermission.request();
        break;
    }
    return speechPermission.isGranted;
  }

  showMicPermissionDialogBox(BuildContext context) async {
    return await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, _, __) {
        return AlertDialog(
          title: const Text('Allow App to record Microphone'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          content: const Text(
              'App will use your microphone to listen to voice commands'),
          actions: [
            Center(
              child: TextButton(
                child: const Text('GO TO APP SETTINGS'),
                onPressed: () async {
                  await openAppSettings();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String? tAndCFieldValidator(String? input) {
    if (input!.isEmpty) {
      return "can't be empty";
    } else if (editType == EditType.update &&
        input.isNotEmpty &&
        detail?.body == input) {
      return "can't be the same, update any changes";
    }
    return null;
  }

  void disposeAppUpdateBottomSheet() {
    textEditingController.dispose();
  }
}

class SpeechListeningDialogViewModel extends ChangeNotifier {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  void initialize() async {
    await _initSpeech();
    if (speechEnabled) {
      await startListening();
    }
  }

  Future<void> _initSpeech() async {
    speechEnabled = await speechToText.initialize();
    notifyListeners();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    notifyListeners();
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    debugPrint("completed");
    notifyListeners();
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }
}
