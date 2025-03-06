import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../config/di.dart';
import '../../../data/services/api/exceptions.dart';
import '../../shared/extensions/extensions.dart';
import '../../shared/validators/validators.dart';
import '../../shared/widgets/widgets.dart';
import 'view_model/account_view_model.dart';
import 'view_model/data.dart';
import 'widgets/widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  static const route = '/account';

  static Future<Object?> push(BuildContext context) async {
    return await Navigator.of(context).pushNamed(route);
  }

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _viewModel = getIt<AccountViewModel>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitted = false;
  bool _shouldValidatePassword = false;

  @override
  void initState() {
    super.initState();

    _viewModel.getSignInMethods();
    _nameController.text = _viewModel.user?.name ?? '';
    _emailController.text = _viewModel.user?.email ?? '';
    _passwordController.addListener(() {
      _shouldValidatePassword = _passwordController.text.isNotEmpty;
    });
    _viewModel.updateAccount.addListener(_onUpdateAccountListener);
    _viewModel.deleteAccount.addListener(_onDeleteAccountListener);
  }

  @override
  void dispose() {
    _viewModel.updateAccount.removeListener(_onUpdateAccountListener);
    _viewModel.deleteAccount.removeListener(_onDeleteAccountListener);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.account),
      ),
      body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SectionTitle(text: context.l10n.accountYourInfo),
                        const SizedBox(height: 24),
                        CbTextFormField(
                          controller: _nameController,
                          autovalidateMode:
                              _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                          label: context.l10n.name,
                          validator: MultiValidator([
                            RequiredValidator(errorText: context.l10n.requiredField),
                            MinLengthValidator(min: 3, errorText: context.l10n.minLenghtError(3)),
                          ]).call,
                        ),
                        const SizedBox(height: 24),
                        Opacity(
                          opacity: 0.6,
                          child: CbTextFormField(
                            readOnly: true,
                            controller: _emailController,
                            autovalidateMode:
                                _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                            label: context.l10n.email,
                            validator: MultiValidator([
                              RequiredValidator(errorText: context.l10n.requiredField),
                              EmailValidator(errorText: context.l10n.invalidEmailError),
                            ]).call,
                          ),
                        ),
                        ListenableBuilder(
                          listenable: _viewModel,
                          builder: (context, child) {
                            if (!_viewModel.signInMethods.contains('password')) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              children: [
                                const SizedBox(height: 24),
                                SectionTitle(text: context.l10n.accountChangePassword),
                                const SizedBox(height: 24),
                                CbTextFormField(
                                  controller: _passwordController,
                                  autovalidateMode:
                                      _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                  label: context.l10n.password,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                      errorText: context.l10n.requiredField,
                                      validateIf: _shouldValidatePassword,
                                    ),
                                    MinLengthValidator(
                                      min: 8,
                                      errorText: context.l10n.minLenghtError(8),
                                      validatedIf: _shouldValidatePassword,
                                    ),
                                  ]).call,
                                ),
                                const SizedBox(height: 24),
                                CbTextFormField(
                                  controller: _confirmPasswordController,
                                  autovalidateMode:
                                      _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                  label: context.l10n.confirmPassword,
                                  validator: (value) {
                                    if (!_shouldValidatePassword) {
                                      return null;
                                    }

                                    if (value != _passwordController.text) {
                                      return context.l10n.passwordsDoesntMatch;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        ListenableBuilder(
                          listenable: _viewModel.updateAccount,
                          builder: (context, child) {
                            return CbButton(
                              text: context.l10n.save,
                              isLoading: _viewModel.updateAccount.running,
                              onPressed: _onSubmit,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!isKeyboardVisible)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListenableBuilder(
                  listenable: _viewModel.deleteAccount,
                  builder: (context, child) {
                    return CbButton(
                      onPressed: _shouldDeleteAccountDialog,
                      text: context.l10n.deleteAccount,
                      type: CbButtonType.outlined,
                      prefixIcon: FeatherIcons.trash2,
                      themeColor: context.colors.error,
                      isLoading: _viewModel.deleteAccount.running,
                    );
                  },
                ),
              ),
          ],
        );
      }),
    );
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    _isSubmitted = true;
    if (_formKey.currentState!.validate()) {
      _viewModel.updateAccount.execute(UpdateAccountData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  void _onUpdateAccountListener() {
    if (_viewModel.updateAccount.completed) {
      _shouldValidatePassword = false;
      _formKey.currentState?.reset();
      _passwordController.text = '';
      _confirmPasswordController.clear();
      context.showSuccessSnackBar(context.l10n.accountUpdateSuccess);
    }

    if (_viewModel.updateAccount.error) {
      final error = _viewModel.updateAccount.result?.exceptionOrNull();

      if (error is AuthException) {
        String errorMessage = '';
        errorMessage = switch (error.code) {
          AuthErrorCode.emailAlreadyInUse => context.l10n.emailAlreadyInUseError,
          AuthErrorCode.networkRequestFailed => context.l10n.noNetworkError,
          _ => context.l10n.loginGenericError,
        };
        context.showErrorSnackBar(errorMessage);
      }
    }
  }

  void _onDeleteAccountListener() {
    if (_viewModel.updateAccount.completed) {
      context.showSuccessSnackBar(context.l10n.accountDeleteSuccess);
    }

    if (_viewModel.updateAccount.error) {
      context.showErrorSnackBar(context.l10n.accountDeleteError);
    }
  }

  void _shouldDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(FeatherIcons.alertTriangle, color: context.colors.error, size: 60),
          title: Text(context.l10n.deleteAccount,
              style: context.textTheme.titleLarge?.copyWith(color: context.colors.error)),
          content: Text(context.l10n.accountDeleteAlertMessage, style: context.textTheme.bodyLarge),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.accountDeleteAlertCancel),
            ),
            TextButton(
              onPressed: () {
                _viewModel.deleteAccount.execute();
                Navigator.of(context).pop();
              },
              child: Text(context.l10n.accountDeleteAlertConfirm, style: TextStyle(color: context.colors.error)),
            ),
          ],
        );
      },
    );
  }
}
