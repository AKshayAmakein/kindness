import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kindness/constants/colors.dart';
import 'package:kindness/widgets/custom_widgets.dart';

class FriendsTile extends StatefulWidget {
  const FriendsTile({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _FriendsTileState createState() => _FriendsTileState();
}

class _FriendsTileState extends State<FriendsTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text("fetch error");
          } else if (!snapshot.hasData) {
            return Center(child: Spinner());
          } else {
            List ds = snapshot.data!.get("friends");
            print('List of Friends $ds');
            return ListView.builder(
                itemCount: ds.length,
                itemBuilder: (context, index) {
                  // sharedPreferences.setString("userId",ds['uid']);
                  return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: kDark,
                                  blurRadius: 12,
                                  spreadRadius: -4,
                                  offset: Offset(0.0, 12)),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            '${getName(ds[index])}',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          // leading: CircleAvatar(
                          //   radius: Get.width / 10,
                          //   backgroundColor: kSecondary,
                          //   child: Text(ds["name"]
                          //       .toString()
                          //       .substring(0, 1)
                          //       .toUpperCase()),
                          // ),
                          // trailing: Text(ds['coins'])),
                        ),
                      ));
                });
          }
        });
  }

  getName(String uid) async {
    String? name;
    var Map = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        name = value.get("name");
        print(name);
        //return name;
      });
    });
    return name;
  }
}
