import 'package:flutter/material.dart';
import 'package:my_app/i18n/strings.g.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(t.Home));
  }
}
