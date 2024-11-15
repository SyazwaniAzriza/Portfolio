import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final List<Map<String, String>> translationHistory;
  final List<Map<String, String>> savedTranslations;

  const History({
    Key? key,
    required this.translationHistory,
    required this.savedTranslations,
  }) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  void _toggleSave(Map<String, String> translation) {
    setState(() {
      bool isFavorite = translation['isFavorite'] == 'true';
      isFavorite = !isFavorite;

      // Update the map to store the boolean as a string
      translation['isFavorite'] = isFavorite ? 'true' : 'false';
      if (isFavorite) {
        // Add to savedTranslations if it's not already there
        if (!widget.savedTranslations.any((savedTranslation) =>
            savedTranslation['input'] == translation['input'] &&
            savedTranslation['output'] == translation['output'])) {
          widget.savedTranslations.add({
            'input': translation['input'] ?? '',
            'output': translation['output'] ?? '',
            'isFavorite': 'true',
          });
        }
      } else {
        // Remove from savedTranslations if present
        widget.savedTranslations.removeWhere((savedTranslation) =>
            savedTranslation['input'] == translation['input'] &&
            savedTranslation['output'] == translation['output']);
      }

      // Update the translationHistory
      int index = widget.translationHistory.indexOf(translation);
      if (index != -1) {
        widget.translationHistory[index]['isFavorite'] =
            isFavorite ? 'true' : 'false';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Translation History",
          style: TextStyle(color: Color.fromARGB(255, 3, 237, 233)),
        ),
      ),
      backgroundColor: Colors.black,
      body: widget.translationHistory.isEmpty
          ? Center(
              child: Text(
                "No translations yet",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: widget.translationHistory.length,
              itemBuilder: (context, index) {
                final translation = widget.translationHistory[index];
                bool isFavorite = translation['isFavorite'] == 'true';

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
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                _toggleSave(translation);
                              },
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
