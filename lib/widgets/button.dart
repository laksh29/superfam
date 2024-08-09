import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    required this.text,
    this.textColor,
    this.onTap,
  });

  final Color? color;
  final String text;
  final Color? textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.blue[900],
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
