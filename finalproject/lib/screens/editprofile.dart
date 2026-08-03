import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final imageController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.ref("users");

  File? _image;
  final picker = ImagePicker();

  bool loading = false;

  User? user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;

    loadUserData();
  }

  Future<void> loadUserData() async {
    emailController.text = user?.email ?? "";

    final snapshot = await dbRef.child(user!.uid).get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        nameController.text = data["name"] ?? "";
        phoneController.text = data["phone"] ?? "";
        emailController.text = data["email"] ?? user?.email ?? "";
        imageController.text = data["image"] ?? "";

        if (imageController.text.isNotEmpty) {
          _image = File(imageController.text);
        }

      });
    }
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        imageController.text = picked.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Image Updated")),
      );
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {

      if (emailController.text.trim() != user!.email) {
        await user!.verifyBeforeUpdateEmail(
          emailController.text.trim(),
        );
      }


      await dbRef.child(user!.uid).update({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "image": imageController.text.trim(),
      });

      await user!.reload();
      user = auth.currentUser;

      setState(() => loading = false);

      Navigator.pop(context, true);

    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D022D),
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontFamily: "PoppinsMedium",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 20),

                Stack(
                  children: [

                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage:
                      _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      )
                          : null,
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                buildField(
                  controller: nameController,
                  hint: "Name",
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                buildField(
                  controller: emailController,
                  hint: "Email",
                  icon: Icons.email,
                ),

                const SizedBox(height: 20),

                buildField(
                  controller: phoneController,
                  hint: "Phone Number",
                  icon: Icons.phone,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "PoppinsMedium",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value!.isEmpty) return "Required field";
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}