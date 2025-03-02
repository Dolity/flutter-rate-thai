import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class CompletedSuperAdminPage extends StatefulWidget {
  @override
  _CompletedSuperAdminPageState createState() =>
      _CompletedSuperAdminPageState();
}

class _CompletedSuperAdminPageState extends State<CompletedSuperAdminPage> {
  void updateUserStatus(String userId) async {
    try {
      final documentReference =
          FirebaseFirestore.instance.collection('usersPIN').doc(userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          transaction.update(documentReference, {
            'ConditionCheckAdmin': false,
            'ReservationStatusAdmin': false,
            'isVerify': false,
          });
        }
      });

      print('User data updated successfully!');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  void showUserDataDialog(Map<String, dynamic> userData) async {
    final String firstName = userData['FirstName'] ?? '';
    final String lastName = userData['LastName'] ?? '';

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usersPIN')
        .where('FirstName', isEqualTo: firstName)
        .where('LastName', isEqualTo: lastName)
        .get();

    if (querySnapshot.size == 1) {
      final String userId = querySnapshot.docs.first.id;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('User Information'),
                content: Container(
                  height: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: GestureDetector(
                          onTap: () => showImageDialog(userData['imageUrl']),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: userData['imageUrl'] != null
                                ? NetworkImage(userData['imageUrl'] as String)
                                : AssetImage(
                                        'assets/default_profile_picture.jpg')
                                    as ImageProvider<Object>,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Name: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${userData['FirstName'] ?? 'Null'} ${userData['LastName'] ?? 'Null'}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Gender: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['Gender'] ?? 'Null'}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Date: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${userData['DayofBirth'] ?? 'Null'}:${userData['MonthofBirth'] ?? 'Null'}:${userData['YearofBirth'] ?? 'Null'}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'ID Card Number: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['IDCardNumber'] ?? 'Null'}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Phone Number: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${userData['PhoneNumber']}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      updateUserStatus(userId);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Retired'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ));
    } else {
      print(
          'Cannot find unique user with firstName: $firstName and lastName: $lastName');
    }
  }

  void showImageDialog(String? imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: imageUrl != null
            ? Image.network(imageUrl, fit: BoxFit.contain)
            : Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usersPIN').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final bool isAdminStatusTrue =
                  userData['ConditionCheckAdmin'] == true &&
                      userData['ReservationStatusAdmin'] == true;
              if (isAdminStatusTrue) {
                final String firstName = userData['FirstName'];
                final String lastName = userData['LastName'];
                final String gender = userData['Gender'];
                final String dayOfBirth = userData['DayofBirth'];
                final String monthOfBirth = userData['MonthofBirth'];
                final String yearOfBirth = userData['YearofBirth'];
                final String idCardNumber = userData['IDCardNumber'];
                final String phoneNumber = userData['PhoneNumber'];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => showUserDataDialog(userData),
                    child: ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('$firstName $lastName ($gender)'),
                      subtitle: Text(
                          '$dayOfBirth:$monthOfBirth:$yearOfBirth, $idCardNumber, $phoneNumber'),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
