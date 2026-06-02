import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'counter_logic.dart';
import 'gridstyle_logic.dart';
import 'theme_logic.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() {
    return _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    // final pic =
    //     "https://i.pinimg.com/474x/c3/72/29/c372298723967e833b79bc8b9dfd0362.jpg?nii=t";
    bool dark = context.watch<ThemLogic>().dark;
    bool gridStyle = context.watch<GridStyleLogic>().gridStyle;
    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.favorite, size: 200, color: Colors.redAccent),
          ),
          Divider(),
          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text(
                dark ? "Switch to Light Mode" : "Switch to Dark Mode",
              ),
              trailing: Icon(dark ? Icons.dark_mode : Icons.light_mode),
              onTap: () {
                context.read<ThemLogic>().toggleDark();
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text(
                gridStyle ? "Switch to List Style" : "Switch to Grid Style",
              ),
              trailing: Icon(gridStyle ? Icons.grid_view : Icons.list),
              onTap: () {
                context.read<GridStyleLogic>().toggleStyle();
              },
            ),
          ),
        ],
      ),
    );
  }
}
