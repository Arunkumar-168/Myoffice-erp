import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Pref/SharedPreferenceHelper.dart';
import '../api/constants.dart';
import '../course/common_functions.dart';
import '../online/custom_text.dart';
import '../search/auth.dart';

class UserImagePicker extends StatefulWidget {
  final String? image;
  const UserImagePicker({Key? key, this.image}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;
  final picker = ImagePicker();
  var _isLoading = false;
  bool _isImageUploaded = false;
  String? _uploadedImageUrl;

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _submitImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context,
          listen: false).userImageUpload(_image!);
      CommonFunctions.showSuccessToast('Image uploaded Successfully');
      final token = await SharedPreferenceHelper().getAuthToken();
      var link = BaseURL + 'userdata?auth_token=$token';
      final res = await http.get(Uri.parse(link));
      final resData = json.decode(res.body);
      await SharedPreferenceHelper().setUserImage(resData['image'].toString());
      setState(() {
        _uploadedImageUrl = resData['image'].toString();
        _isImageUploaded = true;
      });
    } on HttpException {
      var errorMsg = 'Upload failed.';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      const errorMsg = 'Upload failed.';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : NetworkImage(_uploadedImageUrl ?? widget.image.toString()) as ImageProvider,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: FittedBox(
                        child: FloatingActionButton(
                          elevation: 1,
                          onPressed: _pickImage,
                          tooltip: 'Choose Image',
                          backgroundColor: Colors.white,
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        if (_image != null && !_isImageUploaded)
          _isLoading
              ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          )
              : ElevatedButton.icon(
            onPressed: _submitImage,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
              backgroundColor: Colors.orange,
            ),
            icon: const Icon(
              Icons.file_upload,
              color: Colors.white,
            ),
            label: const CustomText(
              text: 'Upload Image',
              fontSize: 14,
              colors: Colors.white,
            ),
          ),
      ],

    );
  }
}
