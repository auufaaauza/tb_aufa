import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tb_aufa/src/controller/news_controller.dart';
import 'package:tb_aufa/src/models/news_model.dart';
import 'package:tb_aufa/src/provider/auth_provider.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String articleId;

  const ArticleDetailScreen({Key? key, required this.articleId})
    : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late Future<NewsArticle> _articleFuture;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _articleFuture = fetchArticleDetails(widget.articleId);
    _checkBookmarkStatus(widget.articleId);
  }

  Future<NewsArticle> fetchArticleDetails(String articleId) async {
    final newsService = NewsService();
    return await newsService.fetchArticleById(articleId);
  }

  Future<void> _checkBookmarkStatus(String articleId) async {
    final newsService = NewsService();
    try {
      final isSaved = await newsService.checkBookmarkStatus(articleId);
      if (mounted) {
        setState(() {
          _isBookmarked = isSaved;
        });
      }
    } catch (e) {
      // Ignore error or show message
    }
  }

  Future<void> _toggleBookmark(String articleId) async {
    final newsService = NewsService();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      if (_isBookmarked) {
        await newsService.removeBookmark(articleId);
      } else {
        await newsService.addBookmark(articleId);
      }

      setState(() {
        _isBookmarked = !_isBookmarked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked
                ? "Artikel disimpan"
                : "Artikel dihapus dari simpanan",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengubah status simpan: $e")),
      );
    }
  }

  Future<void> _deleteArticle(String articleId) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Artikel"),
        content: const Text("Yakin ingin menghapus artikel ini?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final newsService = NewsService();
      try {
        await newsService.deleteArticle(articleId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Artikel berhasil dihapus")),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menghapus artikel: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Artikel"),
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => _toggleBookmark(widget.articleId),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<NewsArticle>(
          future: _articleFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final article = snapshot.data!;
              final isOwner =
                  authProvider.isAuthenticated &&
                  article.author.name == authProvider.currentUser?.name;

              return ListView(
                children: [
                  // Judul Artikel
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gambar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(article.imageUrl, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 16),

                  // Konten Artikel
                  Text(article.content, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 24),

                  // Info Penulis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              article.author.avatar,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(article.author.name),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16),
                          const SizedBox(width: 4),
                          Text(article.readTime),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tombol Edit/Delete (hanya muncul jika pengguna adalah pemilik artikel)
                  if (isOwner)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Nanti bisa dialihkan ke halaman edit
                              // Navigator.pushNamed(context, '/edit-article', arguments: article.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Edit Artikel")),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _deleteArticle(article.id),
                            icon: const Icon(Icons.delete),
                            label: const Text("Hapus"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            } else {
              return const Center(child: Text("Artikel tidak ditemukan."));
            }
          },
        ),
      ),
    );
  }
}
