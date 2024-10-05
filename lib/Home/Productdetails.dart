import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ProductUpload.dart';

class Productdetails extends StatefulWidget {
  const Productdetails({super.key});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final firestore =  FirebaseFirestore.instance.collection("Users").doc(auth.currentUser!.uid.toString())
        .collection("product details").snapshots();
    final delete =  FirebaseFirestore.instance.collection("Users").doc(auth.currentUser!.uid.toString())
        .collection("product details");
    return Scaffold(appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: (){  Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ProductUpload())); },child: Icon(Icons.add),),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "ERROR",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            if (snapshot.hasData) {
              return SizedBox(width: 500,height: 800,
                child: ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext, position) {
                      return ListTile(
                        title: Text(snapshot.data!.docs![position]['productname'].toString()),
                        subtitle: Text("\₹ ${snapshot.data!.docs[position]['price'].toString()}"),
                        leading: Container(width: 50, height: 50, child: Icon(
                            Icons.shopping_bag_outlined),),
                        trailing: GestureDetector(
                            onTap: (){

                              delete
                                  .doc(snapshot.data!
                                  .docs[position]["id"]
                                  .toString())
                                  .delete();
                            },
                            child: Icon(Icons.delete)),
                      );
                    },
                    separatorBuilder: (BuildContext, position) {
                      return SizedBox();
                    },
                    ),
              );
            }
         else{ return SizedBox();} } ),
      ),
    );
  }
}
