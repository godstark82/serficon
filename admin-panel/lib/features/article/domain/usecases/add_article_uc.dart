import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/domain/repositories/article_repo.dart';

class AddArticleUC extends UseCase<void, ArticleModel> {
  final ArticleRepository articleRepository;

  AddArticleUC(this.articleRepository);

  @override
  Future<void> call(ArticleModel params) async {
    await articleRepository.addArticle(params);
  }
}
