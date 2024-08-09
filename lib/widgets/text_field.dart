import 'package:flutter/material.dart';

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({
    super.key,
    required this.textEditingController,
    required this.header,
    this.prefixText,
    this.hintText,
    this.inputType,
    this.prefixIcon,
    this.maxLength,
    this.enable,
  });

  final TextEditingController textEditingController;
  final String header;
  final String? prefixText;
  final String? hintText;
  final TextInputType? inputType;
  final IconData? prefixIcon;
  final int? maxLength;
  final bool? enable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SizedBox(
            height: 70,
            child: TextFormField(
              enabled: enable,
              maxLength: maxLength,
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: _fieldBorder(),
                  focusedBorder: _fieldBorder(),
                  prefixIcon: Icon(prefixIcon)),
              keyboardType: inputType ?? TextInputType.phone,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _fieldBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Colors.black54,
      ),
      borderRadius: BorderRadius.circular(6.0),
    );
  }
}
