import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:green_vault/model/user_provider.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final totalCreditsProvider = Provider.of<TotalCredits>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              "Welcome ${userProvider.authPerson.toString()}!!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "Your Credit Balance",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 14,
                color: Colors.green.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalCreditsProvider.totalCredits.toString(),
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Image(
                      height: 80,
                      width: 80,
                      image: Svg(
                        "asset/token.svg",
                        source: SvgSource.asset,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 44,
            ),
            const Text(
              "Your Transactions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      )),
    );
  }
}
//