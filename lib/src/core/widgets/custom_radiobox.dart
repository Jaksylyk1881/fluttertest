import 'package:flutter/material.dart';

class CustomRadioBox extends StatefulWidget {
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomRadioBox(
      {super.key,
      required this.options,
      required this.onChanged,
      this.selectedValue});

  @override
  State<CustomRadioBox> createState() => _CustomRadioBoxState();
}

class _CustomRadioBoxState extends State<CustomRadioBox> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8.0),
          //   border: Border.all(color: Colors.transparent),
          // ),
          child: RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
              widget.onChanged(value);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      }).toList(),
    );
  }
}
