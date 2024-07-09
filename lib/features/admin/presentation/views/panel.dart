import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomboula/features/admin/presentation/widgets/cadeaux_page.dart';
import 'package:tomboula/features/admin/presentation/widgets/users_page.dart';
import 'package:tomboula/features/admin/providers/cadeaux_provider.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _coefficientController = TextEditingController();
  XFile? _image;
  final List<Widget> _pages = const [
    UsersPage(),
    CadeauxPage(),
  ];
  int _index = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text('Admin Panel'),
      ),
      floatingActionButton: _index == 0
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.pink[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.pink,
                      title: const Text('Add a new prize',
                          style: TextStyle(color: Colors.white)),
                      content: SizedBox(
                        height: height * 0.3,
                        child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'Prize name',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a name';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: _coefficientController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: 'Prize coefficient',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a coefficient';
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        onPressed: () async {
                                          var image = await _picker.pickImage(
                                              source: ImageSource.gallery);
                                          setState(() {
                                            _image = image;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.upload,
                                          color: Colors.pink,
                                        )),
                                  ),
                                ),
                                Text(
                                  _image != null
                                      ? "Uploaded an Image"
                                      : 'No Image Selected',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            )),
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.pink)),
                        ),
                        Consumer(
                          builder: (_, WidgetRef ref, __) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_image == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "veuillez choisir une image",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await ref
                                      .read(cadeauxProvider.notifier)
                                      .addPrize(
                                        name: _nameController.text,
                                        coefficient: int.parse(
                                            _coefficientController.text),
                                        image: _image!,
                                      );
                                  if (!context.mounted) return;
                                  context.pop();
                                }
                              },
                              child: const Text('Add',
                                  style: TextStyle(color: Colors.pink)),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.add,
              ),
            ),
      body: DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context);

          // Example of adding a listener
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              setState(() {
                _index = tabController.index;
              });
            }
          });

          return Column(
            children: [
              const TabBar(
                labelColor: Colors.pink,
                indicatorColor: Colors.pink,
                tabs: [
                  Tab(text: 'Participants'),
                  Tab(text: 'Cadeaux'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: _pages,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
