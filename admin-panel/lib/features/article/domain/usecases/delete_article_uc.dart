import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/article/domain/repositories/article_repo.dart';

class DeleteArticleUC extends UseCase<void, String> {
  final ArticleRepository articleRepository;

  DeleteArticleUC(this.articleRepository);

  @override
  Future<void> call(String params) async {
    await articleRepository.deleteArticle(params);
  }
}
