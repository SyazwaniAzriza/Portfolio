import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  final List<Map<String, String>> savedTranslations;
  final List<Map<String, String>> translationHistory;

  const SavedPage({
    Key? key,
    required this.savedTranslations,
    required this.translationHistory,
  }) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  void _undoSave(Map<String, String> translation) {
    setState(() {
      widget.savedTranslations.remove(translation);

      // Update the translationHistory
      for (var item in widget.translationHistory) {
        if (item['input'] == translation['input'] &&
            item['output'] == translation['output']) {
          item['isFavorite'] = 'false';
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
          "Saved Translations",
          style: TextStyle(color: Color.fromARGB(255, 3, 237, 233)),
        ),
      ),
      backgroundColor: Colors.black,
      body: widget.savedTranslations.isEmpty
          ? Center(
              child: Text(
                "No saved translations yet",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: widget.savedTranslations.length,
              itemBuilder: (context, index) {
                final translation = widget.savedTranslations[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: Colors.grey[850],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Python Code:",
                            style: TextStyle(
                                color: Color.fromARGB(255, 3, 237, 233)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            translation['input'] ?? '',
                            style: TextStyle(
                                fontFamily: 'monospace', color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "C++ Translation:",
                            style: TextStyle(
                                color: Color.fromARGB(255, 3, 237, 233)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            translation['output'] ?? '',
                            style: TextStyle(
                                fontFamily: 'monospace', color: Colors.white),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => _undoSave(
                                  translation), // Remove the saved translation
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
