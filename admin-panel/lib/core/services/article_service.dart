import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/article/data/models/article_model.dart';

class ArticleService {
  final firestore = FirebaseFirestore.instance;

  //! Get all articles
  Future<DataState<List<ArticleModel>>> getAllArticles() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('articles').get();
      List<ArticleModel> articles = querySnapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList();

      return DataSuccess(articles);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  // Article by Issue ID
  Future<DataState<List<ArticleModel>>> getArticleByIssueId(
      String issueId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('articles')
          .where('issueId', isEqualTo: issueId)
          .get();
      List<ArticleModel> articles = querySnapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList();
      return DataSuccess(articles);
    } catch (e) {
      log(e.toString());
      return DataFailed(e.toString());
    }
  }

  // Article by Volume ID
  Future<DataState<List<ArticleModel>>> getArticleByVolumeId(
      String volumeId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('articles')
          .where('volumeId', isEqualTo: volumeId)
          .get();
      List<ArticleModel> articles = querySnapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList();
      return DataSuccess(articles);
    } catch (e) {
      log(e.toString());
      return DataFailed(e.toString());
    }
  }

  // Article by Journal ID
  Future<DataState<List<ArticleModel>>> getArticleByJournalId(
      String journalId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('articles')
          .where('journalId', isEqualTo: journalId)
          .get();
      List<ArticleModel> articles = querySnapshot.docs
          .map((doc) => ArticleModel.fromJson(doc.data()))
          .toList();
      return DataSuccess(articles);
    } catch (e) {
      log(e.toString());
      return DataFailed(e.toString());
    }
  }

  //! Get article by id
  Future<DataState<ArticleModel>> getArticleById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestore.collection('articles').doc(id).get();
      return DataSuccess(ArticleModel.fromJson(docSnapshot.data()!));
    } catch (e) {
      log(e.toString());
      return DataFailed(e.toString());
    }
  }

  //! Add new Article
  Future<void> addArticle(ArticleModel article) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          await firestore.collection('articles').add({});

      article = article.copyWith(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        id: docRef.id,
      );

      await docRef.set(article.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  //! Update Article
  Future<void> updateArticle(ArticleModel article) async {
    try {
      article = article.copyWith(
        updatedAt: DateTime.now(),
      );
      await firestore
          .collection('articles')
          .doc(article.id)
          .update(article.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  //! Delete Article
  Future<void> deleteArticle(String id) async {
    try {
      await firestore.collection('articles').doc(id).delete();
    } catch (e) {
      log(e.toString());
    }
  }
}
