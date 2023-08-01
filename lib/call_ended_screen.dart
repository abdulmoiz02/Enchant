
import 'package:elevenlabai/calling_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CallEndedScreen extends StatefulWidget {
  const CallEndedScreen({Key? key,required this.api}) : super(key: key);
  final String api;

  @override
  State<CallEndedScreen> createState() => _CallEndedScreenState();
}

class _CallEndedScreenState extends State<CallEndedScreen> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
              "assets/background.json",
              fit: BoxFit.cover,
              height: screenHeight,
              width: double.infinity
          ),
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Spacer(),
                        CircleAvatar(
                          radius: 75,
                          backgroundImage: AssetImage('assets/samaanpklogo.jpg'),
                        ),
                        Text("SAAMAAN PK",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 30),),
                        Text("+92123145661",style: TextStyle(color: Colors.white) ),
                        Text("Call Ended",style: TextStyle(color: Colors.white) ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.offAll(() => CallingScreen(api: widget.api,) );
                          },
                          child: Container(
                            width: 70, // Set the width of the circle container
                            height: 70, // Set the height of the circle container
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle, // This makes the container circular
                              color: Colors.green, // Set the background color of the container
                            ),
                            child: const Center(
                                child: Icon(Icons.autorenew,color: Colors.white,)
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
