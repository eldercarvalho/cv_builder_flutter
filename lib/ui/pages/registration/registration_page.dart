import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/di.dart';
import '../../../domain/dtos/registration_data.dart';
import '../../shared/extensions/context.dart';
import '../../shared/validators/validators.dart';
import '../../shared/widgets/widgets.dart';
import '../login/login_page.dart';
import 'view_model/registration_view_model.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required});

  static const String route = '/registration';

  static void replace(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _viewModel = getIt<RegistrationViewModel>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitted = false;

  AutovalidateMode get _autoValidateMode =>
      _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _viewModel.register.addListener(_onListener);
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
                'assets/images/horizontal_logo.svg',
                width: context.screenWidth - 32,
                height: 110,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.registrationTitle,
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                controller: _nameController,
                label: context.l10n.name,
                validator: MultiValidator([
                  RequiredValidator(errorText: context.l10n.requiredField),
                  MinLengthValidator(min: 3, errorText: context.l10n.minLenghtError(3)),
                ]).call,
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                controller: _emailController,
                label: context.l10n.email,
                validator: MultiValidator([
                  RequiredValidator(errorText: context.l10n.requiredField),
                  EmailValidator(errorText: context.l10n.invalidEmailError),
                ]).call,
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                label: context.l10n.password,
                controller: _passwordController,
                obscured: true,
                validator: MultiValidator([
                  RequiredValidator(errorText: context.l10n.requiredField),
                  MinLengthValidator(min: 8, errorText: context.l10n.minLenghtError(8)),
                ]).call,
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                label: context.l10n.confirmPassword,
                controller: _confirmPasswordController,
                obscured: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return context.l10n.passwordsDoesntMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ListenableBuilder(
                listenable: _viewModel.register,
                builder: (context, child) {
                  return CbButton(
                    text: context.l10n.register,
                    isLoading: _viewModel.register.running,
                    onPressed: _onSubmit,
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => LoginPage.replace(context),
                child: Text(context.l10n.registrationAlreadyHaveAccount),
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
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _viewModel.register.execute(
        RegistrationData(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onListener() {
    if (_viewModel.register.completed) {
      LoginPage.replace(context);
    }

    if (_viewModel.register.error) {
      context.showErrorSnackBar('Ocorreu um erro ao registrar');
    }
  }
}
