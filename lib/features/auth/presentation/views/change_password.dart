import 'package:tomboula/features/auth/providers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _LoginPageState();
}

class _LoginPageState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  bool isLoading = false;
  bool isOldPasswordShowing = false;
  bool isPasswordShowing = false;
  bool isNewPasswordShowing = false;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight * 1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffD6DFFF),
                        ),
                        child: Image.asset("Assets/Images/Lock-locked.png")),
                    Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor),
                    ),
                    const Text(
                      'Put your old password and new one to reset it',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.3,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFormField(
                                obscureText: !isOldPasswordShowing,
                                controller: _oldPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez introduire votre ancien mot de passe';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    fillColor: Colors.grey[50],
                                    filled: true,
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    hintText: 'Old Password',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isOldPasswordShowing =
                                                !isOldPasswordShowing;
                                          });
                                        },
                                        icon: Icon(isOldPasswordShowing
                                            ? Icons.visibility
                                            : Icons.visibility_off))),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                validator: (value) {
                                  var regExp = RegExp(
                                      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$');
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrez Votre Mot de pass';
                                  } else if (!regExp.hasMatch(value)) {
                                    return 'Le Mot de pass doit contenir au moins 8 caractères, une lettre majuscule, une lettre minuscule et un chiffre';
                                  }
                                  return null;
                                },
                                obscureText: !isPasswordShowing,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[50],
                                  filled: true,
                                  labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  hintText: 'New Password',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordShowing =
                                              !isPasswordShowing;
                                        });
                                      },
                                      icon: Icon(isPasswordShowing
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                              ),
                              TextFormField(
                                controller: _newPasswordController,
                                validator: (value) {
                                  if (value! != _passwordController.text) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }

                                  return null;
                                },
                                obscureText: !isNewPasswordShowing,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[50],
                                  filled: true,
                                  labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  hintText: 'New Password again!',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isNewPasswordShowing =
                                              !isNewPasswordShowing;
                                        });
                                      },
                                      icon: Icon(isNewPasswordShowing
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Consumer(
                        builder: (_, WidgetRef ref, __) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var oldPassword =
                                    _oldPasswordController.text.trim();
                                var password = _passwordController.text.trim();
                                var result = await ref
                                    .read(loginControllerProvider.notifier)
                                    .resetPassword(oldPassword, password);
                                setState(() {
                                  isLoading = false;
                                });
                                if (context.mounted) {
                                  if (!result["success"]) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result["message"].split(":")[1],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result["message"].split(":")[1],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));
                                    if (context.mounted) {
                                      context.go("/");
                                    }
                                  }
                                }
                              }
                            },
                            style: isLoading
                                ? ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(116, 52, 96, 253),
                                  )
                                : null,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
