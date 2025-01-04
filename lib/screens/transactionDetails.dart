import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import 'package:date_palm_challenge/constent/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
import '../constent/app_size.dart';
import '../servise/notifications.dart';

class TransactionDetailScreen extends StatefulWidget {
  final String
      docId; // Only pass the document ID, as we will use it to stream data

  TransactionDetailScreen({Key? key, required this.docId}) : super(key: key);

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  File? _imageFile; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker(); // Initialize image picker

  String? stringForRec;
  String userName = "";
  String reciptImage = "";
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      final bytes = await _imageFile!.readAsBytes();

      Navigator.of(context).pop();
      _showUploadDialog(context);
    }
  }

  Future<void> _pickImageForRec(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    // if (pickedFile != null) {
    //   setState(() {
    //     _imageFile = File(pickedFile.path);
    //   });
    //   final bytes = await _imageFile!.readAsBytes();
    //   stringForRec = base64Encode(bytes);
    //   Navigator.of(context).pop();
    //   _showUploadDialogForRec(context);
    // }

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Read the image bytes
      final bytes = await _imageFile!.readAsBytes();

      // Decode the image using the `image` package
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage != null) {
        // Resize the image to 366x435 pixels
        img.Image resizedImage =
            img.copyResize(originalImage, width: 366, height: 435);

        // Convert the image to PNG format
        Uint8List pngBytes = Uint8List.fromList(img.encodePng(resizedImage));

        // Write the resized PNG image back to `_imageFile`
        await _imageFile!.writeAsBytes(pngBytes);

        // Encode the resized image to Base64
        stringForRec = base64Encode(pngBytes);

        // Navigate and show the upload dialog
        Navigator.of(context).pop();
        _showUploadDialogForRec(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.fontMedium,
            fontFamily: 'latto',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('contributions')
              .doc(widget.docId)
              .snapshots(), // Stream the document from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('No data available.'));
            }

            var transaction = snapshot.data!.data() as Map<String, dynamic>;

            userName = transaction['contributorName'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.buttonColor3),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contributor: ${transaction['contributorName'].toString().toUpperCase()}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Phone Number: ${transaction['phoneNumber']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Address: ${transaction['address']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Count: ${transaction['count']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Total Amount: ${transaction['count']} * 500 = ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${transaction['count'] * 500}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildStatusText("Payment Status: ",
                                      transaction['paymentStatus']),
                                  SizedBox(width: 10),
                                  if (transaction['paymentStatus'] ==
                                      "not paid")
                                    GestureDetector(
                                      onTap: () {
                                        _showUploadDialog(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.attach_file,
                                            color: const Color.fromARGB(
                                                255, 243, 33, 61),
                                          ),
                                          Text(
                                            " - Upload Screenshot",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Delivery: ${transaction['isDeliver'] == "Not Delivered" ? "Not Delivered" : "Delivered"}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showUploadDialogForRec(context);
                          },
                          child: Text('Photo Receipt'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (reciptImage != "")
                      Container(
                        child: Screenshot(
                            controller: screenshotController,
                            child: Image(image: NetworkImage(reciptImage))),
                      ),
                    if (reciptImage != "") SizedBox(height: 10),
                    if (reciptImage != "")
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors
                                .buttonColor2, // Button background color
                            foregroundColor: Colors.white, // Button text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                            elevation: 5, // Shadow elevation
                          ),
                          onPressed: () {
                            print(reciptImage);
                            Platform.isAndroid
                                ? downloadAndShareReceipt(reciptImage)
                                : _takeAndSaveScreenshot();
                          },
                          child: Text(Platform.isAndroid
                              ? 'Download and Share'
                              : "Take ScreenShot and Share"),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusText(String label, String status) {
    Color statusColor;

    if (label == 'Payment Status: ') {
      if (status == "not paid") {
        statusColor = Colors.red;
      } else if (status == "Pending") {
        statusColor = Colors.orange;
      } else {
        statusColor = Colors.green;
      }
    } else {
      statusColor = status == 'Not Delivered' ? Colors.red : Colors.green;
    }

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '${status == "not paid" ? "Not Paid" : status == "Pending" ? "Pending" : "Paid"}',
          style: TextStyle(fontSize: 16, color: statusColor),
        ),
      ],
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Payment Screenshot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_imageFile != null)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _imageFile!,
                      width: 100,
                      height: 100,
                      fit: BoxFit
                          .cover, // Ensure the image fits well within the box
                    ),
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library),
                label: Text('Choose from Gallery'),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _imageFile = null;
                  _imageFile = null;
                  Navigator.of(context).pop();
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                print("--");
                try {
                  if (_imageFile != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    try {
                      String fileName =
                          'payment_proof_${DateTime.now().millisecondsSinceEpoch}.png';
                      print(fileName);
                      // Reference storageReference =
                      //     FirebaseStorage.instance.ref().child('qr/$fileName');
                      // UploadTask uploadTask =
                      //     storageReference.putFile(_imageFile!);
                      // print(uploadTask);
                      // // Wait for the upload to complete
                      // TaskSnapshot taskSnapshot = await uploadTask;

                      // // Step 2: Get the download URL after the upload is complete
                      // String downloadUrl =
                      //     await taskSnapshot.ref.getDownloadURL();

                      final firbase_storage.FirebaseStorage storage =
                          firbase_storage.FirebaseStorage.instance;
                      firbase_storage.TaskSnapshot taskSnapshot = await storage
                          .ref('screenshots/$fileName')
                          .putFile(_imageFile!);
                      final String downloadUrl =
                          await taskSnapshot.ref.getDownloadURL();

                      print(downloadUrl);

                      await FirebaseFirestore.instance
                          .collection('contributions')
                          .doc(widget.docId)
                          .update({
                        "paymentProof": downloadUrl,
                        "paymentStatus": "Pending",
                      });
                      setState(() {
                        _imageFile = null;
                        _imageFile = null;
                      });
                      Navigator.pop(context); // Close the progress dialog
                      Navigator.pop(context); // Close the upload dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Payment Proof and Status updated successfully')),
                      );
                    } catch (e) {
                      setState(() {
                        _imageFile = null;
                        _imageFile = null;
                      });
                      Navigator.pop(context); // Close the progress dialog
                      Navigator.pop(context); // Close the upload dialog
                      print("Error updating Firestore: $e");
                    }
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No image selected to upload')),
                    );
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showUploadDialogForRec(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Download Partcipation Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (stringForRec != null)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(stringForRec!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _pickImageForRec(ImageSource.gallery),
                icon: Icon(Icons.photo_library),
                label: Text('Choose from Gallery'),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  stringForRec = null;
                  _imageFile = null;
                  Navigator.of(context).pop();
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (stringForRec != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  try {
                    uploadImage();

                    // Navigator.pop(context); // Close the progress dialog
                    // Navigator.pop(context); // Close the upload dialog
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //       content: Text(
                    //           'Payment Proof and Status updated successfully')),
                    // );
                  } catch (e) {
                    Navigator.pop(context); // Close the progress dialog
                    Navigator.pop(context); // Close the upload dialog
                    print("Error updating Firestore: $e");
                  }
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an image first')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  final url = "https://socialwaves.in/api/";

  Future<void> uploadImage() async {
    var uri = Uri.parse('https://socialwaves.in/api/');
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    try {
      String random4Digit = generateRandom4DigitNumber();

      var request = http.MultipartRequest('POST', uri);
      // Add the file
      request.files
          .add(await http.MultipartFile.fromPath('image', _imageFile!.path));

      // Add other form fields
      request.fields['frame_id'] = '3100'; // Example frame ID
      request.fields['name'] = userName;

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Cookie'] =
          'identify_upload_file=api_frame_3100_${random4Digit}';

      // Send the request
      var response = await request.send();

      // if (response.statusCode == 200) {
      //   var responseData = await http.Response.fromStream(response);
      //   var responseBody = responseData.body;
      //   print("Image uploaded successfully: $responseBody");
      // } else {
      //   print("Image upload failed: ${response.statusCode}");
      // }
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseBody = jsonDecode(responseData.body);

        if (responseBody['resp'] == 1) {
          final imageUrl = responseBody['data'];

          reciptImage = "https://socialwaves.in/${imageUrl}";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully!')),
          );

          setState(() {});
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image')),
          );
        }
      } else {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  final imageUrl = "";
  bool _isDownloading = false;
  generateRandom4DigitNumber() {
    final random = Random();
    int randomNumber =
        1000 + random.nextInt(9000); // Generates a number between 1000 and 9999
    return randomNumber.toString();
  }

  // void downloadAndShareReceipt(String phtohUrl) async {
  //   // share plus
  //   setState(() {
  //     _isDownloading = true;
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Padding(
  //         padding: const EdgeInsets.only(top: 8.0),
  //         child: Row(
  //           children: [
  //             Text("Downloading...."),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  //   try {
  //     // Request storage permission
  //     if (await _requestStoragePermission()) {
  //       // Get the Downloads directory
  //       // final directory = Directory('/storage/emulated/0/Download');
  //       // final filePath = '${directory.path}/qr_code.png';
  //       final directory = await getExternalStorageDirectory();
  //       final filePath = '${directory!.path}/receipt_image.png';
  //       // Download the image from the URL
  //       final response = await http.get(Uri.parse(phtohUrl));

  //       if (response.statusCode == 200) {
  //         // Write the downloaded image bytes to the file
  //         final file = File(filePath);
  //         await file.writeAsBytes(response.bodyBytes);

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text('Image downloaded successfully at $filePath')),
  //         );
  //         // // Share the downloaded file
  //         // await Share.shareFiles([filePath],
  //         //     text: 'Here is your receipt image.');
  //         await Share.shareXFiles([XFile(filePath)],
  //             text: 'Here is your receipt image.');

  //         // Show download notification
  //         await _showDownloadNotification();
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //               content: Text('Failed to download image: Invalid URL')),
  //         );
  //       }

  //       // // Show download notification
  //       // await _showDownloadNotification();
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Storage permission denied')),
  //       );
  //     }
  //   } catch (e) {
  //     print("------");
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to download: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isDownloading = false;
  //     });
  //   }
  // }

// -------------------------------------------

  // Future<void> downloadAndShareReceipt(String photoUrl) async {
  //   setState(() {
  //     _isDownloading = true;
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Padding(
  //         padding: EdgeInsets.only(top: 8.0),
  //         child: Text("Downloading..."),
  //       ),
  //     ),
  //   );

  //   try {
  //     // Request storage permission for Android (iOS does not require storage permission)
  //     if (Platform.isAndroid && !await _requestStoragePermission()) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Storage permission denied')),
  //       );
  //       return;
  //     }

  //     // // Get a suitable directory for both iOS and Android
  //     // final directory = Platform.isAndroid
  //     //     ? await getExternalStorageDirectory() // Android
  //     //     : await getApplicationDocumentsDirectory(); // iOS
  //     // final filePath = '${directory!.path}/receipt_image.png';

  //     // Save to the public Downloads folder
  //     final directory = Directory('/storage/emulated/0/Download');
  //     String fileName =
  //         'receipt_image_${DateTime.now().millisecondsSinceEpoch}.png';
  //     final filePath = '${directory.path}/$fileName';
  //     // final filePath = '${directory.path}/receipt_image.png';
  //     print(filePath);
  //     // Share.share('Share Image: $filePath');
  //     // Download the image from the URL
  //     final response = await http.get(Uri.parse(photoUrl));

  //     if (response.statusCode == 200) {
  //       // Write the downloaded image bytes to the file
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Image downloaded successfully at $filePath')),
  //       );

  //       // Optionally, show a download notification (Android only)
  //       if (Platform.isAndroid) {
  //         await _showDownloadNotification();
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('Failed to download image: Invalid URL')),
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to download image: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isDownloading = false;
  //     });
  //   }
  // }

  // Future<bool> _requestStoragePermission() async {
  //   // Handle permission request for Android 13+ (API level 33)
  //   if (Platform.isAndroid && (await Permission.storage.isDenied)) {
  //     var status = await Permission.storage.request();
  //     if (status.isGranted) return true;

  //     // For Android 13+ use READ_MEDIA_IMAGES permission
  //     if (await Permission.mediaLibrary.request().isGranted) return true;
  //   }
  //   return false;
  // }

  Future<void> downloadAndShareReceipt(String photoUrl) async {
    setState(() {
      _isDownloading = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("Downloading..."),
        ),
      ),
    );

    try {
      // Request storage permission for Android
      if (Platform.isAndroid && !await _requestStoragePermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      // Request photo library permission for iOS
      if (Platform.isIOS) {
        var photoStatus = await Permission.photos.status;
        if (!photoStatus.isGranted) {
          photoStatus = await Permission.photos.request();
          if (!photoStatus.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Photo library permission denied')),
            );
            return;
          }
        }
      }

      // Download the image from the URL
      final response = await http.get(Uri.parse(photoUrl));

      if (response.statusCode == 200) {
        // Handle saving based on platform
        if (Platform.isAndroid) {
          // Save to Downloads directory for Android
          final directory = Directory('/storage/emulated/0/Download');
          String fileName =
              'receipt_image_${DateTime.now().millisecondsSinceEpoch}.png';
          final filePath = '${directory.path}/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Image downloaded successfully at $filePath')),
          );

          // Show download notification (Android only)
          await _showDownloadNotification();
        } else if (Platform.isIOS) {
          // Save to Photos library for iOS
          final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.bodyBytes),
            name: 'receipt_image_${DateTime.now().millisecondsSinceEpoch}.png',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['isSuccess']
                    ? 'Image saved to Photos successfully'
                    : 'Failed to save image',
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to download image: Invalid URL')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image: $e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Handle permission request for Android 13+ (API level 33)
      if (await Permission.storage.isDenied) {
        var status = await Permission.storage.request();
        if (status.isGranted) return true;

        // For Android 13+ use READ_MEDIA_IMAGES permission
        if (await Permission.mediaLibrary.request().isGranted) return true;
      }
      return false;
    }
    return true; // For iOS, always return true
  }

  Future<void> _showDownloadNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel', // Channel ID
      'Downloads', // Channel name
      channelDescription: 'Notification for downloaded files',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/launcher_icon',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'Photo saved successfully to Downloads folder',
      notificationDetails,
    );
  }

  Future<void> _takeAndSaveScreenshot() async {
    try {
      // Capture the screenshot
      screenshotController.capture().then((Uint8List? image) async {
        print(image);
        if (image != null) {
          // Request permission to access the photo gallery
          final permission = await PhotoManager.requestPermissionExtend();
          if (permission.isAuth) {
            // Get the photo album
            final album = await PhotoManager.editor
                .saveImage(image, filename: 'ScreenShot');
            print(album);
            if (album != null) {
              print('Screenshot saved to gallery');
            }
          } else {
            print('Permission denied to access photo gallery');
          }
        }
      }).catchError((e) {
        print('Error capturing screenshot: $e');
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
