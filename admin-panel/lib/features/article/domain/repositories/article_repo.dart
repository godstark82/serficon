import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';
abstract class ArticleRepository {
  Future<DataState<ArticleModel>> getArticleById(String id);
  Future<DataState<List<ArticleModel>>> getAllArticles();
  Future<void> addArticle(ArticleModel article);
  Future<void> updateArticle(ArticleModel article);
  Future<void> deleteArticle(String id);
  
}
