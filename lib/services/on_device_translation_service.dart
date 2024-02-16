import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class OnDeviceTranslationService {
  static final OnDeviceTranslationService _instance =
      OnDeviceTranslationService._internal();

  factory OnDeviceTranslationService() => _instance;

  OnDeviceTranslationService._internal();

  Future<String> translateText(
    String text, {
    TranslateLanguage? sourceLanguage,
    TranslateLanguage? targetLanguage,
  }) async {
    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage ?? TranslateLanguage.english,
      targetLanguage: targetLanguage ?? TranslateLanguage.hindi,
    );
    final modelManager = OnDeviceTranslatorModelManager();

    final bool isEnglishModelDownloaded =
        await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);
    // debugPrint('isEnglishModelDownloaded:\t$isEnglishModelDownloaded');
    if (!isEnglishModelDownloaded) {
      final bool response =
          await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
      // debugPrint('isEnglishModelDownloadedResponse:\t$response');
    }
    final bool isHindiModelDownloaded =
        await modelManager.isModelDownloaded(TranslateLanguage.hindi.bcpCode);
    // debugPrint('isHindiModelDownloaded:\t$isHindiModelDownloaded');
    if (!isHindiModelDownloaded) {
      final bool response =
          await modelManager.downloadModel(TranslateLanguage.hindi.bcpCode);
      // debugPrint('isHindiModelDownloadedResponse:\t$response');
    }

    final String translatedText = await onDeviceTranslator.translateText(text);
    // debugPrint('translatedText:\t$translatedText');
    await onDeviceTranslator.close();
    return translatedText;
  }
}
