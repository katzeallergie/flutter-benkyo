import 'package:flutter/material.dart';

import '../dto/profile.dart';

class ProfileTop extends StatefulWidget {
  const ProfileTop({super.key, required this.profile});

  final Profile profile;

  @override
  State<ProfileTop> createState() => _ProfileTopState();
}

class _ProfileTopState extends State<ProfileTop> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.bookmark,
                            color: Color.fromARGB(255, 219, 172, 52),
                          ),
                          Text(widget.profile.name)
                        ],
                      ),
                      subtitle: Text(widget.profile.id),
                    ),
                    Text(
                      widget.profile.profile,
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Image.network(
                  widget.profile.profileImg,
                  width: 150,
                  height: 150,
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
            ),
            child: Wrap(
              spacing: 4,
              children: widget.profile.tags
                  .map((tag) => Chip(
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        side: BorderSide.none,
                        label: Text(tag),
                        backgroundColor: Colors.green,
                        labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ))
                  .toList(),
            ),
          ),
        ]);
  }
}
