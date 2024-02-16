import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class OnDeviceTranslationService {
  static final OnDeviceTranslationService _instance =
      OnDeviceTranslationService._internal();

  factory OnDeviceTranslationService() => _instance;

  OnDeviceTranslationService._internal();

  final TranslateLanguage _sourceLanguage = TranslateLanguage.english;
  final TranslateLanguage _targetLanguage = TranslateLanguage.hindi;

  void initialize() {
    downloadLanguages();
  }

  Future<void> downloadLanguages() async {
    final modelManager = OnDeviceTranslatorModelManager();
    try {
      final bool isSourceLanguageDownloaded =
          await modelManager.downloadModel(_sourceLanguage.bcpCode);
      debugPrint('isSourceLanguageDownloaded:\t$isSourceLanguageDownloaded');

      final bool isTargetLanguageDownloaded =
          await modelManager.downloadModel(_targetLanguage.bcpCode);
      debugPrint('isTargetLanguageDownloaded:\t$isTargetLanguageDownloaded');
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> translateText(String text) async {
    String? translatedText;
    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
    );

    try {
      translatedText = await onDeviceTranslator.translateText(text);
      debugPrint('translatedText:\t$translatedText');
      await onDeviceTranslator.close();
    } catch (e) {
      rethrow;
    }

    return translatedText;
  }
}
