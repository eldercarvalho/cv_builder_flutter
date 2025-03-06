import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../ui/shared/extensions/context.dart';
import 'widgets/section_title.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const route = '/about';

  static void push(BuildContext context) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _webviewController = WebViewController();
  String _version = '';

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.about),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/horizontal_logo.svg',
                height: 100,
              ),
              const SizedBox(height: 16),
              SectionTitle(text: context.l10n.policyAndTerms),
              const SizedBox(height: 16),
              ListTile(
                title: Text(context.l10n.privacyPolicy),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => _showModal('privacy'),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                title: Text(context.l10n.termsOfService),
                trailing: const Icon(FeatherIcons.chevronRight),
                contentPadding: EdgeInsets.zero,
                onTap: () => _showModal('terms'),
              ),
              const SizedBox(height: 16),
              SectionTitle(text: context.l10n.aboutTheApp),
              const SizedBox(height: 16),
              ListTile(
                title: Text(context.l10n.developer),
                trailing: Text(
                  'Carvalho Dev',
                  style: context.textTheme.labelLarge?.copyWith(color: context.theme.primaryColor),
                ),
                contentPadding: EdgeInsets.zero,
                onTap: _toDevPage,
              ),
              ListTile(
                title: Text(context.l10n.version),
                trailing: Text('v$_version', style: context.textTheme.bodyLarge),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() => _version = '${packageInfo.version}+${packageInfo.buildNumber}');
  }

  void _showModal(String option) {
    final url = option == 'privacy'
        ? 'https://frontendeiro.blogspot.com/2025/02/politica-de-privacidade.html'
        : 'https://frontendeiro.blogspot.com/2025/02/terms-conditions.html';
    _webviewController.loadRequest(Uri.parse(url));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(option == 'privacy' ? context.l10n.privacyPolicy : context.l10n.termsOfService),
            ),
            body: WebViewWidget(
              controller: _webviewController,
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  void _toDevPage() async {
    final Uri url = Uri.parse("https://github.com/eldercarvalho");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
