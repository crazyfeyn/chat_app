import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/firebase_servrices.dart';
import 'package:flutter_application_1/views/screens/sign_in_screen.dart';
import 'package:flutter_application_1/views/screens/user_seperate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebaseServices = FirebaseServices();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1F2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1F2A),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            ),
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(50)),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10)
        ],
        leading: Container(
          alignment: Alignment.center,
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        leadingWidth: 60,
        centerTitle: true,
        title: Text(
          currentUserEmail,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: firebaseServices.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final users = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = UserModel.fromQuery(users[index]);
                List<String> sortedList = [user.email, currentUserEmail]
                  ..sort((a, b) => a.compareTo(b));
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSeperateScreen(
                                senderId: currentUserId,
                                receiverId: user.uid,
                                chrId: sortedList.join(''),
                                firebaseServices: firebaseServices,
                                receiverEmail: user.email,
                                senderEmail: currentUserEmail,
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          user.email == currentUserEmail
                              ? 'S'
                              : user.email[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ),
                      title: user.email == currentUserEmail
                          ? const Text(
                              'Saved messages',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          : Text(
                              user.email.length > 22
                                  ? "${user.email.substring(0, 23)}..."
                                  : user.email,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
