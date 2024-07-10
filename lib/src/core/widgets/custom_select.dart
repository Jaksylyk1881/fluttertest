import 'package:flutter/material.dart';

class CustomSelect extends StatefulWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String labelText;

  const CustomSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelText,
  });

  @override
  State<CustomSelect> createState() => _CustomSelectState();
}

class _CustomSelectState extends State<CustomSelect> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedValue,
      onChanged: (newValue) {
        setState(() {
          _selectedValue = newValue;
          debugPrint('CustomSelect: Selected value: $_selectedValue');
        });
        widget.onChanged(newValue);
      },
      icon: _selectedValue == null
          ? const Icon(Icons.keyboard_arrow_down)
          : GestureDetector(
              onTap: () {
                setState(() {
                  _selectedValue = null;
                });
                widget.onChanged(null);
              },
              child: const Icon(Icons.highlight_off),
            ),
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            ),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff7f9ff),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        labelText: widget.labelText,
      ),
    );
  }
}
