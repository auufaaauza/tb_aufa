import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tb_aufa/src/models/news_model.dart';
import 'package:tb_aufa/src/controller/news_controller.dart';
import 'package:tb_aufa/src/provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();

  Future<List<NewsArticle>> _fetchLatestArticles() async {
    try {
      final response = await _newsService.fetchNews(
        "https://rest-api-berita.vercel.app/api/v1/news",
      );
      if (response.success && response.data?.articles != null) {
        return response.data!.articles;
      } else {
        throw Exception("Tidak ada artikel ditemukan");
      }
    } catch (e) {
      rethrow;
    }
  }

  Widget _buildArticleCard(NewsArticle article) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            if (article.id != null) {
              Navigator.pushNamed(
                context,
                '/article-detail',
                arguments: article.id,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gagal membuka detail artikel")),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: (article.imageUrl ?? '').isEmpty
                    ? Image.asset(
                        'assets/images/default_image.png', // Pastikan path benar
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 60,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        article.category ?? "Umum",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title ?? "Tanpa Judul",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.content.length > 120
                          ? '${article.content.substring(0, 120)}...'
                          : article.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundImage: AssetImage(
                                'assets/images/avatar.png',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              article.author?.name ?? "Penulis Tidak Diketahui",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              article.readTime ?? "N/A",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              Text(
                "Artikel Terbaru",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<NewsArticle>>(
                  future: _fetchLatestArticles(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Gagal memuat artikel: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildArticleCard(snapshot.data![index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("Belum ada artikel tersedia."),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
