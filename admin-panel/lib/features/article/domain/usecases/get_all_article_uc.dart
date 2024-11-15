

import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/domain/repositories/article_repo.dart';

class GetAllArticleUC extends UseCase<DataState<List<ArticleModel>>, void> {
  final ArticleRepository articleRepository;

  GetAllArticleUC(this.articleRepository);

  @override
  Future<DataState<List<ArticleModel>>> call(void params) async {
    return await articleRepository.getAllArticles();
  }
}
