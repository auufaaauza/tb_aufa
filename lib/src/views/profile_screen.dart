import 'package:flutter/material.dart';
import 'package:tb_aufa/src/provider/auth_provider.dart';
import 'package:tb_aufa/src/models/auth_model.dart'; // <-- import User dari sini
import 'package:tb_aufa/src/models/news_model.dart'; // <-- import NewsArticle dari sini
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final User? user = authProvider.currentUser;

    // Dummy list of articles - nanti diganti dengan API call
    final List<NewsArticle> allArticles = [
      NewsArticle(
        id: "1",
        title: "Cara Hidup Sehat",
        category: "Kesehatan",
        publishedAt: "2024-04-01",
        readTime: "5 min",
        imageUrl: "https://picsum.photos/200/300",
        isTrending: true,
        tags: ["sehat", "tips"],
        content: "Isi artikel tentang hidup sehat...",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        author: Author(
          name: user?.name ?? "Penulis",
          title: user?.title ?? "Pengguna",
          avatar: user?.avatar ?? "",
        ),
      ),
      NewsArticle(
        id: "2",
        title: "Tips Diet Alami",
        category: "Gaya Hidup",
        publishedAt: "2024-04-02",
        readTime: "7 min",
        imageUrl: "https://picsum.photos/200/301",
        isTrending: false,
        tags: ["diet", "hidup sehat"],
        content: "Isi tips diet alami...",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        author: Author(
          name: user?.name ?? "Penulis",
          title: user?.title ?? "Pengguna",
          avatar: user?.avatar ?? "",
        ),
      ),
    ];

    // Filter artikel berdasarkan penulis
    final List<NewsArticle> userArticles = allArticles
        .where((article) => article.author.name == user?.name)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  backgroundImage: user?.avatar != null
                      ? NetworkImage(user!.avatar)
                      : null,
                  child: user?.avatar == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 16),

                // Nama
                Text(
                  user?.name ?? 'Nama Tidak Ditemukan',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Email
                Text(
                  user?.email ?? 'Email Tidak Ditemukan',
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 4),

                // Title / Jabatan
                Text(
                  user?.title ?? 'Belum ada jabatan',
                  style: const TextStyle(color: Colors.blue),
                ),

                const SizedBox(height: 24),

                // Tombol Edit Profil
                ElevatedButton.icon(
                  onPressed: () {
                    // Ganti ke halaman edit profil
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                ),

                const SizedBox(height: 32),

                // Judul Artikel
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Artikel yang Ditulis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                // Daftar Artikel
                if (userArticles.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userArticles.length,
                    itemBuilder: (context, index) {
                      final article = userArticles[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              article.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(article.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kategori: ${article.category}"),
                              Text("Waktu baca: ${article.readTime}"),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to article detail
                            // Navigator.pushNamed(context, '/article-detail', arguments: article);
                          },
                        ),
                      );
                    },
                  )
                else
                  const Text("Belum ada artikel ditulis."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
