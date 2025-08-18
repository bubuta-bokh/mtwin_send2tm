import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtwin_send2tm/bloc/dmdk_bloc/dmdk_bloc.dart';
import 'package:mtwin_send2tm/components/main_components/app_bar.dart';

class HealthRequestScreen extends StatelessWidget {
  const HealthRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithAllTokens(),
      //bottomNavigationBar: const MtWinBottomAppBar(),
      // floatingActionButton: const FabMainScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () => BlocProvider.of<DmdkBloc>(
                context,
              ).add(DmdkHealthRequestMade()),
              child: const Text('Отправить Health-запрос'),
            ),
          ],
        ),
      ),
    );
  }
}
