import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.child});

  final Widget child;

  static const String path = '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
