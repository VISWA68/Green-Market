import 'package:flutter/material.dart';
import 'package:green_vault/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:green_vault/model/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final creditProvider = Provider.of<TotalCredits>(context);

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'PROFILE',
          style: GoogleFonts.openSans(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.green.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                userProvider.imageUrl.toString(),
                height: 150,
                width: 150,
              ),

              const SizedBox(height: 20),

              // User Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${userProvider.authPerson ?? ''}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 10),
                    Text("Email: ${userProvider.email ?? ''}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 10),
                    Text("Contact: ${userProvider.conNum ?? ''}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Address: ${userProvider.address ?? ''}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 10),
                    Text("Total Credits: ${creditProvider.totalCredits ?? ''}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(
                      height: 34,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  minimumSize: const Size(150, 50), // Box shape with full width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Box shape (no rounded corners)
                  ),
                ),
                child: Text(
                  "LOGOUT",
                  style: GoogleFonts.openSans(
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
