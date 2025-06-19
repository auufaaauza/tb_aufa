import 'package:flutter/material.dart';
import 'package:tb_aufa/src/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:tb_aufa/src/models/news_model.dart';
import 'package:tb_aufa/src/views/news_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      final response = await _newsService.getArticles();
      setState(() {
        _articles = response.data.articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat artikel: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Beranda")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selamat Datang
              Text(
                "Selamat Datang,",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (authProvider.isAuthenticated)
                Text(
                  "${authProvider.currentUser?.name ?? 'Pengguna'}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),

              const SizedBox(height: 24),

              // Judul Artikel Terbaru
              Text(
                "Artikel Terbaru",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Daftar Artikel
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_articles.isEmpty)
                const Text("Belum ada artikel tersedia.")
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return _buildArticleCard(article);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(NewsArticle article) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigasi ke detail artikel
          // Navigator.pushNamed(context, '/article/${article.id}');
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: article.imageUrl.isNotEmpty
                    ? Image.network(article.imageUrl, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 40),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.content.length > 80
                          ? '${article.content.substring(0, 80)}...'
                          : article.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.category,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "${article.readTime} min read",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
