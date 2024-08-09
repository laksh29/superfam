import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_extensions/super_extensions.dart';
import 'package:superfam_1/models/pair_model.dart';
import 'package:superfam_1/providers/data_provider.dart';
import 'package:superfam_1/screens/login_screen.dart';
import 'package:superfam_1/services/lite_service.dart';

import '../widgets/button.dart';
import '../widgets/text_field.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(refreshPairsProv);
    List<PairModel> pairs = ref.watch(pairListProv);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SuperFam",
          style: TextStyle(
            color: Colors.blue[900],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (contxet) => const LoginScreen()),
                (_) => false,
              );
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: pairs.isEmpty
          ? const Center(
              child: Text(
                "No pairs yet",
                style: TextStyle(fontSize: 22.0),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              shrinkWrap: true,
              itemCount: pairs.length,
              itemBuilder: (context, index) {
                final pair = pairs.elementAt(index);
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => OperationsDialog(
                        index: index,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("ID: ${pair.id}"),
                            const Spacer(),
                            Text(dateFormat(pair.createdTime!)),
                          ],
                        ),
                        10.hSizedBox,
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("KEY:"),
                                Text(
                                  pair.key ?? "Key",
                                  style: const TextStyle(fontSize: 22.0),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("VALUE:"),
                                Text(
                                  pair.value ?? "Value",
                                  style: const TextStyle(fontSize: 22.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return 20.hSizedBox;
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) => const BottomFormSheet(),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.blue[900],
        ),
      ),
    );
  }
}

class OperationsDialog extends ConsumerWidget {
  const OperationsDialog({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PairDatabase pairDb = PairDatabase.instance;

    PairModel pair = ref.watch(pairListProv).elementAt(index);
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("KEY:"),
                  Text(
                    pair.key ?? "Key",
                    style: const TextStyle(fontSize: 22.0),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("VALUE:"),
                  Text(
                    pair.value ?? "Value",
                    style: const TextStyle(fontSize: 22.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        CustomButton(
          onTap: () async {
            pairDb.delete(pair.id!);

            var read = await pairDb.readAll();
            ref.read(pairListProv.notifier).update((state) => read);

            if (context.mounted) Navigator.pop(context);
          },
          color: Colors.redAccent,
          text: "Delete this Key-Value pair",
        ),
      ],
    );
  }
}

class BottomFormSheet extends ConsumerStatefulWidget {
  const BottomFormSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomFormSheetState();
}

class _BottomFormSheetState extends ConsumerState<BottomFormSheet> {
  PairDatabase pairDb = PairDatabase.instance;

  final List<TextEditingController> _keyCont = [];
  final List<TextEditingController> _valueCont = [];

  void _addPair() {
    setState(() {
      _keyCont.add(TextEditingController());
      _valueCont.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: context.screenHeight / 2,
      child: Column(
        children: [
          SizedBox(
            height: context.screenHeight / 2.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_keyCont.isNotEmpty)
                    ...List.generate(
                      _keyCont.length,
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: context.screenWidth / 2.5,
                            child: SimpleTextField(
                              textEditingController: _keyCont.elementAt(index),
                              header: "Key ${index + 1}",
                              inputType: TextInputType.text,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: context.screenWidth / 2.5,
                            child: SimpleTextField(
                              textEditingController:
                                  _valueCont.elementAt(index),
                              header: "Value ${index + 1}",
                              inputType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 45,
                    child: CustomButton(
                      onTap: _addPair,
                      text: "Add new Key-Value pair",
                    ),
                  )
                ],
              ),
            ),
          ),
          30.hSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 45,
                width: context.screenWidth / 2.5,
                child: CustomButton(
                  onTap: () => Navigator.pop(context),
                  color: Colors.redAccent,
                  text: "Cancel",
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 45,
                width: context.screenWidth / 2.5,
                child: CustomButton(
                  onTap: () async {
                    for (var x = 0; x < _keyCont.length; x++) {
                      PairModel data = PairModel(
                        key: _keyCont.elementAt(x).text,
                        value: _valueCont.elementAt(x).text,
                        createdTime: DateTime.now().toString(),
                      );

                      pairDb.create(data);
                    }

                    var read = await pairDb.readAll();
                    ref.read(pairListProv.notifier).update((state) => read);

                    if (context.mounted) Navigator.pop(context);
                  },
                  color: Colors.green,
                  text: "Submit",
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
