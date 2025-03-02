// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/page/Reservation/reservaServices.dart';
import 'package:testprojectbc/screen/detailBlockchain.dart';

class testBCNoDel extends StatefulWidget {
  const testBCNoDel({Key? key}) : super(key: key);

  @override
  State<testBCNoDel> createState() => _testBCNoDelState();
}

class _testBCNoDelState extends State<testBCNoDel> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late Map<String, dynamic> snapshotData = {};

  void getUIDonFS() async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(userUID).get();
    setState(() {
      snapshotData = snapshot.data() as Map<String, dynamic>;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUIDonFS();
  }

  @override
  Widget build(BuildContext context) {
    var notesServices = context.watch<NotesServices>();
    print(notesServices.notes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data in Ethereum Sepolia Testnet'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('usersPIN')
              // .where('QRCode.Agency', isEqualTo: agencyValue)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final users = snapshot.data!.docs;

            return notesServices.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await notesServices.fetchNotes();
                    },
                    child: ListView.builder(
                      itemCount: notesServices.notes.length,
                      itemBuilder: (context, index) {
                        final note = notesServices.notes[index];
                        final userData =
                            users[index].data() as Map<String, dynamic>;
                        final dropOff = userData['DropOffStatus'];

                        print('fs : $dropOff');

                        if (note.agencyBC == snapshotData['agency']) {
                          // if (userData['DropOffStatus'] == true) {
                          //   print(
                          //       'conditionCheck True : ${userData['DropOffStatus']}');
                          return Column(
                            children: [
                              ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    text:
                                        '${notesServices.notes[index].firstnameBC} ${notesServices.notes[index].lastnameBC} (${notesServices.notes[index].genderBC}) ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      // TextSpan(
                                      //   text: dropOff
                                      //       ? 'Complete \u2714'
                                      //       : 'Fail \u2716',
                                      //   style: TextStyle(
                                      //     color: dropOff
                                      //         ? Colors.green
                                      //         : Colors
                                      //             .red, // เปลี่ยนสีตามเงื่อนไข
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                subtitle: Text(
                                  '${notesServices.notes[index].agencyBC} ${notesServices.notes[index].rateBC} ${notesServices.notes[index].amountBC} ${notesServices.notes[index].currencyBC}, ${notesServices.notes[index].totalBC} THB, ${notesServices.notes[index].dateBC}',
                                ),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBCPage(
                                        firstnameBC: notesServices
                                            .notes[index].firstnameBC,
                                        lastnameBC: notesServices
                                            .notes[index].lastnameBC,
                                        genderBC:
                                            notesServices.notes[index].genderBC,
                                        agencyBC:
                                            notesServices.notes[index].agencyBC,
                                        rateBC:
                                            notesServices.notes[index].rateBC,
                                        currencyBC: notesServices
                                            .notes[index].currencyBC,
                                        totalBC:
                                            notesServices.notes[index].totalBC,
                                        dateBC:
                                            notesServices.notes[index].dateBC,
                                        amountBC:
                                            notesServices.notes[index].amountBC,
                                      ),
                                    ),
                                  );
                                  Divider(color: Colors.black);
                                },
                              ),
                              Divider(color: Colors.black),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  );
          }),
    );
  }
}
