import 'package:cv_builder/ui/pages/home/view_models/home_view_model.dart';
import 'package:cv_builder/ui/pages/home/widgets/widgest.dart';
import 'package:cv_builder/ui/pages/resume_preview/resume_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../resume_form/resume_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seus Currículos'),
        actions: [
          IconButton(
            onPressed: () => widget.viewModel.clearCache(),
            icon: const Icon(FeatherIcons.trash2),
          ),
          IconButton(
            onPressed: () => widget.viewModel.saveResume(),
            icon: const Icon(FeatherIcons.plus),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          return ListenableBuilder(
            listenable: widget.viewModel.getResumes,
            builder: (context, _) {
              if (widget.viewModel.getResumes.running) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (widget.viewModel.getResumes.error) {
                return Center(
                  child: Text(
                    'Erro ao carregar currículos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }

              if (widget.viewModel.getResumes.completed) {
                if (widget.viewModel.resumes.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum currículo encontrado',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await widget.viewModel.getResumes.execute();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.viewModel.resumes.length,
                    itemBuilder: (context, index) {
                      final resume = widget.viewModel.resumes[index];

                      return ResumeCard(
                        resume: resume,
                        onTap: () => ResumePreviewPage.push(context, params: ResumePreviewParams(resume: resume)),
                      );
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => ResumeFormPage.push(context),
        child: const Icon(
          FeatherIcons.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}
