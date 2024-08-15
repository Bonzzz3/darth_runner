import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/widgets/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  String _errorMessage = '';

  bool _validateAge(String age) {
    // Reset error message
    _errorMessage = '';
    final tempAge = int.tryParse(age);

    if (tempAge == null) {
      _errorMessage += 'Please enter a valid age.\n';
    } else if (tempAge > 150) {
      _errorMessage += "Hmm, I've never seen anyone live to that age..\n";
    } else if (tempAge < 3) {
      _errorMessage += "Young warrior, you are not old enough yet..\n";
    }

    return _errorMessage.isEmpty;
  }

  bool _validateHeight(String height) {
    // RESET ERROR MESSAGE
    _errorMessage = '';
    final tempHeight = int.tryParse(height);

    if (tempHeight == null) {
      _errorMessage += 'Please enter a valid height.\n';
    } else if (tempHeight > 260) {
      _errorMessage += "Please enter a valid height.\n";
    } else if (tempHeight < 50) {
      _errorMessage += "Please enter a valid height.\n";
    }

    return _errorMessage.isEmpty;
  }

  bool _validateWeight(String weight) {
    // RESET ERROR MESSAGE
    _errorMessage = '';
    final tempWeight = int.tryParse(weight);

    if (tempWeight == null) {
      _errorMessage += 'Please enter a valid weight.\n';
    } else if (tempWeight > 700) {
      _errorMessage += "Please enter a valid weight.\n";
    } else if (tempWeight < 10) {
      _errorMessage += "Please enter a valid weight.\n";
    }

    return _errorMessage.isEmpty;
  }

  Future<void> editGender(String initGender) async {
    final List<DropdownMenuEntry<String>> genderlist = [
      const DropdownMenuEntry(value: "Male", label: "Male"),
      const DropdownMenuEntry(value: "Female", label: "Female"),
      const DropdownMenuEntry(
          value: "Prefer not to say", label: "Prefer not to say"),
    ];
    String newGender = "";
    bool isValid = true;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                "Edit Gender",
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownMenu<String>(
                    initialSelection: initGender,
                    textStyle: const TextStyle(color: Colors.white),
                    trailingIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    )),
                    dropdownMenuEntries: genderlist,
                    onSelected: (gender) {
                      if (gender != null) {
                        setState(() {
                          newGender = gender;
                        });
                      }
                    },
                  ),
                  // if (!isValid)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Text(
                  //       _errorMessage,
                  //       style: const TextStyle(color: Colors.red),
                  //     ),
                  // ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    isValid = true;
                    Navigator.of(context).pop(newGender);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    // UPDATE IN FIRESTORE IF VALID
    if (newGender.trim().isNotEmpty && isValid) {
      await usersCollection
          .doc(currentUser.email)
          .update({'Gender': newGender});
    }
  }

  Future<void> editNumField(String field) async {
    String newValue = "";
    bool isValid = true;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                "Edit $field",
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter new $field",
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      newValue = value;
                    },
                  ),
                  if (!isValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // VAIDATE INPUT BASED ON FIELD TYPE
                    if (field == 'Age') {
                      isValid = _validateAge(newValue);
                    } else if (field == 'Height') {
                      isValid = _validateHeight(newValue);
                    } else if (field == 'Weight') {
                      isValid = _validateWeight(newValue);
                    }

                    if (isValid) {
                      Navigator.of(context).pop(newValue);
                    } else {
                      // UPDATE DIALOG STATE TO SHOW ERROR TYPE
                      setState(() {});
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    // UPDATE FIRESTORE IF VALID
    if (newValue.trim().isNotEmpty && isValid) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: const Text(
          'Your Personal Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
        titleSpacing: 25,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient red blue wp.png"),
              fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: usersCollection.doc(currentUser.email).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // GENDER
                          MyTextBox(
                            text: userData['Gender'],
                            sectionName: 'Gender',
                            onPressed: () => editGender(userData['Gender']),
                          ),

                          // AGE
                          MyTextBox(
                            text: userData['Age'],
                            sectionName: 'Age',
                            onPressed: () => editNumField('Age'),
                          ),

                          // HEIGHT
                          MyTextBox(
                            text: userData['Height'],
                            sectionName: 'Height (cm)',
                            onPressed: () => editNumField('Height'),
                          ),

                          // WEIGHT
                          MyTextBox(
                            text: userData['Weight'],
                            sectionName: 'Weight (kg)',
                            onPressed: () => editNumField('Weight'),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error${snapshot.error}'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
