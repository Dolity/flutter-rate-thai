import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

import 'package:testprojectbc/page/Navbar/loginsuccess.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _idCardNumberController = TextEditingController();
  TextEditingController _idCardBackNumberController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  List<String> _days = List.generate(31, (index) => (index + 1).toString());
  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> _years =
      List.generate(100, (index) => (2023 - index).toString());

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;
  bool keepStatusAdmin = false;
  bool checkStatusAdmin = false;
  bool? isVerify = false;

  XFile? _selectedImage; // For Flutter image picker
  String? _imageName;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage;

    // Show an action sheet to choose between camera and gallery
    final actionSheet = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context, 0); // 0 represents camera option
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context, 1); // 1 represents gallery option
              },
            ),
          ],
        );
      },
    );

    // Based on the selected option, either take a photo or pick from gallery
    if (actionSheet == 0) {
      pickedImage = await _picker.pickImage(source: ImageSource.camera);
    } else if (actionSheet == 1) {
      pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _selectedImage = pickedImage;
      if (_selectedImage != null) {
        _imageName = pickedImage?.name;
      }
    });
  }

  void verifyUser() {
    // โค้ดเพื่อทำการยืนยันตัวตนของผู้ใช้
    bool verificationSuccess =
        true; // ตั้งค่าเป็น true เมื่อการยืนยันตัวตนสำเร็จ
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop(
          verificationSuccess); // ส่งผลลัพธ์การยืนยันตัวตนกลับไปยังหน้า ReservationNav
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      UserSingleton().setUID(uid);
    }
    String? uid = UserSingleton().uid;
    print("Click UID: ${uid}");
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.document_text_outline,
                      color: Colors.grey,
                    ),
                    hintText: "First Name",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _lastNameController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.document_text_outline,
                      color: Colors.grey,
                    ),
                    hintText: "Last Name",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 16),
              Text(
                'Date Of Birth',
                style: GoogleFonts.nunitoSans(),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDay,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDay = newValue;
                        });
                      },
                      items: _days.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                        labelText: 'Day',
                        labelStyle:
                            GoogleFonts.nunitoSans(), // สีของข้อความ 'วัน'
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 150, // กำหนดความกว้างสูงสุดที่ต้องการ
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedMonth,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMonth = newValue;
                        });
                      },
                      items: _months.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                        labelText: 'Month',
                        labelStyle:
                            GoogleFonts.nunitoSans(), // สีของข้อความ 'วัน'
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedYear,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedYear = newValue;
                        });
                      },
                      items: _years.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                        labelText: 'Year',
                        labelStyle:
                            GoogleFonts.nunitoSans(), // สีของข้อความ 'วัน'
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 16),
              // Text(
              //   'Gender',
              //   style: GoogleFonts.nunitoSans(),
              // ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                  labelText: 'Gender',
                  labelStyle:
                      TextStyle(color: Colors.black), // สีของข้อความ 'วัน'
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                    borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _idCardNumberController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.card_outline,
                      color: Colors.grey,
                    ),
                    hintText: "ID Card Code",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _idCardBackNumberController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  prefixIcon: Icon(
                    Ionicons.card_outline,
                    color: Colors.grey,
                  ),
                  hintText: "ID Laser Card Code",
                  hintStyle: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600, color: Colors.black38),
                  fillColor: Colors.black12,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _phoneNumberController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.phone_portrait_outline,
                      color: Colors.grey,
                    ),
                    hintText: "Phone Number",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              // Image selection widget
              SizedBox(height: 16),
              ElevatedButtonTheme(
                data: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    primary: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text(
                    _imageName != null ? 'Selected: $_imageName' : 'Pick Image',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButtonTheme(
                data: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    primary: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_areFieldsValid()) {
                      _submitForm();
                    } else {
                      _showIncompleteFieldsDialog();
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showIncompleteFieldsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(38),
          ),
          elevation: 0,
          title: Text('Incomplete Fields'),
          content: Text('Please fill in all fields.'),
          actions: <Widget>[
            ElevatedButtonTheme(
              data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  primary: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // ปิด Dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _areFieldsValid() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _selectedDay != null &&
        _selectedMonth != null &&
        _selectedYear != null &&
        _selectedGender != null &&
        _idCardNumberController.text.isNotEmpty &&
        _idCardBackNumberController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty;
  }

  void _submitForm() async {
    // ตัวอย่างโค้ดเพิ่มการอัปโหลดรูปภาพเข้าไปในฟังก์ชัน _submitForm
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String? day = _selectedDay;
    String? month = _selectedMonth;
    String? year = _selectedYear;
    String? gender = _selectedGender;
    String idCardNumber = _idCardNumberController.text;
    String idCardBackNumber = _idCardBackNumberController.text;
    String phoneNumber = _phoneNumberController.text;

    // If an image was selected, upload it to Firebase Storage and get the download URL
    String? imageUrl;
    if (_selectedImage != null) {
      String imagePath = _selectedImage!.path;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(_selectedImage!.name);
      UploadTask uploadTask = storageRef.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        imageUrl = await snapshot.ref.getDownloadURL();
      }
    }

// Assuming you have defined the 'imageUrl' variable as mentioned before

// Update the Firestore document with the additional image URL
    final user = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await usersRef.doc(user).get();

    if (snapshot.exists) {
      print('Updating data');

      Map<String, dynamic> userData = snapshot.data()!;

      // Update the fields with the new values
      userData['FirstName'] = firstName;
      userData['LastName'] = lastName;
      userData['DayofBirth'] = day;
      userData['MonthofBirth'] = month;
      userData['YearofBirth'] = year;
      userData['Gender'] = gender;
      userData['IDCardNumber'] = idCardNumber;
      userData['IDCardBackNumber'] = idCardBackNumber;
      userData['PhoneNumber'] = phoneNumber;
      userData['ReservationStatusAdmin'] = checkStatusAdmin;
      userData['ConditionCheckAdmin'] = keepStatusAdmin;
      userData['isVerify'] = isVerify;

      // If the image URL is not null, update it as well
      if (imageUrl != null) {
        userData['imageUrl'] = imageUrl;
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginSuccessPage();
      }));

      // Update the Firestore document with the new data
      usersRef.doc(user).update(userData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Save to reservation on Firestore Success! (Update)'),
            duration: Duration(seconds: 2),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save reservation on Firestore! (Update)'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } else {
//       // The document does not exist, handle the case if needed
      print('Document does not exist!');
    }

    void _clearFormFields() {
      _firstNameController.clear();
      _lastNameController.clear();
      _selectedDay = null;
      _selectedMonth = null;
      _selectedYear = null;
      _selectedGender = null;
      _idCardNumberController.clear();
      _idCardBackNumberController.clear();
      _phoneNumberController.clear();
    }
  }
}
