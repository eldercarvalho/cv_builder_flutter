import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/di.dart';
import '../../../data/services/api/exceptions.dart';
import '../../../domain/dtos/authentication_data.dart';
import '../../shared/extensions/context.dart';
import '../../shared/validators/validators.dart';
import '../../shared/widgets/widgets.dart';
import '../home/home_page.dart';
import '../recover_password/recover_password_page.dart';
import '../registration/registration_page.dart';
import 'view_model/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String route = '/login';

  static void replace(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _viewModel = getIt<LoginViewModel>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitted = false;

  AutovalidateMode get _autoValidateMode =>
      _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _viewModel.login.addListener(_onLoginListener);
    _viewModel.loginWithGoogle.addListener(_onLoginWithListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            children: [
              SizedBox(height: 40.h),
              SvgPicture.asset(
                'assets/images/horizontal_logo.svg',
                width: context.screenWidth - 32,
                height: 110,
              ),
              SizedBox(height: 12.h),
              Text(
                context.l10n.loginTitle,
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.secondary,
                ),
              ),
              SizedBox(height: 20.h),
              CbTextFormField(
                controller: _emailController,
                label: context.l10n.email,
                textCapitalization: TextCapitalization.none,
                validator: MultiValidator([
                  RequiredValidator(errorText: context.l10n.requiredField),
                ]).call,
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CbTextFormField(
                    controller: _passwordController,
                    label: context.l10n.password,
                    obscured: true,
                    textCapitalization: TextCapitalization.none,
                    validator: MultiValidator([
                      RequiredValidator(errorText: context.l10n.requiredField),
                    ]).call,
                  ),
                  TextButton(
                    onPressed: () => RecoverPasswordPage.push(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    ),
                    child: Text(context.l10n.loginForgotPassword),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ListenableBuilder(
                listenable: _viewModel.login,
                builder: (context, child) {
                  return CbButton(
                    text: context.l10n.loginLogin,
                    isLoading: _viewModel.login.running,
                    onPressed: _onSubmit,
                  );
                },
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () => RegistrationPage.replace(context),
                child: Text(context.l10n.loginNoAccount),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: context.colors.outline,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(context.l10n.loginOr, style: context.textTheme.bodyLarge),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: context.colors.outline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              ListenableBuilder(
                listenable: _viewModel.loginWithGoogle,
                builder: (context, child) {
                  return CbButton(
                    onPressed: () => _viewModel.loginWithGoogle.execute(),
                    text: context.l10n.loginLoginWithGoogle,
                    type: CbButtonType.outlined,
                    isLoading: _viewModel.loginWithGoogle.running,
                    prefixIcon: SvgPicture.asset(
                      'assets/images/google.svg',
                      width: 24,
                      height: 24,
                    ),
                  );
                },
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
      _viewModel.login.execute(
        AuthenticationData(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onLoginListener() {
    if (_viewModel.login.completed) {
      HomePage.replace(context);
    }

    if (_viewModel.login.error) {
      final error = _viewModel.login.result?.exceptionOrNull();
      if (error is AuthException) {
        String errorMessage = '';
        errorMessage = switch (error.code) {
          AuthErrorCode.invalidCredential => context.l10n.loginUnauthorizedError,
          AuthErrorCode.networkRequestFailed => context.l10n.noNetworkError,
          _ => context.l10n.loginGenericError,
        };
        context.showErrorSnackBar(errorMessage);
      }
    }
  }

  void _onLoginWithListener() {
    if (_viewModel.loginWithGoogle.completed) {
      HomePage.replace(context);
    }

    if (_viewModel.login.error) {
      final result = _viewModel.login.result;
      result?.fold(
        (_) {},
        (error) {
          if (error is AuthException) {
            context.showErrorSnackBar('Erro ao fazer login');
          }
        },
      );
    }
  }
}
