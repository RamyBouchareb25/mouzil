import 'package:tomboula/features/auth/presentation/widgets/login.dart';
import 'package:tomboula/features/auth/presentation/widgets/sign_up.dart';
import 'package:flutter/material.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(height / 3.5), // Set the desired height
          child: CustomPaint(
            painter: _ClipShadowShadowPainter(
                shadow: const Shadow(
                  color: Color.fromARGB(255, 131, 130, 130),
                  blurRadius: 35,
                  offset: Offset(0, 0),
                ),
                clipper: CustomAppBarClipper()),
            child: ClipPath(
              clipper: CustomAppBarClipper(),
              child: AppBar(
                backgroundColor: Colors.white,
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Image.asset(
                          "assets/images/mozil.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                bottom: TabBar(

                  labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: UnderlineTabIndicator(
                      insets: const EdgeInsets.symmetric(horizontal: 50),
                      borderSide: BorderSide(
                          width: 4.0,
                          color: Theme.of(context).colorScheme.primary)),
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(
                      text: "Login",
                    ),
                    Tab(
                      text: "Sign-up",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            LoginPage(),
            SignUpPage(),
          ],
        ),
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.cubicTo(0, size.height - 20, 0, size.height, 30, size.height);
    path.lineTo(size.width - 30, size.height);
    path.cubicTo(size.width - 30, size.height, size.width, size.height,
        size.width, size.height - 20);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
