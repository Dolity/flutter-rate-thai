import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http; // เพิ่ม import นี้

class AdminListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete List'),
      ),
      body: AdminListView(),
    );
  }
}

class AdminListView extends StatefulWidget {
  @override
  _AdminListViewState createState() => _AdminListViewState();
}

class _AdminListViewState extends State<AdminListView> {
  final emailController = TextEditingController();
  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextFormField for searching
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: searchTextController,
            decoration: InputDecoration(
              labelText: 'Search by Email',
            ),
            onChanged: (_) {
              setState(
                  () {}); // Trigger the rebuild when the text in the search field changes
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('usersPIN').where(
                'role',
                whereIn: ['admin', 'agency', 'user']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No admin users found.'),
                );
              }

              // Filter the data based on the displayName matching the search text
              final filteredData = snapshot.data!.docs.where((doc) {
                final adminData = doc.data() as Map<String, dynamic>;
                final displayName = adminData['displayName'] as String? ?? '';
                final searchText =
                    searchTextController.text.trim().toLowerCase();
                return displayName.toLowerCase().contains(searchText);
              }).toList();

              if (filteredData.isEmpty) {
                return const Center(
                  child: Text('No matching admin users found.'),
                );
              }

              return ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final adminData =
                      filteredData[index].data() as Map<String, dynamic>;
                  final displayName =
                      adminData['displayName'] as String? ?? 'Unknown';
                  final adminId = filteredData[index].id;
                  final adminEmail = adminData['email'] as String? ?? '';

                  return ListTile(
                    title: Text(displayName),
                    subtitle: Text(adminEmail),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(
                          context,
                          adminId,
                          displayName,
                          adminEmail,
                        );
                      },
                    ),
                    onTap: () {
                      // Print the email and displayName to the console
                      print('Name: $displayName\nEmail: $adminEmail');

                      // Show a SnackBar with the email or displayName when the ListTile is tapped
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Name: $displayName\nEmail: $adminEmail'),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    String adminId,
    String displayName,
    String adminEmail,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete $displayName ?'),
              // TextFormField(
              //   controller: emailController,
              //   decoration: InputDecoration(
              //     labelText: 'Email',
              //     hintText: 'Enter the email',
              //   ),
              // ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Accept'),
              onPressed: () async {
                // Get the email from the input field
                final enteredEmail = emailController.text.trim();
                // Print the displayName and enteredEmail
                print(
                    'Deleting account of: $displayName, Entered Email: $enteredEmail');

                // Perform the deletion process with the enteredEmail
                await deleteUserAccount(displayName);

                // Clear the emailController
                emailController.clear();

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUserAccount(String email) async {
    print(email);
    try {
      final apiUrl = 'https://fire-store-api.vercel.app/disableUser/$email';  //Del doc, authen = https://fire-store-api.vercel.app/deleteAll/

      final response = await http.delete(
        Uri.parse(apiUrl),
        // You may or may not need to provide a request body, depending on your API
        // body: {'email': email},
      );
      if (response.statusCode == 200) {
        print('User account deleted successfully.');
      } else {
        print('Failed to delete user account: ${response.body}');
      }
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }
}
