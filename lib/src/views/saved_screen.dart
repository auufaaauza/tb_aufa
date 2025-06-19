import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tersimpan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Artikel Disimpan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildSavedItem(
                    "Artikel Tersimpan $index",
                    "Deskripsi singkat dari artikel tersimpan $index...",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedItem(String title, String description) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.bookmark, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.delete_outline, color: Colors.red),
        onTap: () {
          // Bisa navigasi ke detail artikel
        },
      ),
    );
  }
}
