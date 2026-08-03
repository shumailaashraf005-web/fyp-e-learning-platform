import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dashboard.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  bool loading = false;
  bool _isPasswordHidden = true;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await FirebaseDatabase.instance.ref("users/$uid").set({
        "uid": uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": passwordController.text.trim(),
        "createdAt": DateTime.now().toString(),
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Something went wrong"),
        ),
      );
    }

    setState(() => loading = false);
  }

  Future<void> signInWithGoogle()async{
    String appClientId ="1013156171210-tg2tv45smsmitpr2cmc764tnku8c35to.apps.googleusercontent.com";
    try{
      GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(serverClientId: appClientId);
      GoogleSignInAccount account = await signIn.authenticate();
      GoogleSignInAuthentication googleAuth = account.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken
      );

      setState(() {loading = true;});

      await auth.signInWithCredential(credential);

      User user = auth.currentUser!;

      await FirebaseDatabase.instance.ref("users/${user.uid}").set({
        "uid": user.uid,
        "name": user.displayName,
        "email": user.email,
        "createdAt": DateTime.now().toString(),
      });

      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
          builder: (context) => DashboardScreen()), (Value) => false);

    }on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login Failed")),
      );
    }finally {
      setState(() {loading = false;});
    }

  }


  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white38),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.person_add, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  TextFormField(
                    controller: nameController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    validator: (value) =>
                    value!.isEmpty ? "Enter name" : null,
                    decoration: inputStyle("Full Name", Icons.person),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) return "Enter email";
                      if (!value.contains("@")) return "Invalid email";
                      return null;
                    },
                    decoration: inputStyle("Email", Icons.email),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: phoneController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    validator: (value) =>
                    value!.length < 11 ? "Enter valid phone" : null,
                    decoration: inputStyle("Phone Number", Icons.phone),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.white,
                    obscureText: _isPasswordHidden,
                    style: TextStyle(color: Colors.white),
                    validator: (value) =>
                    value!.length < 6 ? "Minimum 6 characters" : null,
                    decoration: inputStyle("Password", Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: createAccount,
                      child: loading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "or",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton.icon(
                      icon: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png",
                        height: 22,
                      ),
                      style: TextButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      label: const Text(
                        "Continue with Google",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        print("Button Pressed");
                        await signInWithGoogle();
                      },
                    ),
                  ),


                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}