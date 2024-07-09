import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tomboula/features/auth/providers/login_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tomboula/features/home/data/models/participant.dart';
import 'package:tomboula/features/home/presentation/widget/error_widget.dart';
import 'package:tomboula/features/home/providers/participant_provider.dart';
import 'package:tomboula/features/home/providers/prizes_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  late Map<String, int> names;
  AudioPlayer audioPlayer = AudioPlayer();
  String slowSoundPath = "sounds/WheelSpinSlow.mp3";
  String fastSoundPath = "sounds/WheelSpinFast.mp3";
  bool _isLoading = true;
  bool _isLoading2 = false;
  bool _isLoading3 = false;
  bool _isError = false;
  late AnimationController _controller;
  late CurvedAnimation _curve;
  late Animation<double> _scaleAnimation;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String? _imageUrl;
  String? _prizeId;
  String? _coef;
  Future<void> playFastTick() async {
    await audioPlayer.play(AssetSource(fastSoundPath));
  }

  Future<void> playSlowTick() async {
    await audioPlayer.play(AssetSource(slowSoundPath));
  }

  @override
  void dispose() {
    // Don't forget to dispose of the audio player
    audioPlayer.dispose();
    _controller.dispose();
    _curve.dispose();
    _scaleAnimation.removeListener(() {});
    super.dispose();
  }

  Future<void> _getPrizes() async {
    try {
      ref.read(prizesProvider.notifier).fetchPrizes().then(
        (value) {
          var prizes = ref.read(prizesProvider);
          names = Map<String, int>.fromEntries(
              prizes.map((e) => MapEntry(e.name, e.coefficient)));
          setState(() {
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      if (e is Exception) {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      ref.read(prizesProvider.notifier).fetchPrizes().then(
        (value) {
          var prizes = ref.read(prizesProvider);
          names = Map<String, int>.fromEntries(
              prizes.map((e) => MapEntry(e.name, e.coefficient)));
          setState(() {
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      if (e is Exception) {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _curve = CurvedAnimation(
      parent: _scaleAnimation,
      curve: Curves.bounceInOut,
      // reverseCurve: Curves.easeInOut,
    );
  }

  void playSound() async {
    for (var i = 0; i < 25; i++) {
      await playFastTick();
    }
    for (var i = 0; i < 15; i++) {
      await playSlowTick();
    }
  }

  StreamController<int> controller = StreamController<int>();
  String _reward = '';
  final ConfettiController _confettiController = ConfettiController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var isAdmin = ref.read(loginControllerProvider.notifier).isAdmin();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        centerTitle: isAdmin,
        leading: isAdmin
            ? IconButton(
                icon: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 50,
                ),
                onPressed: () {
                  context.push('/admin');
                },
              )
            : null,
        title: const Text("Mozil",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 45,
            ),
            onPressed: () async {
              await ref.read(loginControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: height / 20),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 40,
                  spreadRadius: 1,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  height: 125,
                  width: 125,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/images/mozil.jpg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text("العب و اربح مع موزيل",
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                _isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 40),
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: CircularProgressIndicator(
                            strokeWidth: 15,
                            color: Colors.pink[100],
                          ),
                        ),
                      )
                    : _isError
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: ErrorCard(),
                          )
                        : Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: width, // Replace with desired width
                                  height: 400, // Replace with desired height
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffee9ca7),
                                        width: 20,
                                      ),
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffBB377D),
                                            Color(0xffFBD3E9),
                                          ],
                                          stops: [
                                            0,
                                            1.0
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight)),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: width /
                                        1.45, // Replace with desired width
                                    height: 350, // Replace with desired height
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffFEF89A),
                                        width: 10,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: height / 12),
                                child: SizedBox(
                                  height: width / 1.5,
                                  child: FortuneWheel(
                                    selected: controller.stream,
                                    animateFirst: false,
                                    physics: NoPanPhysics(),
                                    onAnimationEnd: () async {
                                      _confettiController.play();
                                      _controller.forward();
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ScaleTransition(
                                            scale: _curve,
                                            child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: const Text(
                                                "! تهاني لك",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              content: SizedBox(
                                                height: 250,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        const Text(
                                                          "! لقد ربحت معنا",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          bottom: 0,
                                                          left: 0,
                                                          child: ConfettiWidget(
                                                            shouldLoop: true,
                                                            confettiController:
                                                                _confettiController,
                                                            blastDirectionality:
                                                                BlastDirectionality
                                                                    .explosive,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          bottom: 0,
                                                          right: 0,
                                                          child: ConfettiWidget(
                                                            shouldLoop: true,
                                                            confettiController:
                                                                _confettiController,
                                                            blastDirectionality:
                                                                BlastDirectionality
                                                                    .explosive,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      _reward,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      height: 100,
                                                      child: Image.network(
                                                        _imageUrl!,
                                                        height: 100,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              surfaceTintColor: Colors.white,
                                              backgroundColor: Colors.pink,
                                              actions: [
                                                SizedBox(
                                                  width: 250,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    onPressed: _isLoading2
                                                        ? null
                                                        : () async {
                                                            _confettiController
                                                                .stop();
                                                            _controller.reset();
                                                            setState(() {
                                                              _isLoading2 =
                                                                  true;
                                                            });
                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }
                                                            setState(() {
                                                              _isLoading2 =
                                                                  false;
                                                            });
                                                            await _getPrizes();
                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }
                                                            context.pop();
                                                          },
                                                    child: _isLoading2
                                                        ? CircularProgressIndicator(
                                                            color: Colors
                                                                .pink[100],
                                                          )
                                                        : const Text(
                                                            "! تسليم الجائزة",
                                                            style: TextStyle(
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.pink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    indicators: [
                                      FortuneIndicator(
                                        alignment: Alignment.topCenter,
                                        child: CustomPaint(
                                          size: const Size(40,
                                              35), // You can adjust the size to fit your needs
                                          painter: CustomTrianglePainter(),
                                        ),
                                      )
                                    ],
                                    items: _buildFortuneItems(names.entries
                                        .map((e) => e.key)
                                        .toList()),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 30, // Replace with desired width
                                    height: 30, // Replace with desired height
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 20,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: const Color(0xffBB377D),
                                        width: 20,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text(
                              "التسجيل",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            content: Form(
                              key: _formKey,
                              child: SizedBox(
                                height: 220,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextFormField(
                                      controller: _firstNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "الرجاء إدخال الاسم";
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      decoration: const InputDecoration(
                                        errorStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        hintText: "الاسم",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _lastNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "الرجاء إدخال اللقب";
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      decoration: const InputDecoration(
                                        errorStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        hintText: "اللقب",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "الرجاء إدخال رقم الهاتف";
                                        }
                                        if (value.length < 10) {
                                          return "الرجاء إدخال رقم هاتف صحيح";
                                        }
                                        if (!RegExp(r'^(05|06|07)')
                                            .hasMatch(value)) {
                                          return "الرجاء إدخال رقم هاتف صحيح";
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        errorStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        hintText: "رقم الهاتف",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.pink,
                            actions: [
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _isLoading3
                                      ? null
                                      : () async {
                                          final notifier = ref.read(
                                              participantProvider.notifier);
                                          if (!_formKey.currentState!
                                              .validate()) return;
                                          setState(() {
                                            _isLoading3 = true;
                                          });
                                          var isRegistered = await notifier
                                              .isParticipantRegistered(
                                            _phoneNumberController.text,
                                          );

                                          if (isRegistered) {
                                            setState(() {
                                              _isLoading3 = false;
                                            });

                                            if (!context.mounted) return;
                                            context.pop();
                                            await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  title: const Text(
                                                    "خطأ",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    "هذا الرقم مسجل بالفعل",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  actionsAlignment:
                                                      MainAxisAlignment.center,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  backgroundColor: Colors.pink,
                                                  actions: [
                                                    SizedBox(
                                                      width: 250,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        child: const Text(
                                                          "إغلاق",
                                                          style: TextStyle(
                                                            color: Colors.pink,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            return;
                                          }
                                          notifier.prepareParticipant(
                                            Participant(
                                              firstName:
                                                  _firstNameController.text,
                                              lastName:
                                                  _lastNameController.text,
                                              phoneNumber:
                                                  _phoneNumberController.text,
                                              prizeId: null,
                                            ),
                                          );

                                          setState(() {
                                            _isLoading3 = false;
                                          });
                                          if (!context.mounted) return;
                                          context.pop();
                                          _spinTheWheel();
                                        },
                                  child: _isLoading3
                                      ? CircularProgressIndicator(
                                          color: Colors.pink[100],
                                        )
                                      : const Text(
                                          "! سجل و إربح",
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "!إربح الآن",
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _spinTheWheel() {
    playSound();
    final random = chooseName(names);
    setState(() {
      _reward = random;
      var prizes = ref.read(prizesProvider);
      var prize = prizes.firstWhere((element) => element.name == _reward);
      _imageUrl = prize.image;
      _prizeId = prize.id;
      _coef = (prize.coefficient - 1).toString();
    });
    final randomInt = names.keys.toList().indexOf(random);
    controller.add(randomInt);
    try {
      ref.read(participantProvider.notifier).prepareParticipant(
            Participant(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              phoneNumber: _phoneNumberController.text,
              prizeId: _prizeId,
            ),
          );
      _formKey.currentState!.reset();
      ref.read(participantProvider.notifier).addParticipant(_prizeId!, _coef!);
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      context.pop();
      setState(() {
        _isLoading2 = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "خطأ",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: const Text(
              "حدث خطأ أثناء تسليم الجائزة",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.pink,
            actions: [
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    "إغلاق",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  List<FortuneItem> _buildFortuneItems(List<String> names) {
    List<FortuneItem> fortuneItems = [];
    bool isWhite = true;

    for (String name in names) {
      Color color;
      if (!isWhite) {
        color = Colors.white;
      } else {
        color = Colors.transparent;
      }

      fortuneItems.add(
        FortuneItem(
          style: FortuneItemStyle(
            borderColor: Colors.transparent,
            color: !isWhite ? Colors.transparent : Colors.white,
          ),
          child: !isWhite
              ? Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text(
                    name,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Adjust the font size as needed
                    ),
                  ),
                )
              : ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(colors: [
                      Color(0xffBB377D),
                      Color(0xffFBD3E9),
                    ], stops: [
                      0,
                      1.0
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight)
                        .createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn, // Applies the shader to the text
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      name,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        // The color must be white or a light color to ensure the gradient is visible
                        color: Colors.white,
                        fontSize: 20, // Adjust the font size as needed
                      ),
                    ),
                  ),
                ),
        ),
      );

      isWhite = !isWhite;
    }

    return fortuneItems;
  }

  String chooseName(Map<String, int> nameProbabilities) {
    double random = Random().nextDouble();
    double cumulativeProbability = 0.0;
    final numberOfItems =
        nameProbabilities.values.map((e) => e).reduce((a, b) => a + b);

    for (var entry in nameProbabilities.entries) {
      cumulativeProbability += (entry.value / numberOfItems);

      if (random < cumulativeProbability) {
        return entry.key;
      }
    }

    return nameProbabilities.entries.last.key;
  }
}

class CustomTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
              colors: [
                Color(0xFF9B6E23),
                Color(0xffFFFBA4),
                Color(0xFF9B6E23),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5, 1.0])
          .createShader(Rect.fromLTWH(0, -30, size.width, size.height));

    var path = Path();
    path.moveTo(-10, -30);
    path.lineTo(size.width + 10, -30);
    path.lineTo(size.width / 2, size.height - 20);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
