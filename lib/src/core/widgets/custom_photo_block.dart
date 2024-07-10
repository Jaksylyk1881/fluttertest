import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PhotoBlock extends StatefulWidget {
  final String title;
  final Function(File?) onPhotoChanged;

  const PhotoBlock({
    super.key,
    required this.title,
    required this.onPhotoChanged,
  });

  @override
  _PhotoBlockState createState() => _PhotoBlockState();
}

class _PhotoBlockState extends State<PhotoBlock> {
  File? _imageFile;

  Future<void> _addPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      widget.onPhotoChanged(_imageFile);
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      widget.onPhotoChanged(_imageFile);
    }
  }

  void _removePhoto() {
    setState(() {
      _imageFile = null;
    });
    widget.onPhotoChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xffF1F4F9),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              if (_imageFile != null)
                ElevatedButton(
                  onPressed: _removePhoto,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    'Убрать все',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: Color(0xff2C638B)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_imageFile == null)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    onPressed: _addPhoto,
                    backgroundColor: const Color(0xffD4E4F6),
                    label: Text(
                      'Добавить',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                          color: Color(0xff0D1D2A)),
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    icon: const Icon(Icons.add_a_photo_outlined),
                    onPressed: () {
                      _takePhoto();
                    },
                    backgroundColor: const Color(0xffD4E4F6),
                    label: const Text(
                      'Сделать снимок',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                          color: Color(0xff0D1D2A)),
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
          if (_imageFile != null)
            Center(
              child: Column(
                children: [
                  Image.file(
                    _imageFile!,
                    height: 300,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
