import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {

  final size;
  final barrierWidth;
  MyBarrier({this.size, required this.barrierWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * barrierWidth/2,
      height: MediaQuery.of(context).size.height * 3/4 *size,
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: MediaQuery.of(context).size.width * 0.02/2, color: Colors.green[800]!),
          borderRadius: BorderRadius.circular(5)
      ),
    );
  }
}
