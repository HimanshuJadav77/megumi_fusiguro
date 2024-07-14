import 'package:flutter/material.dart';

class elevated extends StatelessWidget {
  const elevated({super.key, required this.onTab, required this.text});

  final VoidCallback onTab;
  final String text;



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: ShapeDecoration(
            color: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
