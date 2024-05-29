import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    /// Logo, title and subtitle
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          height: 150,
                          image: AssetImage("assets/img/logo.jpeg"),
                        ),
                        Text("login title"),
                        SizedBox(height: 20),
                        Text("login subtitle"),
                      ],
                    ),

                    /// form
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            /// email
                            TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.abc,
                                  color: Colors.blue,
                                ),
                                labelText: ("email"),
                              ),
                            ),

                            /// password
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.abc,
                                  color: Colors.lightBlue,
                                ),
                                labelText: ("password"),
                              ),
                            ),

                            /// remember me and forget password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: true,
                                      onChanged: (value) {},
                                    ),
                                    const Text("Remember me"),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("forget password"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("signin"))),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text("create account"))),
                          ],
                        ),
                      ),
                    ),

                    /// Divider
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          indent: 60,
                          endIndent: 5,
                        )),
                        Text("or signin with"),
                        Flexible(
                            child: Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          indent: 60,
                          endIndent: 5,
                        )),
                      ],
                    ),

                    /// Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Image(
                                width: 20,
                                height: 20,
                                image: AssetImage("assets/img/logo.jpeg"),
                              ),
                            )),
                        const SizedBox(width: 20),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Image(
                                width: 20,
                                height: 20,
                                image: AssetImage("assets/img/logo.jpeg"),
                              ),
                            )),
                      ],
                    )
                  ],
                ))));
  }
}
