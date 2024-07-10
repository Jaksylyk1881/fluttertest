import 'package:flutter/material.dart';

class MessageService {
  void showMessage({
    required BuildContext context,
    required String message,
    bool isError = false,
    bool hasAction = false,
    String actionLabel = '',
    VoidCallback? onActionPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isError ? const Color(0xff410002) : const Color(0xffEEF1F6),
          ),
        ),
        showCloseIcon: true,
        closeIconColor:
            isError ? const Color(0xffBA1A1A) : const Color(0xffEEF1F6),
        backgroundColor:
            isError ? const Color(0xffFFDAD6) : const Color(0xff2C3134),
        duration: const Duration(milliseconds: 15000),
        width: 344.0,
        padding: const EdgeInsets.only(left: 16.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        action: hasAction
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onActionPressed ?? () {},
                textColor: const Color(0xffBA1A1A),
              )
            : null,
      ),
    );
  }
}
