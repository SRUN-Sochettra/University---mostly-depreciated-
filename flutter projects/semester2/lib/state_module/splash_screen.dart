import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'count_app.dart';
import 'gridstyle_logic.dart';
import 'theme_logic.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _lodData() async {
    await Future.delayed(Duration(seconds: 2), () {});
    if (mounted) {
      await context.read<ThemLogic>().readTheme();
    }
    if (mounted) {
      await context.read<GridStyleLogic>().readStyle();
    }
  }

  late Future _futureData = _lodData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Center(
          child: FutureBuilder(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.error.toString()),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _futureData = _lodData();
                        });
                      },
                      child: Text("RETRY"),
                    ),
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return CountApp();
              } else {
                return _buidLoading();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buidLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.rocket_launch, size: 300, color: Colors.white),
        ),
        CircularProgressIndicator(color: Colors.pink),
      ],
    );
  }
}
