import 'package:elevenlabai/calling_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MakeCallScreen extends StatefulWidget {
  const MakeCallScreen({Key? key}) : super(key: key);

  @override
  State<MakeCallScreen> createState() => _MakeCallScreenState();
}

class _MakeCallScreenState extends State<MakeCallScreen> {
  final TextEditingController apiTextEditingController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
      backgroundColor: const Color(0xFF001638),
      appBar: AppBar(
        title: const Text("CONTACTS"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: apiTextEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'api',
                hintText: "ex: http://127.0.0.1:8000",
                filled: true,
                fillColor: Colors.white
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children:  [
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(backgroundImage: AssetImage('assets/samaanpklogo.jpg'),),
                    title: const Text("SAAMAAN PK"),
                    trailing: IconButton(
                      onPressed: (){
                        Get.offAll(() => CallingScreen(api: apiTextEditingController.text,));

                      },
                      icon: const Icon(Icons.call,color: Colors.green,),
                    ),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("StellarTech Solutions"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("Quantum Foods"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("AzureWave Robotics"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("SwiftWings Airlines"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("LunaTech Innovations"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("Emerald Health Labs"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("ThunderWorks Gaming"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("Sunlight Energy Systems"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("CrimsonX Design Studio"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: const Text("SilverLinx Financial Services"),
                    trailing: IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.call),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
