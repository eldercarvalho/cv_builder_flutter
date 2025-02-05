import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../config/di.dart';
import '../../../domain/models/resume.dart';
import '../../shared/extensions/extensions.dart';
import '../../shared/widgets/widgets.dart';
import '../login/login_page.dart';
import '../resume_form/resume_form_page.dart';
import '../resume_preview/resume_preview_page.dart';
import 'view_models/home_view_model.dart';
import 'widgets/widgest.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  static const route = '/home';

  static Future<void> replace(BuildContext context) async {
    await context.replaceNamed(route);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _viewModel = getIt<HomeViewModel>();

  @override
  void initState() {
    _viewModel.addListener(_onAuthListener);
    _viewModel.getResumes.execute();
    _viewModel.deleteResume.addListener(_onDeleteResumeListener);
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onAuthListener);
    _viewModel.deleteResume.removeListener(_onDeleteResumeListener);
    _viewModel.dispose();
    super.dispose();
  }

  void _onAuthListener() {
    if (!_viewModel.isUserAuthenticated) {
      LoginPage.replace(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Currículos'),
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: () => _viewModel.saveResume(),
              icon: const Icon(FeatherIcons.plus),
            ),
          IconButton(
            onPressed: () => _viewModel.logout(),
            icon: Icon(FeatherIcons.logOut, color: context.colors.primary),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _viewModel,
          _viewModel.getResumes,
        ]),
        builder: (context, child) {
          if (_viewModel.getResumes.running) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_viewModel.getResumes.error) {
            return Center(
              child: Text(
                'Erro ao carregar currículos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          if (_viewModel.getResumes.completed) {
            if (_viewModel.resumes.isEmpty) {
              return CbEmptyState(
                message: 'Crie seu primeiro Currículo Top!',
                imagePath: 'assets/images/mascot.svg',
                buttonText: 'Criar Currículo',
                onPressed: () async {
                  await ResumeFormPage.push(context);
                  _viewModel.getResumes.execute();
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await _viewModel.getResumes.execute();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _viewModel.resumes.length,
                itemBuilder: (context, index) {
                  final resume = _viewModel.resumes[index];

                  return ListenableBuilder(
                    listenable: _viewModel.deleteResume,
                    builder: (context, child) {
                      return ResumeCard(
                        resume: resume,
                        isLoading: _viewModel.deleteResume.argument?.id == resume.id,
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
      floatingActionButton: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.resumes.isEmpty) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => ResumeFormPage.push(context),
            child: const Icon(
              FeatherIcons.plus,
              color: Colors.white,
            ),
          );
        },
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
        _viewModel.deleteResume.execute(resume);
        break;
    }
  }

  void _onDeleteResumeListener() {
    if (_viewModel.deleteResume.error) {
      context.showErrorSnackBar('Ocorreu um erro ao excluir o currículo');
    }
  }
}
