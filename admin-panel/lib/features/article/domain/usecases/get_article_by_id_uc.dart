import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/domain/repositories/article_repo.dart';

class GetArticleByIdUC extends UseCase<DataState<ArticleModel>, String> {
  final ArticleRepository articleRepository;

  GetArticleByIdUC(this.articleRepository);

  @override
  Future<DataState<ArticleModel>> call(String params) async {
    return await articleRepository.getArticleById(params);
  }
}
