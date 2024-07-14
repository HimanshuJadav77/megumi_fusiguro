import 'package:flutter/material.dart';


class textfield extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData icon;
  final keyboard;
  final length;


  textfield({required this.textEditingController, this.isPass = false,required this.hintText,required this.icon,this.keyboard, this.length});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        maxLength: length,
       keyboardType: keyboard,
        obscureText: isPass,
        controller: textEditingController,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          hintText: hintText,
          prefixIcon: Icon(icon,color:Colors.black45),
          contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
          border: InputBorder.none,
          filled: true,
          fillColor: Color(0xFFedf0f8),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
