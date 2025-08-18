import 'package:flutter/material.dart';
import 'package:mtwin_send2tm/components/main_components/app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithAllTokens(),
      body: Center(
        child: Text(
          'Main Screen',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );

    // const ENVIR = String.fromEnvironment('ENVIR', defaultValue: 'pipa');
    // context
    //     .read<AuthenticationBloc>()
    //     .add(const GetEnvironmentVarEvent(envi: ENVIR));
  }
}
