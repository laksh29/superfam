import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superfam_1/models/pair_model.dart';
import 'package:superfam_1/services/lite_service.dart';

final StateProvider<List<PairModel>> pairListProv =
    StateProvider<List<PairModel>>((ref) => []);

final StateProvider refreshPairsProv = StateProvider((ref) async {
  PairDatabase pairDb = PairDatabase.instance;

  var data = await pairDb.readAll();

  log("data : $data");

  ref.read(pairListProv.notifier).update((state) => data);
});

String dateFormat(String time) {
  String date = time.split(" ")[0];
  return date;
}
