import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabController extends Notifier<int> {
  @override
  int build() => 0;
  void select(int index) {
    if (index == 0 || index == 1) state = index;
  }
}

final tabProvider = NotifierProvider<TabController, int>(TabController.new);
