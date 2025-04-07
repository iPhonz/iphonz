import 'package:flutter/material.dart';
import '../models/group.dart';

class GroupItem extends StatelessWidget {
  final Group group;
  final VoidCallback onToggleJoin;
  final VoidCallback onTap;

  const GroupItem({
    Key? key,
    required this.group,
    required this.onToggleJoin,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Group image
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(group.groupImage),
            ),
            const SizedBox(width: 16),
            
            // Group info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${group.memberCount} Members',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Right side with new spills count and join button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (group.newSpillsCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${group.newSpillsCount} New Spills',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onToggleJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: group.isJoined
                        ? Colors.grey[200]
                        : const Color(0xFF7941FF),
                    foregroundColor: group.isJoined
                        ? Colors.black
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    group.isJoined ? 'Joined' : 'Join',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: group.isJoined
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
