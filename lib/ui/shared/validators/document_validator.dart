import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import 'text_field_validator.dart';

enum DocumentType { cpf, cnpj }

class DocumentValidator extends TextFieldValidator {
  final DocumentType type;

  DocumentValidator({
    required this.type,
    required String errorText,
    bool? validatedIf,
  }) : super(
          errorText,
          validatedIf,
        );

  @override
  bool isValid(String? value) {
    switch (type) {
      case DocumentType.cpf:
        return CPFValidator.isValid(value!);
      case DocumentType.cnpj:
        return CNPJValidator.isValid(value!);
    }
  }
}
