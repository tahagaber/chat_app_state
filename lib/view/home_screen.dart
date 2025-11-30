import 'package:chat_app_state/view/chat_screen.dart';
import 'package:chat_app_state/view/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // GitHub Dark Theme Colors
  static const Color gitHubBackground = Color(0xFF0E0F1F);
  static const Color gitHubAppBar = Color(0xFF0E0F1F);
  static const Color fabColor = Color(0xFF25D366);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Widget> get _screens => [
        _ChatsPage(searchQuery: _searchController.text),
        const _UpdatesPage(),
        const _CommunitiesPage(),
        const _CallsPage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  IconData _getFabIcon() {
    switch (_currentIndex) {
      case 0:
        return Icons.chat;
      case 1:
        return Icons.camera_alt;
      case 2:
        return Icons.group_add;
      case 3:
        return Icons.add_call;
      default:
        return Icons.chat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gitHubBackground,
      appBar: AppBar(
        backgroundColor: gitHubAppBar,
        title: const Text(
          'WhatsApp',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    child: const Text('Logout'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: fabColor,
        onPressed: () {},
        child: Icon(_getFabIcon(), color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: gitHubAppBar,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: fabColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Updates'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Communities'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
      ),
    );
  }
}

class _ChatsPage extends StatelessWidget {
  final String searchQuery;
  const _ChatsPage({this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').orderBy('displayName').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading users', style: TextStyle(color: Colors.white)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found', style: TextStyle(color: Colors.white)));
        }

        final allUsers = snapshot.data!.docs;
        final filteredUsers = allUsers.where((doc) {
          final userData = doc.data() as Map<String, dynamic>;
          final name = (userData['displayName'] as String? ?? '').toLowerCase();
          final query = searchQuery.toLowerCase();
          return name.contains(query);
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final userData = filteredUsers[index].data() as Map<String, dynamic>;
            final uid = userData['uid'] as String? ?? filteredUsers[index].id;

            if (uid == currentUser?.uid) return const SizedBox.shrink();

            final displayName = userData['displayName'] as String? ?? '';
            final photoURL = userData['photoURL'] as String? ?? '';
            final nameToShow = displayName.isNotEmpty ? displayName : (userData['email'] as String? ?? '');

            return _ChatTile(
              name: nameToShow,
              message: 'Tap to start chatting...',
              time: '',
              imageUrl: photoURL,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userId: uid,
                      userName: nameToShow,
                      photoURL: photoURL,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String imageUrl;
  final VoidCallback onTap;

  const _ChatTile({
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
    required this.onTap,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.isNotEmpty;

    return ListTile(
      onTap: onTap,
      leading: hasImage
          ? CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl))
          : CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[800],
              child: Text(
                _getInitials(name),
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
      title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 18)),
      subtitle: Text(message, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }
}

class _UpdatesPage extends StatelessWidget {
  const _UpdatesPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Status Updates', style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}

class _CommunitiesPage extends StatelessWidget {
  const _CommunitiesPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Communities', style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}

class _CallsPage extends StatelessWidget {
  const _CallsPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Call History', style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}
