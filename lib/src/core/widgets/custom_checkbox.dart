import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final String label;
  final ValueChanged<bool> onChanged;
  final bool initialValue;

  const CustomCheckbox({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue = false,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    _isChecked = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (bool? newValue) {
            setState(() {
              _isChecked = newValue!;
            });
            widget.onChanged(_isChecked);
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        Text(widget.label),
      ],
    );
  }
}
