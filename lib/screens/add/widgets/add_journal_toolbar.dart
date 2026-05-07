import 'package:flutter/material.dart';

class AddJournalToolbar extends StatelessWidget {
  const AddJournalToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildToolIcon(Icons.camera_alt_outlined),
          _buildToolIcon(Icons.image_outlined),
          _buildToolIcon(Icons.label_outline_rounded),
          _buildToolIcon(Icons.music_note_outlined),
          _buildToolIcon(Icons.videocam_outlined),
          _buildToolIcon(Icons.more_horiz_rounded),
        ],
      ),
    );
  }

  Widget _buildToolIcon(IconData icon) {
    return Icon(icon, color: Colors.grey.shade600, size: 26);
  }
}
