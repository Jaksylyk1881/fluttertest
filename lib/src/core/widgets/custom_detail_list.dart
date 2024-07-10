import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/services/shared_service.dart';
import 'package:fluttertest/src/core/configs/short_config.dart';

class DetailListWidget extends StatelessWidget {
  final List<ShortEntityConfig> details;
  final String? title;
  final BlockEntityConfig? whiteBlockContent;

  const DetailListWidget({
    required this.details,
    this.title,
    this.whiteBlockContent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SharedService _sharedService = SharedService();

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xffEBEEF3),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6.0,
            offset: Offset(0, 2),
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 2.0,
            offset: Offset(0, 1),
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        children: [
          title == null
              ? const SizedBox.shrink()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF181C20),
                    ),
                  ),
                ),
          const SizedBox(height: 8.0),
          for (int i = 0; i < details.length; i++) ...[
            GestureDetector(
              onTap: details[i].code == 'photo'
                  ? () => _showPhotoDialog(context, details[i].value)
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      details[i].label,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF42474E),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: details[i].code == 'photo'
                            ? 'Посмотреть'
                            : _sharedService.getValue(
                                details[i].value, details[i].code),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: details[i].code == 'photo'
                              ? const Color(0xff2C638B)
                              : const Color(0xff181C20),
                          decoration: details[i].code == 'photo'
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          decorationThickness:
                              details[i].code == 'photo' ? 2.0 : null,
                          decorationColor: details[i].code == 'photo'
                              ? const Color(0xff2C638B)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (details[i].isDivider)
              const Divider()
            else if (i < details.length - 1)
              const SizedBox(height: 8.0),
          ],
          const SizedBox(height: 16.0),

          // white block with description
          if (whiteBlockContent != null)
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      whiteBlockContent!.label,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF181C20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        whiteBlockContent!.description,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF181C20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showPhotoDialog(BuildContext context, String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return;
    }

    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(photoUrl),
                    ],
                  ),
                  Positioned(
                    right: 0.0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ));
  }
}
