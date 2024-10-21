import 'package:example/screens/CreativeUI/creative_selectCategoryUpload.dart';
import 'package:flutter/material.dart';

class UploadPackage extends StatefulWidget {
  const UploadPackage({super.key});

  @override
  _UploadPackageState createState() => _UploadPackageState();
}

class _UploadPackageState extends State<UploadPackage> {
  String? selectedCategory;
  String? priceInput;
  List<String> addOns = [""];
  List<String> addOnPrices = [""];

  // Functions to add and remove add-ons
  void addNewAddOn() {
    setState(() {
      addOns.add("");
      addOnPrices.add("");
    });
  }

  void removeLastAddOn() {
    if (addOns.length > 1) {
      setState(() {
        addOns.removeLast();
        addOnPrices.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Upload Package',
            style: TextStyle(
                color: Color(0xFF662C2B), fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Description Input
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              width: double.infinity, // Full width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      hintText: 'TYPE TITLE',
                      hintStyle: TextStyle(
                        color: Color(0xFF662C2B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      hintText: 'Type description here',
                      hintStyle: TextStyle(
                        color: Color(0xFF662C2B),
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Select Category and Price Input
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SelectCategory(
                          onCategorySelected: (String category) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCategory ?? 'Select Category',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Price Input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle price input
                        },
                        child: const Text(
                          'Input Here..',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF662C2B),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Upload Packages Area
            const Text(
              'Upload Packages Here:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                // Handle package upload
              },
              child: Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 50.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Add-ons section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add ons:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: addNewAddOn,
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed: removeLastAddOn,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),

            // Add-ons list
            ListView.builder(
              shrinkWrap: true,
              itemCount: addOns.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Checkbox(
                      value: false, // You can implement add-on logic here
                      onChanged: (bool? value) {},
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Input Here..',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            addOns[index] = value;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Input Price..',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          addOnPrices[index] = value;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20.0),

            // Post Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle post action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF662C2B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 150.0,
                    vertical: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'POST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
