import 'dart:async';
import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/presentation/bloc/article_bloc.dart';
import 'package:conference_admin/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<ArticleBloc>().add(GetAllArticleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) {
        if (state is AllArticleLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllArticleLoadedState) {
          List<ArticleModel> filteredArticles = state.articles;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Articles'),
              backgroundColor: Colors.blue,
            ),
            body: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (filteredArticles.isEmpty) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.article_outlined,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No articles created by you yet',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('Start by creating a new article'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Create New Article'),
                            onPressed: () async {
                              await Get.toNamed(
                                  Routes.dashboard + Routes.addArticle);
                              _loadData();
                            },
                          )
                        ]),
                  );
                }
                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  return _buildDesktopLayout(filteredArticles, context);
                } else {
                  return _buildMobileLayout(filteredArticles);
                }
              },
            ),
          );
        } else if (state is ArticleErrorState) {
          return Center(child: SelectableText('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildDesktopLayout(
      List<ArticleModel> articles, BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Table(
            columnWidths: const {
              0: FlexColumnWidth(2), // Title
              1: FlexColumnWidth(1.5), // Authors
              2: FlexColumnWidth(1.5), // Abstract
              3: FlexColumnWidth(1), // Status
              4: FlexColumnWidth(1), // Publication Date
              5: FlexColumnWidth(1), // PDF URL
              6: FlexColumnWidth(1), // Keywords
              7: FlexColumnWidth(1), // Actions
            },
            border: TableBorder.all(color: Colors.grey[300]!),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.blue[100]),
                children: [
                  _buildTableHeader('Title'),
                  _buildTableHeader('Authors'),
                  _buildTableHeader('Abstract'),
                  _buildTableHeader('Status'),
                  _buildTableHeader('Publication Date'),
                  _buildTableHeader('PDF'),
                  _buildTableHeader('Keywords'),
                  _buildTableHeader('Actions'),
                ],
              ),
              ...articles.map((article) => TableRow(
                    children: [
                      _buildTableCell(Text(article.articleTitle)),
                      _buildTableCell(Text(article.additionalAuthors
                          .map((author) => author.name)
                          .join(', '))),
                      _buildTableCell(Text(article.abstractText)),
                      _buildTableCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(article.status.value),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article.status.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      _buildTableCell(Text(DateFormat('dd/MMMM/yyyy')
                          .format(article.createdAt))),
                      _buildTableCell(
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf),
                          onPressed: () async {
                            if (await canLaunchUrl(Uri.parse(article.pdfUrl))) {
                              await launchUrl(Uri.parse(article.pdfUrl));
                            }
                          },
                        ),
                      ),
                      _buildTableCell(Text(article.keywords)),
                      _buildTableCell(
                        PopupMenuButton<String>(
                          onSelected: (String result) {
                            switch (result) {
                              case 'view':
                                viewArticleDetails(article);
                                break;
                              case 'delete':
                                deleteArticle(article.id);
                                break;
                              case 'update':
                                updateStatus(article);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'view',
                              child: ListTile(
                                leading:
                                    Icon(Icons.visibility, color: Colors.blue),
                                title: Text('View Details'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'update',
                              child: ListTile(
                                leading:
                                    Icon(Icons.update, color: Colors.purple),
                                title: Text('Update Status'),
                              ),
                            ),
                          ],
                          child: const Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTableCell(Widget content) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      ),
    );
  }

  Widget _buildMobileLayout(List<ArticleModel> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(article.title),
            children: [
              ListTile(
                title: const Text('Abstract:'),
                subtitle: Text(article.abstractText),
              ),
              ListTile(
                title: const Text('Authors:'),
                subtitle: Text(article.additionalAuthors
                    .map((author) => author.name)
                    .join(', ')),
              ),
              ListTile(
                title: const Text('Keywords:'),
                subtitle: Text(article.keywords),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Text('Status: '),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(article.status.value),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.status.value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Publication Date:'),
                subtitle:
                    Text(DateFormat('dd/MMMM/yyyy').format(article.createdAt)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.purple),
                    onPressed: () {
                      viewArticleDetails(article);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await editArticle(article.id);
                      _loadData();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteArticle(article.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.update, color: Colors.orange),
                    onPressed: () {
                      updateStatus(article);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(article.pdfUrl))) {
                        await launchUrl(Uri.parse(article.pdfUrl));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> editArticle(String id) async {
    await Get.toNamed(Routes.dashboard + Routes.editArticle,
        parameters: {'articleId': id});
  }

  void viewArticleDetails(ArticleModel article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.articleTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(Icons.person, 'Author Name', article.name),
                  _buildDetailRow(Icons.email, 'Email', article.email),
                  _buildDetailRow(Icons.title, 'Title', article.title),
                  _buildDetailRow(
                      Icons.description, 'Document Type', article.documentType),
                  _buildDetailRow(
                      Icons.business, 'Affiliation', article.affiliation),
                  _buildDetailRow(Icons.topic, 'Topic Type', article.topicType),
                  _buildDetailRow(Icons.article, 'Paper Types',
                      article.paperType.join(", ")),
                  _buildDetailRow(
                    Icons.flag,
                    'Status',
                    article.status.value,
                    color: _getStatusColor(article.status.value),
                  ),
                  _buildDetailRow(Icons.calendar_today, 'Created Date',
                      DateFormat('dd/MMMM/yyyy').format(article.createdAt)),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Authors:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...article.additionalAuthors
                      .map((author) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• Name: ${author.name}'),
                              Text('  Affiliation: ${author.affiliation}'),
                              Text('  Email: ${author.email}'),
                              Text(
                                  '  Corresponding Author: ${author.isCorresponding ? 'Yes' : 'No'}'),
                              const SizedBox(height: 10),
                            ],
                          ))
                      ,
                  const SizedBox(height: 20),
                  const Text(
                    'Abstract:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(article.abstractText),
                  const SizedBox(height: 20),
                  const Text(
                    'Keywords:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(article.keywords),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text('Download PDF',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (await canLaunchUrl(Uri.parse(article.pdfUrl))) {
                            await launchUrl(Uri.parse(article.pdfUrl));
                          } else {
                            if (kDebugMode) {
                              print('Could not launch ${article.pdfUrl}');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Close',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: '$label: ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value, style: TextStyle(color: color)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateStatus(ArticleModel article) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newStatus = article.status.value;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Update Status for ${article.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current Status: ${article.status.value}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: newStatus,
                    isExpanded: true,
                    items: <String>['published', 'pending', 'rejected']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: _getStatusColor(value),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          newStatus = value;
                        });
                      }
                    },
                    dropdownColor: Colors.grey[200],
                    elevation: 8,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: _getStatusColor(newStatus),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(newStatus),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // Update the article status
                    final newArticle = article.copyWith(
                        status: ArticleStatus.values.byName(newStatus));
                    context
                        .read<ArticleBloc>()
                        .add(EditArticleEvent(article: newArticle));

                    Navigator.of(context).pop();
                    _loadData(); // Reload data after updating status
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteArticle(String articleId) async {
    // Create a timer to enable the delete button after 5 seconds
    bool isDeleteEnabled = false;
    int remainingSeconds = 5;
    Timer? deleteTimer;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            deleteTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() {
                if (remainingSeconds > 0) {
                  remainingSeconds--;
                } else {
                  isDeleteEnabled = true;
                  timer.cancel();
                }
              });
            });
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 10),
                  Text('Confirm Deletion'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you sure you want to delete this article? '
                    'This action cannot be undone.',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isDeleteEnabled
                        ? 'You can now delete the article.'
                        : 'Please wait $remainingSeconds seconds before deleting.',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    deleteTimer?.cancel();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDeleteEnabled ? Colors.red : Colors.grey,
                  ),
                  onPressed: isDeleteEnabled
                      ? () {
                          // Delete the article
                          context
                              .read<ArticleBloc>()
                              .add(DeleteArticleEvent(id: articleId));
                          // Close the dialog
                          Navigator.of(context).pop();
                          _loadData(); // Reload data after deleting
                        }
                      : null,
                  child: Text(
                    isDeleteEnabled ? 'Delete' : 'Delete ($remainingSeconds)',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
