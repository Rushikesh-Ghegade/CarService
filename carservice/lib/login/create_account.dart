import 'package:carservice/packages/packages.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State createState() {
    return _SignInScreenState();
  }
}

class _SignInScreenState extends State {
  // final _firebaseAuth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final flag = false;

  void _createAccount() async {
    // if (await FirebaseOP.userExits()) {
    if (_emailController.text.isNotEmpty && _passController.text.isNotEmpty) {
      try {
        await FirebaseOP.createAccountFirebase(
                _emailController.text, _passController.text)
            .then((value) async {
          SnackBars(context, "Account Create Successfully").showSnackBars();

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ));
          // if (!await FirebaseOP.userExits()) {
          await FirebaseOP.addUserInfo();
          // } else {
          // log("User Exits");
          // }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          SnackBars(context, "Email is Already Present try with another email")
              .showSnackBars();
        } else if (e.code == 'weak-password') {
          SnackBars(context, "The Password must be at leat 6 characters long")
              .showSnackBars();
        } else if (e.code == 'invalid-email') {
          SnackBars(context, "Email Format is Invalid Enter the Valid Format")
              .showSnackBars();
        } else {
          SnackBars(context, e.code).showSnackBars();
        }
      }
    } else {
      SnackBars(context, "Enter the Email And Password To Create Account")
          .showSnackBars();
    }
    // } else {
    // SnackBars(context, "User Already Login");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ));
                },
                icon: const Icon(Icons.arrow_back)),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                "Sign In Account",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.blue,
                ),
                hintText: "Email",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.blue,
                ),
                hintText: "Password",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _confirmPassController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.blue,
                ),
                hintText: "Confirm Password",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 138, 248),
                fixedSize: Size(MediaQuery.of(context).size.width, 50),
              ),
              onPressed: () {
                _createAccount();
                setState(() {});
              },
              child: (!flag)
                  ? const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  : const CircularProgressIndicator(
                      // value: 1,
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
