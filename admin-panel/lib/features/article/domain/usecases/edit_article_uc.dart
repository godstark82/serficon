
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/domain/repositories/article_repo.dart';

class EditArticleUC extends UseCase<void, ArticleModel> {
  final ArticleRepository articleRepository;

  EditArticleUC(this.articleRepository);

  @override
  Future<void> call(ArticleModel params) async {
    await articleRepository.updateArticle(params);
  }
}
