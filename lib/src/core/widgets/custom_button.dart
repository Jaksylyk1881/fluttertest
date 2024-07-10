import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/models/utils/extensions/num_extensions.dart';

class CustomButton extends StatefulWidget {
  final bool isDisabled;
  final Color? color;
  final String? text;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const CustomButton({
    super.key,
    this.isDisabled = false,
    this.color,
    this.text,
    this.onPressed,
    this.isPrimary = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: widget.isDisabled ? null : widget.onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: 100.r,
          color: widget.isPrimary
              ? Theme.of(context).primaryColor
              : (widget.color ?? Colors.white),
          border: Border.all(
            color: widget.isPrimary
                ? Theme.of(context).primaryColor
                : Color(0xFF72787E),
            width: 1.0,
          ),
        ),
        padding: 16.p,
        child: Text(
          widget.text ?? "Button",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.isPrimary
                ? Colors.white
                : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
