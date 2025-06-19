import 'package:http/http.dart' as http;
import 'package:tb_aufa/src/models/news_model.dart';

class NewsService {
  static const String _baseUrl = 'https://rest-api-berita.vercel.app/api/v1';

  Future<NewsResponse> getArticles({int page = 1}) async {
    final response = await http.get(Uri.parse('$_baseUrl/articles?page=$page'));

    if (response.statusCode == 200) {
      return newsResponseFromJson(response.body);
    } else {
      throw Exception('Gagal memuat artikel');
    }
  }
}
