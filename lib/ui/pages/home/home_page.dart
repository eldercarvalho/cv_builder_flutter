import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../domain/models/resume.dart';
import '../resume_form/resume_form_page.dart';
import '../resume_preview/resume_preview_page.dart';
import 'view_models/home_view_model.dart';
import 'widgets/widgest.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  static const path = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.viewModel.deleteResume.addListener(_onDeleteResumeListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Currículos'),
        actions: [
          // IconButton(
          //   onPressed: () => widget.viewModel.clearCache(),
          //   icon: const Icon(FeatherIcons.trash2),
          // ),
          IconButton(
            onPressed: () => widget.viewModel.logout(),
            icon: const Icon(FeatherIcons.logOut),
          ),
          IconButton(
            onPressed: () => widget.viewModel.saveResume(),
            icon: const Icon(FeatherIcons.plus),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.getResumes,
        ]),
        builder: (context, child) {
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

                  return ListenableBuilder(
                    listenable: widget.viewModel.deleteResume,
                    builder: (context, child) {
                      return ResumeCard(
                        resume: resume,
                        isLoading: widget.viewModel.deleteResume.argument?.id == resume.id,
                        onTap: () => _navToPreview(resume),
                        onMenuSelected: (action) => _onMenuSelected(action, resume),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
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

  void _navToPreview(Resume resume) => ResumePreviewPage.push(
        context,
        params: ResumePreviewParams(resume: resume),
      );

  void _onMenuSelected(String value, Resume resume) {
    switch (value) {
      case 'edit':
        _navToPreview(resume);
        break;
      case 'delete':
        widget.viewModel.deleteResume.execute(resume);
        break;
    }
  }

  void _onDeleteResumeListener() {
    if (widget.viewModel.deleteResume.error) {
      context.showErrorSnackBar('Ocorreu um erro ao excluir o currículo');
    }
  }
}
