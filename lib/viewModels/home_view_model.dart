import "package:flutter/material.dart";
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

  Map<String, dynamic> _tAndCData = {
    "details": [
      {
        "id": 11989,
        "value": "1 Year Service Warranty & 5 Years Plywood Warranty",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11990,
        "value":
            "Customer Should inform about the Changes (if any Design & colour) before\nproduction or else Customer should pay Extra",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11991,
        "value":
            "Material will be delivered 3-4 weeks the date of Confirmation of Order",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11992,
        "value":
            "Quotation cant be changed / revised once accepted by the customer",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11993,
        "value":
            "If any extra works are needed then it should be paid by customer",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11994,
        "value":
            "Custom Handles will be charged extra.Handle price may vary based of designs &\nspecifications",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11995,
        "value": "Once the Project is confirmed, the amount cannot be refunded",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11996,
        "value": "This Quote will be valid only for 15 Days",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      },
      {
        "id": 11997,
        "value":
            "Any additional work which is out of the quotation in any aspects is to be paid extra by\nthe customer",
        "createdAt": "2024-01-06 12:08:11",
        "updatedAt": "2024-01-06 12:08:11"
      }
    ]
  };

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
      await Future.delayed(const Duration(seconds: 3));
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
    int previousId = details.last.id;
    details.add(
      tacm.Detail(
        id: previousId + 1,
        value: value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    tAndCData = tacm.TermsAndConditionsModel(details: details);
  }

  updateTAndCData(int id, String value) {
    tacm.TermsAndConditionsModel data = tAndCData;
    data.details.map((e) {
      if (e.id == id) {
        e
          ..value = value
          ..updatedAt = DateTime.now();
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
        await OnDeviceTranslationService().translateText(detail.value);
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
        textEditingController.text = detail?.value ?? '';
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
        detail?.value == input) {
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
