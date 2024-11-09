import 'package:conference_admin/features/faq/presentation/bloc/faq_bloc.dart';
import 'package:conference_admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewProcessPage extends StatefulWidget {
  const ReviewProcessPage({super.key});

  @override
  State<ReviewProcessPage> createState() => _ReviewProcessPageState();
}

class _ReviewProcessPageState extends State<ReviewProcessPage> {
  @override
  void initState() {
    context.read<FaqBloc>().add(GetReviewProcessEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Review Process'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigator.pushNamed(context, '/edit-review-process');
              Get.toNamed(Routes.dashboard + Routes.updateReview);
            },
          ),
        ],
      ),
      body: BlocBuilder<FaqBloc, FaqState>(
        builder: (context, state) {
          if (state is ReviewProcessLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReviewProcessError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ReviewProcessLoaded) {
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.description_outlined,
                                    size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  'Description',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.faqModel.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.question_answer_outlined, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            'Frequently Asked Questions',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.faqModel.questions.length,
                      itemBuilder: (context, index) {
                        final process = state.faqModel.questions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              childrenPadding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 24,
                              ),
                              title: Text(
                                process.question,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              leading: const Icon(Icons.help_outline),
                              children: [
                                Text(
                                  process.answer,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        height: 1.5,
                                        color: Colors.black87,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
