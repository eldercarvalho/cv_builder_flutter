.PHONY: all

all: build-runner splash icons l10n

build-runner:
	@echo "Running build runner..."
	@dart pub run build_runner build --delete-conflicting-outputs
	@echo "Done."

splash:
	@echo "Generating splash screen..."
	@dart run flutter_native_splash:create
	@echo "Done."

launcher:
	@echo "Generating launcher icons..."
	@dart pub run flutter_launcher_icons
	@echo "Done."

l10n:
	@echo "Generating localization files..."
	@flutter gen-l10n
	# @echo "Copying generated files to project..."
	# @cp -r .dart_tool/flutter_gen/gen_l10n/ lib/l10n/
	@echo "Done."

appbundle:
	@echo "Generating version for Play Store..."
	@flutter build appbundle
	@echo "Done."

githooks:
	@echo "Setting up git hooks..."
	dart pub add --dev husky
	@dart run husky install
	@dart pub add --dev commitlint_cli
	@dart run husky add .husky/pre-push "flutter analyze"
	@dart run husky add .husky/pre-push "flutter test --coverage"
	@echo "include: package:commitlint_cli/commitlint.yaml" > commitlint.yaml
	@dart run husky add .husky/commit-msg  'dart run commitlint_cli --edit ${1}'
	@echo "Done."

showkeystore:
	@echo "Showing keystore..."
	@keytool -list -v -keystore android/app/key.jks -storepass password -keypass password
	@echo "Done."
