import 'package:cv_builder/domain/dtos/authentication_data.dart';
import 'package:cv_builder/ui/pages/registration/registration_page.dart';
import 'package:cv_builder/ui/shared/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/extensions/context.dart';
import '../../shared/validators/validators.dart';
import 'view_model/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  static const String path = '/login';

  static void replace(BuildContext context) {
    return context.replace(path);
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitted = false;

  AutovalidateMode get _autoValidateMode =>
      _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            spacing: 20,
            children: [
              const SizedBox(height: 32),
              const CbLogo(),
              Text('Faça login na sua conta', style: context.textTheme.titleLarge),
              CbTextFormField(
                controller: _emailController,
                label: context.l10n.email,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Campo obrigatório'),
                  MinLengthValidator(min: 3, errorText: 'Mínimo de 3 caracteres'),
                ]).call,
              ),
              CbTextFormField(
                controller: _passwordController,
                label: context.l10n.password,
                obscured: true,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Campo obrigatório'),
                ]).call,
              ),
              const SizedBox(height: 16),
              ListenableBuilder(
                listenable: widget.viewModel.login,
                builder: (context, child) {
                  return CbButton(
                    text: 'Entrar',
                    isLoading: widget.viewModel.login.running,
                    onPressed: _onSubmit,
                  );
                },
              ),
              TextButton(
                onPressed: () => RegistrationPage.replace(context),
                child: const Text('Não tem uma conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    setState(() {
      _isSubmitted = true;
    });
    if (_formKey.currentState!.validate()) {
      widget.viewModel.login.execute(
        AuthenticationData(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onListener() {
    if (widget.viewModel.login.completed) {
      LoginPage.replace(context);
    }

    if (widget.viewModel.login.error) {
      final result = widget.viewModel.login.result;
      result?.fold(
        (_) {},
        (error) {
          if (error is FirebaseAuthException) {
            final code = error.code;
            if (code == 'invalid-credential') {
              context.showErrorSnackBar('Usuário ou senha incorretos');
            } else {
              context.showErrorSnackBar('Erro ao fazer login');
            }
          }
        },
      );
    }
  }
}
