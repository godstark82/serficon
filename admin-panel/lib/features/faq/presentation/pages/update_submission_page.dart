import 'package:conference_admin/features/faq/data/models/faq_model.dart';
import 'package:conference_admin/features/faq/presentation/bloc/faq_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateSubmissionPage extends StatefulWidget {
  const UpdateSubmissionPage({super.key});

  @override
  State<UpdateSubmissionPage> createState() => _UpdateSubmissionPageState();
}

class _UpdateSubmissionPageState extends State<UpdateSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final List<QuestionAnswerPair> _questionAnswerPairs = [];

  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FaqBloc>().add(GetSubmissionProcessEvent());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    for (var pair in _questionAnswerPairs) {
      pair.questionController.dispose();
      pair.answerController.dispose();
    }
    super.dispose();
  }

  void _addNewQuestionAnswerPair() {
    setState(() {
      _questionAnswerPairs.add(
        QuestionAnswerPair(
          questionController: TextEditingController(),
          answerController: TextEditingController(),
        ),
      );
    });
  }

  void _removeQuestionAnswerPair(int index) {
    setState(() {
      final pair = _questionAnswerPairs[index];
      pair.questionController.dispose();
      pair.answerController.dispose();
      _questionAnswerPairs.removeAt(index);
    });
  }

  void _loadFaqData(FaqModel faqModel) {
    _descriptionController.text = faqModel.description;
    
    // Clear existing pairs
    for (var pair in _questionAnswerPairs) {
      pair.questionController.dispose();
      pair.answerController.dispose();
    }
    _questionAnswerPairs.clear();

    // Add pairs from loaded data
    for (var question in faqModel.questions) {
      _questionAnswerPairs.add(
        QuestionAnswerPair(
          questionController: TextEditingController(text: question.question),
          answerController: TextEditingController(text: question.answer),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Submission Guidelines'),
        elevation: 0,
      ),
      body: BlocConsumer<FaqBloc, FaqState>(
        listener: (context, state) {
          if (state is SubmissionProcessError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SubmissionProcessLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubmissionProcessLoaded && _questionAnswerPairs.isEmpty) {
            _loadFaqData(state.faqModel);
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Questions & Answers',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _questionAnswerPairs.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Question-Answer Pair ${index + 1}',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      if (_questionAnswerPairs.length > 1)
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _removeQuestionAnswerPair(index),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _questionAnswerPairs[index].questionController,
                                    decoration: InputDecoration(
                                      labelText: 'Question',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.help_outline),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a question';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _questionAnswerPairs[index].answerController,
                                    decoration: InputDecoration(
                                      labelText: 'Answer',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.question_answer_outlined),
                                    ),
                                    maxLines: 3,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an answer';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _addNewQuestionAnswerPair,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Another Question-Answer Pair'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final questions = _questionAnswerPairs.map((pair) {
                              return FaqQuestionModel(
                                question: pair.questionController.text,
                                answer: pair.answerController.text,
                              );
                            }).toList();

                            final faqModel = FaqModel(
                              id: '1',
                              description: _descriptionController.text,
                              questions: questions,
                            );

                            context
                                .read<FaqBloc>()
                                .add(UpdateSubmissionProcessEvent(faqModel: faqModel));
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Update Review Process',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuestionAnswerPair {
  final TextEditingController questionController;
  final TextEditingController answerController;

  QuestionAnswerPair({
    required this.questionController,
    required this.answerController,
  });
}
