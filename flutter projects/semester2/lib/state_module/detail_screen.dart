import 'package:flutter/material.dart';

//import 'package:provider/provider.dart';
// import 'counter_logic.dart';
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key}); // ✅ Add this line

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    // int cnt = context.watch<CounterLogic>().counter;
    // String imageurl =
    //     "https://images.rawpixel.com/image_social_portrait/cHJpdmF0ZS9...";

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Screen"),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     context.read<CounterLogic>().decrease();
          //   },
          //   icon: Icon(Icons.remove),
          // ),
        ],
      ),
    );
  }
}
