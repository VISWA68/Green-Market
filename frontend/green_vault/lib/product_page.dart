import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_vault/model/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:green_vault/model/product_list_model.dart';
import 'package:green_vault/model/product_widget.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<String> imgList = [
    'asset/1.png',
    'asset/2.png',
  ];

  final List<String> categories = [
    'All',
    'Utilities',
    'Travel',
    'Agriculture',
    'Healthcare',
    'Finance',
    'Food and Nutrition',
  ];

  String selectedCategory = 'All';

  final List<Product> products = [
    Product(
        name: "Cylinder",
        description: "Description here",
        price: 500,
        category: 'Utilities',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/helping-hands-834db.appspot.com/o/images%2FCylinder.png?alt=media&token=04a8f231-e260-4825-b3ab-bef4f24866c4'),
    Product(
        name: "Fertilizer",
        description: "Description here",
        price: 300,
        category: 'Agriculture',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/fertilizer.jpeg?alt=media&token=dda51b5a-af03-4bf7-9bbb-d76a2d4b2c52'),
    Product(
        name: "Bus Ticket",
        description: "Description here",
        price: 100,
        category: 'Travel',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/bus.jpg?alt=media&token=7dfd8c5a-013c-43ad-8fba-2b2a6ccd7eac'),
    Product(
        name: "Medicine",
        description: "Description here",
        price: 50,
        category: 'Healthcare',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/medical.jpeg?alt=media&token=3d74e5c8-0d12-4d2b-a269-7634ca8c3c5e'),
    Product(
        name: "Train Ticket",
        description: "Description here",
        price: 50,
        category: 'Travel',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/train.jpeg?alt=media&token=6ab5bc35-de94-4151-892a-d7b458dd61be'),
    Product(
        name: "Pesticides",
        description: "Description here",
        price: 50,
        category: 'Agriculture',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/pest.webp?alt=media&token=76a75411-564e-4278-8278-a6ac10c55f98'),
    Product(
        name: "Seeds",
        description: "Description here",
        price: 50,
        category: 'Agriculture',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/seeds.jpeg?alt=media&token=5466c706-8dfc-405c-8096-de562bba55d2'),
    Product(
        name: "Health Services",
        description: "Description here",
        price: 50,
        category: 'Healthcare',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/medical%20service.webp?alt=media&token=d1c10305-73e0-414b-81c2-f59c1837559b'),
    Product(
        name: "Ration Supplies",
        description: "Description here",
        price: 50,
        category: 'Food and Nutrition',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/ration.jpeg?alt=media&token=c50a4cdc-453d-443d-b24e-9574b1492496'),
    Product(
        name: "Subsidized Foods",
        description: "Description here",
        price: 50,
        category: 'Food and Nutrition',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/Subsidized_food_items.jpeg?alt=media&token=39357739-f669-49a4-8560-62919da2d399'),
    Product(
        name: "Insurance",
        description: "Description here",
        price: 50,
        category: 'Finance',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/insurance.jpeg?alt=media&token=4b5b58a2-4379-40d8-bfd9-717aaf839dc5'),
    Product(
        name: "Electricity Bills",
        description: "Description here",
        price: 50,
        category: 'Utilities',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/electric.jpg?alt=media&token=b8c70826-20c2-45cd-a73b-4d7ed9045e6d'),
    Product(
        name: "Water Bills",
        description: "Description here",
        price: 50,
        category: 'Utilities',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/htmlapp-fa3bc.appspot.com/o/water.jpg?alt=media&token=25d61b16-eeab-45f7-b0fb-d2e941c99fe2'),
    // Add more products here
  ];

  Map<Product, int> selectedProducts = {};

  List<Product> get filteredProducts {
    if (selectedCategory == 'All') {
      return products;
    }
    return products
        .where((product) => product.category == selectedCategory)
        .toList();
  }

  void addProduct(Product product) {
    setState(() {
      if (selectedProducts.containsKey(product)) {
        selectedProducts[product] = selectedProducts[product]! + 1;
      } else {
        selectedProducts[product] = 1;
      }
    });
  }

  void removeProduct(Product product) {
    setState(() {
      if (selectedProducts.containsKey(product) &&
          selectedProducts[product]! > 0) {
        selectedProducts[product] = selectedProducts[product]! - 1;
        if (selectedProducts[product] == 0) {
          selectedProducts.remove(product);
        }
      }
    });
  }

  void confirmSelection() async {
    final totalCreditsProvider =
        Provider.of<TotalCredits>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int totalCredits = int.parse(totalCreditsProvider.totalCredits!);
    final address = userProvider.address!;
    final userName = userProvider.authPerson!;
    final contact = userProvider.conNum!;
    final email = userProvider.email!;

    int totalCost = 0;
    selectedProducts.forEach((product, quantity) {
      totalCost += product.price * quantity;
    });

    if (totalCost > totalCredits) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Insufficient credits to complete the purchase')),
      );
      return;
    }

    // Subtract the total cost from the total credits
    final newTotalCredits = totalCredits - totalCost;
    totalCreditsProvider.getTotalCredits(
        totalCredits: newTotalCredits.toString());

    // Create the JSON body
    final Map<String, dynamic> requestBody = {
      "name": userName,
      "contactNumber": contact,
      "email": email,
      "address": address,
      "products": selectedProducts.entries.map((entry) {
        final product = entry.key;
        final quantity = entry.value;
        return {
          "description": product.name,
          "quantity": quantity,
          "costPerUnit": product.price,
        };
      }).toList(),
    };

    print(requestBody);

    // Send the request to the server
    showConfirmationDialog(requestBody);
  }

  Future<void> showConfirmationDialog(req) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to purchase the selected products?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                sendPurchaseRequestAndDownloadFile(req);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendPurchaseRequestAndDownloadFile(
      Map<String, dynamic> requestBody) async {
    const url = 'http://192.168.192.231:5001/generate_bill';

    try {
      // Make the POST request to generate the bill
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        setState(() {
          selectedProducts.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase confirmed')),
        );

        final responseData = jsonDecode(response.body);

        // Check if the response has a valid URL
        if (responseData['status'] == 'ok') {
          final fileUrl = responseData['data']['url'];
          await downloadFile(fileUrl, responseData['data']['fileName']);
          // Display a success message
          print('Bill downloaded successfully');
        } else {
          print('Error generating bill: ${responseData['data']}');
        }
      } else {
        print('Failed to generate bill. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase failed')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      // Check and request storage permission
      if (await Permission.storage.request().isGranted) {
        // Get the app's document directory path
        final directory = await getApplicationDocumentsDirectory();

        // Use Dio to download the file
        final dio = Dio();
        final filePath = '${directory.path}/$fileName';

        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print(
                  'Downloading: ${((received / total) * 100).toStringAsFixed(0)}%');
            }
          },
        );

        // Display a success message or further process the file
        print('File downloaded to: $filePath');
      } else {
        print('Storage permission denied');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final totalCreditsProvider = Provider.of<TotalCredits>(context);
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'GREEN MARKET',
          style: GoogleFonts.openSans(
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.green.shade400,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              "Welcome ${userProvider.authPerson.toString()}!!",
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Your Credit Balance",
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 14,
                color: Colors.green.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalCreditsProvider.totalCredits.toString(),
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Image(
                      height: 40,
                      width: 40,
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
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Item',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(height: 200.0, autoPlay: true),
              items: imgList
                  .map((item) => Container(
                        child: Center(
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: 2000,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 50.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((category) {
                  return _buildCategoryItem(category);
                }).toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Products',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductWidget(
                    product: filteredProducts[index],
                    onAdd: () => addProduct(filteredProducts[index]),
                    onRemove: () => removeProduct(filteredProducts[index]),
                    quantity: selectedProducts[filteredProducts[index]] ?? 0,
                  );
                },
              ),
            ),
            if (selectedProducts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    minimumSize:
                        const Size(150, 50), // Box shape with full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "CONFIRM SELECTION",
                    style: GoogleFonts.openSans(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String category) {
    final isSelected = category == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.green.shade100,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 16.0,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
