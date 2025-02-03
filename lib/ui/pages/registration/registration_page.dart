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
                'assets/images/logo_vertical.svg',
                width: context.screenWidth - 32,
                height: 110,
              ),
              const SizedBox(height: 12),
              Text(
                'Crie uma conta',
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                controller: _nameController,
                label: context.l10n.name,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Campo obrigatório'),
                  MinLengthValidator(min: 3, errorText: 'Mínimo de 3 caracteres'),
                ]).call,
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                controller: _emailController,
                label: context.l10n.email,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Campo obrigatório'),
                  EmailValidator(errorText: 'E-mail inválido'),
                ]).call,
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                label: 'Senha',
                controller: _passwordController,
                obscured: true,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Campo obrigatório'),
                  MinLengthValidator(min: 6, errorText: 'Mínimo de 6 caracteres'),
                ]).call,
              ),
              const SizedBox(height: 20),
              CbTextFormField(
                label: 'Confirmar a senha',
                controller: _confirmPasswordController,
                obscured: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
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
                child: const Text('Já tem uma conta? Faça login'),
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
