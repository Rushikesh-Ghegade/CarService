import 'package:carservice/packages/packages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>?> fetchUserData() async {
    final firebaseAuth = FirebaseAuth.instance;
    final firestoredb = FirebaseFirestore.instance;
    final userId = firebaseAuth.currentUser!.uid;

    if (userId != null) {
      final documentSnapshot =
          await firestoredb.collection('Users').doc(userId).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data;
            if (userData != null) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        (userData['image'] != null)
                            ? GestureDetector(
                                onTap: () {
                                  FirebaseOP.firebaseAuth.signOut();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const LoginScreen();
                                    },
                                  ));
                                },
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "${userData['image']}"),
                                      ),
                                    )),
                              )
                            : Container(
                                padding: const EdgeInsets.all(1),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("lib/images/profile.png"),
                                  ),
                                ),
                              ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notification_important_sharp,
                              size: 30,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(
                        "What do you need help Today?",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Search Your Service",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return ChatPage(img: userData['image']);
                                  },
                                ));
                              },
                              child: Container(
                                height: 40,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            "lib/images/chatbot.jpg")),
                                    color: const Color.fromARGB(
                                        255, 220, 217, 217),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const Text("chatBot")
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Location",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return const MapScreen(
                              search: "Search Place",
                            );
                          },
                        ));
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Icon(Icons.zoom_in_map_outlined)),
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No user data found.'));
            }
          } else {
            return const Center(child: Text('No user data available.'));
          }
        },
      ),
    );
  }
}
