import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final String apiUrl = "https://socialwaves.in/api/";

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      print(_selectedImage);
      // uploadImage(_selectedImage!);
    } else {
      print("No image selected");
    }
  }

  // Future<void> uploadImage(BuildContext context) async {
  //   if (_selectedImage == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please select and crop an image first')),
  //     );
  //     return;
  //   }

  //   try {
  //     // Set up the request headers and parameters
  //     final headers = {
  //       "Content-Type": "multipart/form-data",
  //       "Cookie": "identify_upload_file=api_frame_1568_random1234",
  //     };

  //     final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //     request.headers.addAll(headers);

  //     // Attach the image file
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'image',
  //         _selectedImage!.path,
  //         contentType: MediaType('image', 'png'),
  //         filename: basename(_selectedImage!.path),
  //       ),
  //     );

  //     // Add additional form data
  //     request.fields['frame_id'] = '10'; // Example frame ID
  //     request.fields['name'] = 'SampleImage';

  //     // Send the request
  //     final response = await request.send();

  //     if (response.statusCode == 200) {
  //       final responseData = await http.Response.fromStream(response);
  //       final responseBody = jsonDecode(responseData.body);

  //       if (responseBody['resp'] == 1) {
  //         final imageUrl = responseBody['data'];
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Image uploaded successfully!')),
  //         );
  //         print('Processed Image URL: $imageUrl');
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to upload image')),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Server error: ${response.statusCode}')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload and Crop Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150, width: 250)
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                pickImage();
              },
              child: Text('Pick and Crop Image'),
            ),
            ElevatedButton(
              onPressed: () {
                uploadImage(_selectedImage!);
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage(File imageFile) async {
    print(imageFile.path);
    try {
      var uri = Uri.parse('https://socialwaves.in/api/');
      // var request = http.MultipartRequest('POST', uri);
      var request = http.MultipartRequest('POST', uri);
      // Add the file
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Add other form fields
      request.fields['frame_id'] = '3100'; // Example frame ID
      request.fields['name'] = 'Test Image';

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Cookie'] = 'identify_upload_file=api_frame_3100_123456';

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var responseBody = responseData.body;
        print("Image uploaded successfully: $responseBody");
      } else {
        print("Image upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }
}
