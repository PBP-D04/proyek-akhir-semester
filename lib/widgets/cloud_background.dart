import 'package:flutter/material.dart';

class CloudBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: CloudPainter(),
    );
  }
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3) // Warna awan
      ..style = PaintingStyle.fill;

    final path = Path();

    // Menggambar bentuk awan
    path.moveTo(0, size.height);
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.55, size.width * 0.4, size.height * 1.2);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.95, size.width * 0.8, size.height * 1.2);
    path.quadraticBezierTo(size.width * 1.0, size.height * 0.55, size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
