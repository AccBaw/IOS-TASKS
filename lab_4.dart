import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
      );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  bool isLiked = false;
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.person,
                size: 70,
              ),
            ),

            const SizedBox(height: 20),
            
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Narxoz Student | Class 0f 2027 | Almaty',
              style: TextStyle(
                fontSize:16,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isFollowing = !isFollowing;
                });
              },
              child: Text(
                isFollowing ? 'Following' : 'Follow',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (isLiked) {
                    likeCount--;
                    isLiked = false;
                  } else {
                    likeCount++;
                    isLiked = true;
                  }
                });
              },

              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
              ),

              label: Text(
                'Likes: $likeCount',
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                setState(() {
                  isFollowing = false;
                  isLiked = false;
                  likeCount = 0;
                });
              },

              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );  
  }
}
