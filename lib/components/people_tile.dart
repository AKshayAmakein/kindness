import 'package:flutter/material.dart';

class PeopleTitle extends StatefulWidget {
  @override
  _PeopleTitleState createState() => _PeopleTitleState();
}

class _PeopleTitleState extends State<PeopleTitle> {
  var friends;

  follow() {
    setState(() {
      friends = "Friends";
    });
  }

  unfollow() {
    setState(() {
      friends = "Not Friends";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0xff919eab),
            blurRadius: 12,
            spreadRadius: -4,
            offset: Offset(0.0, 12)),
      ]),
      child: Column(
        children: [
          ListTile(
            title: Text('name'),
            leading: CircleAvatar(
              child: Text('a'),
            ),
            trailing: friends == "Friends"
                ? ElevatedButton(
                    onPressed: unfollow,
                    style: ElevatedButton.styleFrom(primary: Colors.black38),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new Text(
                          "FOLLOWING",
                        )
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: follow,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new Text(
                          "FOLLOW",
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
