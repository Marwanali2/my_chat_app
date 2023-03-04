import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
   CustomButton({this.text,this.onPressed});
  String?text;
  VoidCallback?onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          minimumSize: MaterialStateProperty.all(Size(double.infinity,40)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
      ),
      onPressed: onPressed,
      child: Text(
        "$text",
        style: TextStyle(
            color: Color.fromRGBO(41, 68, 97, 1),
            fontSize: 20
        ),
      ),
    );
  }
}
