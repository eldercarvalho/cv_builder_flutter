import 'package:cv_builder/data/services/api/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/dtos/authentication_data.dart';
import '../../shared/extensions/context.dart';
import '../../shared/validators/validators.dart';
import '../../shared/widgets/widgets.dart';
import '../registration/registration_page.dart';
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
            children: [
              SizedBox(height: 40.h),
              SvgPicture.asset(
                'assets/images/logo_vertical.svg',
                width: context.screenWidth - 32,
                height: 110,
              ),
              const SizedBox(height: 12),
              Text(
                'Entre na sua conta',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                controller: _emailController,
                label: context.l10n.email,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Campo obrigatório'),
                ]).call,
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                controller: _passwordController,
                label: context.l10n.password,
                obscured: true,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Campo obrigatório'),
                ]).call,
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => RegistrationPage.replace(context),
                child: Text(
                  'Não tem uma conta? Cadastre-se',
                  style: context.textTheme.titleSmall?.copyWith(color: context.colors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    setState(() => _isSubmitted = true);
    FocusScope.of(context).unfocus();
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
          if (error is AuthException) {
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
