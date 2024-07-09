import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tomboula/features/admin/providers/cadeaux_provider.dart';
import 'package:tomboula/features/home/data/models/prize.dart';

class CadeauxPage extends ConsumerStatefulWidget {
  const CadeauxPage({super.key});

  @override
  ConsumerState<CadeauxPage> createState() => _CadeauxPageState();
}

class _CadeauxPageState extends ConsumerState<CadeauxPage> {
  bool _isloading = true;
  bool _isAssetImage = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _coefficientController = TextEditingController();

  List<Prize> prizes = List.generate(
      10,
      (index) => Prize(
          name: 'Prize $index ',
          coefficient: 0,
          id: "s",
          image: "assets/images/placeholder.png"));

  @override
  void initState() {
    super.initState();

    if (!mounted) return;
    ref.read(cadeauxProvider.notifier).fetchCadeaux().then((_) {
      if (!mounted) return;
      setState(() {
        _isloading = false;
        _isAssetImage = false;
        prizes = ref.read(cadeauxProvider);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        if (_isloading) return;
        if (!mounted) return;
        setState(() {
          _isloading = true;
        });
        await ref.read(cadeauxProvider.notifier).fetchCadeaux();
        if (!mounted) return;
        setState(() {
          prizes = ref.read(cadeauxProvider);
          _isloading = false;
        });
      },
      child: ListView.builder(
        itemCount: prizes.length,
        itemBuilder: (context, index) {
          return Skeletonizer(
            enabled: _isloading,
            child: ListTile(
              title: Text("Nom : ${prizes[index].name}"),
              subtitle:
                  Text("Quantite : ${prizes[index].coefficient.toString()}"),
              leading: _isAssetImage
                  ? Image.asset(prizes[index].image)
                  : Image.network(prizes[index].image),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  _coefficientController.text =
                      prizes[index].coefficient.toString();
                  _nameController.text = prizes[index].name;
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.pink,
                        title: const Text("Modifier le cadeau",
                            style: TextStyle(color: Colors.white)),
                        content: SizedBox(
                          height: height * 0.2,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "Nom",
                                    hintText: "Nom",
                                  ),
                                  controller: _nameController,
                                ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "Quantite",
                                    hintText: "Quantite",
                                  ),
                                  controller: _coefficientController,
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text(
                              "Annuler",
                              style: TextStyle(color: Colors.pink),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              try {
                                await ref
                                    .read(cadeauxProvider.notifier)
                                    .updateCadeau(
                                      id: prizes[index].id,
                                      name: _nameController.text,
                                      coefficient: int.parse(
                                          _coefficientController.text),
                                    );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              }

                              if (!mounted) return;
                              setState(() {
                                _isloading = true;
                              });
                              await ref
                                  .read(cadeauxProvider.notifier)
                                  .fetchCadeaux();
                              if (!mounted) return;
                              setState(() {
                                prizes = ref.read(cadeauxProvider);
                                _isloading = false;
                              });

                              if (!context.mounted) return;
                              context.pop();
                            },
                            child: const Text(
                              "Modifier",
                              style: TextStyle(color: Colors.pink),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
