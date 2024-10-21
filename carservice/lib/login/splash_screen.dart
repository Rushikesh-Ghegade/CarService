import 'dart:developer';

import 'package:carservice/packages/packages.dart';
import 'package:carservice/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final user = FirebaseOP.firebaseAuth.currentUser;
    // user!.delete();
    log("${user}");
    if (user != null) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        ));
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.white,
        decoration: const BoxDecoration(
            image: DecorationImage(
                // opacity: 0.9,
                fit: BoxFit.cover,
                image: AssetImage("lib/images/c4.jpg"))),
        // child: Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Column(
        //     // mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const Spacer(
        //         flex: 2,
        //       ),
        //       Text(
        //         "Welcome To",
        //         style: GoogleFonts.poppins(
        //           color: const Color.fromARGB(255, 101, 100,
        //               100), //const Color.fromARGB(255, 210, 207, 207),
        //           fontSize: 23,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 5,
        //       ),
        //       Text(
        //         "Car Services",
        //         style: GoogleFonts.poppins(
        //           color: const Color.fromARGB(255, 51, 51, 51), //Colors.white,
        //           fontSize: 43,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 5,
        //       ),
        //       Text(
        //         "Your New Equipment Experiance With Car Srvices",
        //         style: GoogleFonts.poppins(
        //           color: const Color.fromARGB(255, 101, 100,
        //               100), //const Color.fromARGB(255, 210, 207, 207),
        //           fontSize: 23,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //       const Spacer(
        //         flex: 9,
        //       ),
        //       GestureDetector(
        //         onTap: () {},
        //         child: Container(
        //           height: 50,
        //           width: MediaQuery.of(context).size.width,
        //           decoration: BoxDecoration(
        //             color: const Color.fromARGB(255, 44, 34, 219),
        //             borderRadius: BorderRadius.circular(15),
        //           ),
        //           alignment: Alignment.center,
        //           child: Text(
        //             "Create An Account",
        //             style: GoogleFonts.poppins(
        //               color: Colors.white,
        //               fontSize: 21,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 15,
        //       ),
        //       GestureDetector(
        //         onTap: () {
        //           Navigator.pushReplacement(context, MaterialPageRoute(
        //             builder: (context) {
        //               return const LoginScreen();
        //             },
        //           ));
        //         },
        //         child: Container(
        //           height: 50,
        //           width: MediaQuery.of(context).size.width,
        //           decoration: BoxDecoration(
        //             color: const Color.fromARGB(255, 44, 34, 219),
        //             borderRadius: BorderRadius.circular(15),
        //           ),
        //           alignment: Alignment.center,
        //           child: Text(
        //             "Login",
        //             style: GoogleFonts.poppins(
        //               color: Colors.white,
        //               fontSize: 21,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //         ),
        //       ),
        //       const Spacer(),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
