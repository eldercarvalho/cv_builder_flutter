import 'package:cv_builder/ui/pages/splash/view_model/splash_view_model.dart';
import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.viewModel});

  final SplashViewModel viewModel;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateGuestId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/images/logo-light.svg',
          width: context.screenWidth * 0.7,
        ),
      ),
    );
  }

  Future<void> _generateGuestId() async {
    await widget.viewModel.generateGuestId();
    // if (mounted) context.replace(Routes.home);
  }
}
