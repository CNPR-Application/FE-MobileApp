import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  FocusNode focusNode;
  TextEditingController controller;
  String initText;

  String input;

  InputFieldArea(
      {this.hint,
      this.obscure,
      this.icon,
      this.controller,
      this.focusNode,
      this.initText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: new TextFormField(
        focusNode: focusNode,
        controller: controller,
        onSaved: (input) => input,
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: new InputDecoration(
          icon: new Icon(
            icon,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          contentPadding: const EdgeInsets.only(
            top: 30.0,
            right: 30.0,
            bottom: 30.0,
            left: 5.0,
          ),
        ),
        validator: (input) => input.length < 3
            ? "Characters should be more than 3 characters"
            : null,
      ),
    );
  }
}
