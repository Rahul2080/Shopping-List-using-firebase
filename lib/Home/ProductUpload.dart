import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/Home/Productdetails.dart';

class ProductUpload extends StatefulWidget {
  const ProductUpload({super.key});

  @override
  State<ProductUpload> createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  @override
  Widget build(BuildContext context) {
    TextEditingController productnamecontroller = TextEditingController();
    TextEditingController pricecontroller = TextEditingController();
    var formkey = GlobalKey<FormState>();
    FirebaseAuth auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance.collection("Users").doc(auth.currentUser!.uid.toString())
        .collection("product details");
    return Scaffold(
      appBar: AppBar(
      ),
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: productnamecontroller,
                decoration: InputDecoration(
                    hintText: "Product name", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                controller: pricecontroller,
                decoration: InputDecoration(
                    hintText: "Product price", border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                if (formkey.currentState!.validate()) {
                  final id = DateTime.now().microsecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    "productname": productnamecontroller.text,
                    "price": pricecontroller.text,
                    "id": id,
                  }).then((onValue) {
                    productnamecontroller.clear();
                    pricecontroller.clear();
                  });
                }
              },
              child: Container(
                width: 200,
                height: 53,
                decoration: ShapeDecoration(
                  color: Color(0xFFF73658),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                    child: Text(
                  'Upload',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
