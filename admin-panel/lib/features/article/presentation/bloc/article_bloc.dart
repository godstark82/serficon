import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/domain/usecases/add_article_uc.dart';
import 'package:conference_admin/features/article/domain/usecases/delete_article_uc.dart';
import 'package:conference_admin/features/article/domain/usecases/edit_article_uc.dart';
import 'package:conference_admin/features/article/domain/usecases/get_all_article_uc.dart';
import 'package:conference_admin/features/article/domain/usecases/get_article_by_id_uc.dart';
import 'package:equatable/equatable.dart';
part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetAllArticleUC getAllArticleUC;
  final GetArticleByIdUC getArticleByIdUC;
  final AddArticleUC addArticleUC;
  final EditArticleUC editArticleUC;
  final DeleteArticleUC deleteArticleUC;

  ArticleBloc(
    this.getAllArticleUC,
    this.getArticleByIdUC,
    this.addArticleUC,
    this.editArticleUC,
    this.deleteArticleUC,
  ) : super(ArticleInitial()) {
    //
    on<GetAllArticleEvent>(_onGetAllArticleEvent);
    on<GetArticleByIdEvent>(_onGetArticleByIdEvent);
    on<AddArticleEvent>(_onAddArticleEvent);
    on<EditArticleEvent>(_onEditArticleEvent);
    on<DeleteArticleEvent>(_onDeleteArticleEvent);
  }

  Future<void> _onGetAllArticleEvent(
      GetAllArticleEvent event, Emitter<ArticleState> emit) async {
    emit(AllArticleLoadingState());
    final result = await getAllArticleUC.call(null);
    if (result is DataSuccess) {
      emit(AllArticleLoadedState(articles: result.data!));
    } else if (result is DataFailed) {
      emit(ArticleErrorState(message: result.message!));
    }
  }

  Future<void> _onGetArticleByIdEvent(
      GetArticleByIdEvent event, Emitter<ArticleState> emit) async {
    emit(ArticleByIdLoadingState());
    final result = await getArticleByIdUC.call(event.id);
    if (result is DataSuccess) {
      emit(ArticleByIdLoadedState(article: result.data!));
    } else if (result is DataFailed) {
      emit(ArticleErrorState(message: result.message!));
    }
  }

  Future<void> _onAddArticleEvent(
      AddArticleEvent event, Emitter<ArticleState> emit) async {
    await addArticleUC.call(event.article);
    add(GetAllArticleEvent());
  }

  Future<void> _onEditArticleEvent(
      EditArticleEvent event, Emitter<ArticleState> emit) async {
    await editArticleUC.call(event.article);
    add(GetAllArticleEvent());
  }

  Future<void> _onDeleteArticleEvent(
      DeleteArticleEvent event, Emitter<ArticleState> emit) async {
    await deleteArticleUC.call(event.id);
    add(GetAllArticleEvent());
  }
}
