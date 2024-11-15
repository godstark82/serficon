import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../bloc/home_bloc.dart';
import '../../data/models/home_models_others.dart';
import '../widgets/edit_dialoges.dart';
import '../widgets/sections.dart';
import 'package:html/parser.dart' show parse;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String stripHtml(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Management'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            Get.snackbar('Error', state.message);
          }
          if (state is HomeLoaded) {
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Section
                      SectionWidget(
                          title: 'Hero Section',
                          children: [
                            InfoRow(
                                label: 'Content',
                                value: stripHtml(
                                    state.homeModel.hero.htmlContent)),
                            InfoRow(
                                label: 'Image URL',
                                value:
                                    state.homeModel.hero.image ?? 'No image'),
                            if (state.homeModel.hero.image != null)
                              InfoRow(
                                  label: 'Show Image',
                                  value: state.homeModel.hero.showImage
                                      .toString()),
                          ],
                          onEdit: () => showDialog(
                                context: context,
                                builder: (context) => EditDialog(
                                  title: 'Hero Section',
                                  fields: {
                                    'Content': state.homeModel.hero.htmlContent,
                                    'Image URL':
                                        state.homeModel.hero.image ?? '',
                                    'Show Image':
                                        state.homeModel.hero.showImage,
                                  },
                                  onSave: (values) {
                                    final hero = HomeHeroModel(
                                      htmlContent: values['Content']!,
                                      image: values['Image URL'],
                                      showImage: values['Show Image'] == true,
                                    );
                                    context
                                        .read<HomeBloc>()
                                        .add(UpdateHeroEvent(hero));
                                  },
                                ),
                              )),

                      const SizedBox(height: 24),

                      // President Welcome
                      SectionWidget(
                        title: 'President Welcome',
                        children: [
                          InfoRow(
                              label: 'Title',
                              value: state.homeModel.presidentWelcome.title),
                          InfoRow(
                              label: 'Content',
                              value: stripHtml(state
                                  .homeModel.presidentWelcome.htmlContent)),
                          // Text(stripHtml(state.homeModel.presidentWelcome.htmlContent)),
                          InfoRow(
                              label: 'Image URL',
                              value: state.homeModel.presidentWelcome.image ??
                                  'No image'),
                          if (state.homeModel.presidentWelcome.image != null)
                            InfoRow(
                                label: 'Show Image',
                                value: state
                                    .homeModel.presidentWelcome.showImage
                                    .toString()),
                        ],
                        onEdit: () => showDialog(
                          context: context,
                          builder: (context) => EditDialog(
                            title: 'President Welcome',
                            fields: {
                              'Title': state.homeModel.presidentWelcome.title,
                              'Content':
                                  state.homeModel.presidentWelcome.htmlContent,
                              'Image URL':
                                  state.homeModel.presidentWelcome.image ?? '',
                              'Show Image': 
                                  state.homeModel.presidentWelcome.showImage,
                            },
                            onSave: (values) {
                              final welcome = HomePresidentWelcomeModel(
                                title: values['Title']!,
                                htmlContent: values['Content']!,
                                image: values['Image URL'],
                                showImage: values['Show Image'] == true,
                              );
                              context
                                  .read<HomeBloc>()
                                  .add(UpdateWelcomeEvent(welcome));
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Congress Scope
                      SectionWidget(
                        title: 'Congress Scope',
                        children: [
                          InfoRow(
                              label: 'Title',
                              value: state.homeModel.congressScope.title),
                          InfoRow(
                              label: 'Description',
                              value: stripHtml(
                                  state.homeModel.congressScope.description)),
                          // Text(stripHtml(state.homeModel.congressScope.description)),
                          const Divider(height: 24),
                          CardsList(
                              title: 'Scope Cards',
                              cards: state.homeModel.congressScope.cards),
                        ],
                        onEdit: () => showDialog(
                          context: context,
                          builder: (context) => EditDialogWithCards(
                            cards: state.homeModel.congressScope.cards,
                            title: 'Congress Scope',
                            fields: {
                              'Title': state.homeModel.congressScope.title,
                              'Description':
                                  state.homeModel.congressScope.description,
                            },
                            onSave: (values, cards) {
                              final scope = HomeCongressScopeModel(
                                title: values['Title']!,
                                description: values['Description']!,
                                cards: cards,
                              );
                              context
                                  .read<HomeBloc>()
                                  .add(UpdateScopeEvent(scope));
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Congress Streams
                      SectionWidget(
                        title: 'Congress Streams',
                        children: [
                          InfoRow(
                              label: 'Title',
                              value: state.homeModel.congressStream.title),
                          InfoRow(
                              label: 'Description',
                              value: stripHtml(
                                  state.homeModel.congressStream.description)),
                          // Text(stripHtml(state.homeModel.congressStream.description)),
                          const Divider(height: 24),
                          StreamsList(
                              title: 'Streams',
                              streams: state.homeModel.congressStream.cards),
                        ],
                        onEdit: () => showDialog(
                          context: context,
                          builder: (context) => EditDialogWithStreams(
                            streams: state.homeModel.congressStream.cards,
                            title: 'Congress Streams',
                            fields: {
                              'Title': state.homeModel.congressStream.title,
                              'Description':
                                  state.homeModel.congressStream.description,
                            },
                            onSave: (values, streams) {
                              final stream = HomeCongressStreamModel(
                                title: values['Title']!,
                                description: values['Description']!,
                                cards: streams,
                              );
                              context
                                  .read<HomeBloc>()
                                  .add(UpdateStreamEvent(stream));
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Publications
                      SectionWidget(
                        title: 'Publications',
                        children: [
                          InfoRow(
                              label: 'Content',
                              value: stripHtml(
                                  state.homeModel.publication.htmlContent)),
                          //  Text(stripHtml(state.homeModel.publication.htmlContent)),
                          InfoRow(
                              label: 'Image URL',
                              value: state.homeModel.publication.image ??
                                  'No image'),
                          if (state.homeModel.publication.image != null)
                            InfoRow(
                                label: 'Show Image',
                                value: state.homeModel.publication.showImage
                                    .toString()),
                        ],
                        onEdit: () => showDialog(
                          context: context,
                          builder: (context) => EditDialog(
                            title: 'Publications',
                            fields: {
                              'Content':
                                  state.homeModel.publication.htmlContent,
                              'Image URL':
                                  state.homeModel.publication.image ?? '',
                              'Show Image':
                                  state.homeModel.publication.showImage,
                            },
                            onSave: (values) {
                              final publication = HomePublicationModel(
                                htmlContent: values['Content']!,
                                image: values['Image URL'],
                                showImage: values['Show Image'] == true,
                              );
                              context
                                  .read<HomeBloc>()
                                  .add(UpdatePublicationEvent(publication));
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Why Choose Us
                      SectionWidget(
                        title: 'Why Choose Us',
                        children: [
                          InfoRow(
                              label: 'Title',
                              value: state.homeModel.whyChooseUs.title),
                          InfoRow(
                              label: 'Description',
                              value: stripHtml(
                                  state.homeModel.whyChooseUs.description)),
                          //  Text(stripHtml(state.homeModel.whyChooseUs.description)),
                          const Divider(height: 24),
                          CardsList(
                              title: 'Reasons',
                              cards: state.homeModel.whyChooseUs.cards),
                        ],
                        onEdit: () => showDialog(
                          context: context,
                          builder: (context) => EditDialogWithCards(
                            title: 'Why Choose Us',
                            fields: {
                              'Title': state.homeModel.whyChooseUs.title,
                              'Description':
                                  state.homeModel.whyChooseUs.description,
                            },
                            cards: state.homeModel.whyChooseUs.cards,
                            onSave: (values, cards) {
                              final whyChooseUs = HomeWhyChooseUsModel(
                                title: values['Title']!,
                                description: values['Description']!,
                                cards: cards,
                              );
                              context
                                  .read<HomeBloc>()
                                  .add(UpdateWcuEvent(whyChooseUs));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
