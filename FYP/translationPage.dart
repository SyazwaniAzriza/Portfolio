import 'package:flutter/material.dart';
import 'translationCode.dart'; // Assuming this is where your translatePythonToCpp function is defined

class TranslationPage extends StatefulWidget {
  final List<Map<String, String>> translationHistory;
  final List<Map<String, String>> savedTranslations;

  const TranslationPage({
    Key? key,
    required this.translationHistory,
    required this.savedTranslations,
  }) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  TextEditingController _controller = TextEditingController();
  String _translatedCode = "";
  bool _isSaved = false;

  void _translateCode() {
    setState(() {
      _translatedCode = translatePythonToCpp(_controller.text);
      bool existsInHistory = false;
      // Ensure every translation is added to the history
      for (var translation in widget.translationHistory) {
        if (translation['input'] == _controller.text &&
            translation['output'] == _translatedCode) {
          existsInHistory = true;
          break;
        }
      }

      if (!existsInHistory) {
        widget.translationHistory.add({
          'input': _controller.text,
          'output': _translatedCode,
          'isFavorite': 'false',
        });
      }
    });
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;

      if (_isSaved) {
        widget.savedTranslations.add({
          'input': _controller.text,
          'output': _translatedCode,
          'isFavorite': 'true',
        });
      } else {
        widget.savedTranslations.removeWhere((savedTranslation) =>
            savedTranslation['input'] == _controller.text &&
            savedTranslation['output'] == _translatedCode);
      }

      // Update translationHistory to reflect the favorite status
      for (var translation in widget.translationHistory) {
        if (translation['input'] == _controller.text &&
            translation['output'] == _translatedCode) {
          translation['isFavorite'] = _isSaved ? 'true' : 'false';
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Python to C++ Translator',
          style: TextStyle(color: Color.fromARGB(255, 3, 237, 233)),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 10,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Python code here',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateCode,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 3, 237, 233)),
              child: Text(
                "Translate to C++",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Translated C++ code:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 3, 237, 233)),
                ),
                IconButton(
                  icon: Icon(
                    _isSaved ? Icons.favorite : Icons.favorite_border,
                    color: _isSaved ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleSave, // Toggle save when icon is pressed
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _translatedCode.isEmpty
                      ? 'Translation will appear here'
                      : _translatedCode,
                  style:
                      TextStyle(fontFamily: 'monospace', color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
