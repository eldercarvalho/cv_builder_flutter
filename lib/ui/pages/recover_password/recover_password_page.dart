import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../shared/extensions/extensions.dart';
import '../../shared/validators/validators.dart';
import '../../shared/widgets/cb_button.dart';
import '../../shared/widgets/cb_text_form_field.dart';
import 'recover_password_view_model.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  static const String route = '/recover-password';

  static void push(BuildContext context) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _viewModel = getIt<RecoverPasswordViewModel>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.resetPassword.addListener(_onListener);
  }

  @override
  void dispose() {
    _viewModel.resetPassword.removeListener(_onListener);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.recoverPasswordTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                context.l10n.recoverPasswordMessage,
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.left,
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
              ListenableBuilder(
                listenable: _viewModel.resetPassword,
                builder: (context, child) {
                  return CbButton(
                    onPressed: _onSubmit,
                    text: context.l10n.recoverPasswordSend,
                    isLoading: _viewModel.resetPassword.running,
                    disabled: _viewModel.resetPassword.running,
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
    if (_formKey.currentState!.validate()) {
      _viewModel.resetPassword.execute(_emailController.text);
    }
  }

  void _onListener() {
    if (_viewModel.resetPassword.completed) {
      FocusScope.of(context).unfocus();
      _emailController.clear();
      context.showSuccessSnackBar(context.l10n.recoverPasswordSuccess);
    }

    if (_viewModel.resetPassword.error) {
      context.showSuccessSnackBar(context.l10n.recoverPasswordGenericError);
    }
  }
}
