part of '../home_screen.dart';

class _SpeechListeningDialog extends StatefulWidget {
  const _SpeechListeningDialog();

  @override
  State<_SpeechListeningDialog> createState() => _SpeechListeningDialogState();
}

class _SpeechListeningDialogState extends State<_SpeechListeningDialog> {
  @override
  void initState() {
    _speechListeningDialogViewModel =
        Provider.of<SpeechListeningDialogViewModel>(context, listen: false);
    _speechListeningDialogViewModel.initialize();
    super.initState();
  }

  late SpeechListeningDialogViewModel _speechListeningDialogViewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechListeningDialogViewModel>(
        builder: (context, speechListeningDialogViewModel, _) {
      return SimpleDialog(
        title: (speechListeningDialogViewModel.speechToText.isListening)
            ? const Text('Listening...')
            : Container(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        children: [
          (speechListeningDialogViewModel.speechToText.isListening ||
                  speechListeningDialogViewModel.speechToText.hasRecognized)
              ? Text(speechListeningDialogViewModel.lastWords)
              : (speechListeningDialogViewModel.speechEnabled
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15.0),
                          ),
                          onPressed: () =>
                              speechListeningDialogViewModel.startListening(),
                          child: const Icon(
                            Icons.mic,
                            size: 30.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Tap to speak'),
                      ],
                    )
                  : const Text('Speech not available')),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:
                (speechListeningDialogViewModel.speechToText.isNotListening)
                    ? () {
                        speechListeningDialogViewModel.stopListening();
                        Navigator.of(context)
                            .pop(speechListeningDialogViewModel.lastWords);
                      }
                    : null,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.green,
              padding: const EdgeInsets.all(8.0),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
