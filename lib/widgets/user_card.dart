import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color githubDark = Color(0xFF0D1117);
    const Color githubCard = Color(0xFF161B22);
    const Color githubBorder = Color(0xFF30363D);
    const Color githubText = Color(0xFFC9D1D9);
    const Color githubSubtext = Color(0xFF8B949E);
    const Color githubGreen = Color(0xFF3FB950); // GitHub success green
    const Color githubBlue = Color(0xFF1F6FEB);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: githubCard,
        border: Border.all(color: githubBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: githubGreen, width: 2),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: githubGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                const Text(
                  "Mohamed",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: githubText,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.mail_outline, color: githubSubtext, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      "test@gmail.com",
                      style: const TextStyle(color: githubSubtext, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: githubGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Available to chat",
                      style: TextStyle(color: githubSubtext),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text(
                "now",
                style: TextStyle(color: githubSubtext, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: githubBlue,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
