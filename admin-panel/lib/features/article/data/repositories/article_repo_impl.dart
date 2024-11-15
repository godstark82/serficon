import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/services/article_service.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/domain/repositories/article_repo.dart';

class ArticleRepoImpl implements ArticleRepository {
  final ArticleService articleService;

  ArticleRepoImpl(this.articleService);

  @override
  Future<void> addArticle(ArticleModel article) async {
    return await articleService.addArticle(article);
  }

  @override
  Future<void> deleteArticle(String id) async {
    return await articleService.deleteArticle(id);
  }

  @override
  Future<DataState<List<ArticleModel>>> getAllArticles() async {
    return await articleService.getAllArticles();
  }

  @override
  Future<DataState<ArticleModel>> getArticleById(String id) async {
    return await articleService.getArticleById(id);
  }

  @override
  Future<void> updateArticle(ArticleModel article) async {
    return await articleService.updateArticle(article);
  }
}
