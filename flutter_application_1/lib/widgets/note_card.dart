import 'package:flutter/material.dart';

import '../constants/color_scheme.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: greyColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Title',
            style: TextStyle(
              fontSize: 16,
              color: whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            index % 2 == 0
                ? 'Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.'
                : 'Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.',
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: lightGreyColor),
          ),
          const SizedBox(height: 16),
          Text(
            'May 05, 2022',
            style: TextStyle(
              fontSize: 12,
              color: lightGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}
