import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
   CustomTextField({this.label, this.hintText,this.onChanged});
   String?label;
   String?hintText;
   Function(String)?onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if(value!.isEmpty){
          return 'Required*';
        }
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),//
         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow),),

        label: Text(
          "$label",
          style: TextStyle(color: Colors.white),
        ),
        hintText: "$hintText",
        hintStyle: TextStyle(color: Colors.white),
      ),
      onChanged:onChanged ,
    );
  }
}
