import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/Services/authentication.dart';
import 'package:untitled/login.dart';

class FirestoreDatabase extends StatefulWidget {
  const FirestoreDatabase({super.key});

  @override
  State<StatefulWidget> createState() => _RealtimecrudState();
}

class _RealtimecrudState extends State<FirestoreDatabase> {
  static var nameController = TextEditingController();
  static var positionController = TextEditingController();
  static var searchController = TextEditingController();

  final CollectionReference myItems =
      FirebaseFirestore.instance.collection("crud");
  var name;
  var email;
  var image;
  var phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

//  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchEmailPassUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;

      // Get reference to user document using user UID
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      // Extract data from document
      setState(() {
        name = userDoc.get('name');
        email = userDoc.get('email');
        image = userDoc.get('image');
        phone = userDoc.get('phone');
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.providerData.first.providerId == "google.com") {
        return await fetchGoogleUserData();
      } else {
        return await fetchEmailPassUserData();
      }
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> fetchGoogleUserData() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
     GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    setState(() {
      name = googleUser!.displayName!;
      email = googleUser.email;
      image = googleUser.photoUrl!;
      phone = "";
    });
  }

  Future<void> create() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return myDialog(
              context: context,
              name: "Create Operation",
              condition: "Create",
              onPressed: () {
                String name = nameController.text;
                String position = positionController.text;
                addItems(name, position);
                Navigator.pop(context);
                nameController.text = '';
                positionController.text = '';
              });
        });
  }

  void addItems(String name, String position) {
    myItems.add({'name': name, 'position': position});
  }

//for update the fields
  Future<void> update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['name'];
    positionController.text = documentSnapshot['position'];
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return myDialog(
              context: context,
              name: "Update Your Data",
              condition: "Update",
              onPressed: () async {
                String name = nameController.text;
                String position = positionController.text;
                await myItems
                    .doc(documentSnapshot.id)
                    .update({'name': name, 'position': position});
                nameController.text = '';
                positionController.text = '';
                Navigator.pop(context);
              });
        });
  }

  //for delete items
  Future<void> delete(String productId) async {
    await myItems.doc(productId).delete();
    //after delete show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.red.shade600,
          duration: Duration(milliseconds: 500),
          content: Text("Deleted Succesfully.")),
    );
  }

  String searchtext = '';

  void onSearchChange(String value) {
    setState(() {
      searchtext = value;
    });
  }

  bool isSearchClick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: 100,
                          width: 100,
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(image))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Name :$name",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Email  : $email",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Phone  : $phone",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage:image!=null ?  NetworkImage(image) : null,
            ),
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        title: isSearchClick
            ? Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: onSearchChange,
                  controller: searchController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 20, 16, 12),
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none),
                ),
              )
            : const Text(
                "Firestore Database Crud",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25),
              ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchClick = !isSearchClick;
                });
              },
              icon: Icon(
                isSearchClick ? Icons.close : Icons.search,
                color: Colors.white,
                size: 30,
              )),
          IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                await AuthServices().signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 30,
              )),
        ],
      ),
      //for displaying Items
      body: StreamBuilder(
          stream: myItems.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final List<DocumentSnapshot> items = streamSnapshot.data!.docs
                  .where((doc) => doc['name']
                      .toLowerCase()
                      .contains(searchtext.toLowerCase()))
                  .toList();
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = items[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                documentSnapshot['name'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                documentSnapshot['position'],
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () =>
                                            update(documentSnapshot),
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          color: Colors.blue,
                                        )),
                                    IconButton(
                                        onPressed: () =>
                                            delete(documentSnapshot.id),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: create,
        child: Icon(
          Icons.add,
          color: Colors.blue.shade100,
          size: 40,
        ),
      ),
    );
  }
}

Dialog myDialog({
  required BuildContext context,
  required name,
  required condition,
  required VoidCallback onPressed,
}) =>
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close_sharp))
              ],
            ),
            TextField(
              controller: _RealtimecrudState.nameController,
              decoration: InputDecoration(
                  labelText: "Enter Name", hintText: "Your Name"),
            ),
            TextField(
              controller: _RealtimecrudState.positionController,
              decoration: InputDecoration(
                  labelText: "Enter Position", hintText: "Your Position"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: onPressed, child: Text(condition)),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
