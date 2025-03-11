import 'package:flutter/material.dart';

void main() {
  runApp(const WordCounterApp());
}

class WordCounterApp extends StatelessWidget {
  const WordCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const WordCounterScreen(),
    );
  }
}

class WordCounterScreen extends StatefulWidget {
  const WordCounterScreen({super.key});

  @override
  _WordCounterScreenState createState() => _WordCounterScreenState();
}

class _WordCounterScreenState extends State<WordCounterScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<Map<String, int>>? _wordCountFuture;

  // Función para limpiar el texto (elimina tildes y caracteres especiales)
  String normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[^\w\s]'), '');
  }

  // Función asíncrona para contar palabras
  Future<Map<String, int>> _countWords() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulación de carga
    String text = _controller.text;
    String normalizedText = normalizeText(text);
    List<String> words = normalizedText.split(RegExp(r'\s+'));

    Map<String, int> wordMap = {};
    for (var word in words) {
      if (word.isNotEmpty) {
        wordMap[word] = (wordMap[word] ?? 0) + 1;
      }
    }
    return wordMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parcial Contador")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Escriba su párrafo aquí",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Color de fondo
            foregroundColor: Colors.white,  // Color del texto
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
              onPressed: () {
                setState(() {
                  _wordCountFuture = _countWords();
                });
              },
              child: const Text("Contar Palabras"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<Map<String, int>>(
                future: _wordCountFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Ocurrió un error"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No hay palabras aún"));
                  } else {
                    Map<String, int> wordCount = snapshot.data!;
                    return ListView.separated(
                      itemCount: wordCount.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        String key = wordCount.keys.elementAt(index);
                        return Card(
                          color: const Color.fromARGB(255, 63, 84, 99),
                          child: ListTile(
                            title: Text(
                              "$key: ${wordCount[key]}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            leading: const Icon(Icons.check_circle, color: Colors.orange),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
