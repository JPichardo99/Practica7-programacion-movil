import 'package:flutter/material.dart';

class ActorCard extends StatelessWidget {
  final String name;
  String photoUrl;
  ActorCard({
    super.key,
    required this.name,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              photoUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
