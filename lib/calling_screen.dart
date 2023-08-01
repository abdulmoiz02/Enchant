import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:elevenlabai/controllers/recording_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:http/http.dart' as http;
import 'package:record/record.dart';

import 'call_ended_screen.dart';
import 'controllers/audio_controller.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({Key? key,required this.api}) : super(key: key);
  final String api;
  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  final AudioController audioController = Get.put(AudioController());
  final RecordingController recordingController = Get.put(RecordingController());
  RxBool transcribeAudioLoading = false.obs;
  Timer? recordTimer;

  int seconds = 0; // Timer value in seconds
  bool isActive = false; // To control the timer's state
  Timer? timer; // The Timer object

  String formatTime(int seconds) {
    // Convert total seconds to mm:ss format
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void startTimer() {
    if (isActive)
      return; // If the timer is already running, don't start another one
    isActive = true; // Set the timer as active

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Run the function every second
      setState(() {
        seconds++; // Increment the timer value
      });
    });
  }

  void stopTimer() {
    isActive = false; // Set the timer as inactive
    if (timer != null) timer!.cancel(); // Cancel the timer
  }

  void resetTimer() {
    isActive = false; // Set the timer as inactive
    if (timer != null) timer!.cancel(); // Cancel the timer
    setState(() {
      seconds = 0; // Reset the timer value to 00:00
    });
  }

  Future<void> transcribeAudio(String api,AudioController audioController, String audioFilePath) async {
    transcribeAudioLoading.value = true;
    // Replace the URL with the actual URL of your API endpoint
    String apiUrl = "$api/transcribe";

    // Replace these values with the actual user_id and company_id
    String userId = "admin";
    String companyId = "saamaanpk";

    // Read the audio file as bytes
    File audioFile = File(audioFilePath);
    List<int> audioBytes = await audioFile.readAsBytes();

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add the user_id and company_id as form fields
    request.fields['user_id'] = userId;
    request.fields['company_id'] = companyId;

    // Add the audio file to the request
    request.files.add(
      http.MultipartFile.fromBytes('customer', audioBytes,
          filename: 'test2.mp3'),
    );

    // Send the request
    var response = await request.send();

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Get the response audio file as bytes
      List<int> bytes = await response.stream.toBytes();

      // Now you have the transcribed audio file as bytes
      // Do whatever you want with the response audio bytes

      // Example: If you want to set the response audio as the source for the AudioController
      Uint8List uint8List = Uint8List.fromList(bytes);
      transcribeAudioLoading.value = false;
      await audioController.setByteSourceAudio(uint8List);
    } else {
      transcribeAudioLoading.value = false;
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> callTranscribe () async{
    final String? path =
    await recordingController.stop();
    if (path != null) {
      await transcribeAudio(widget.api,audioController, path);
    } else {
      print("Path is null");
    }
  }

  @override
  void dispose() {
    stopTimer();
    // TODO: implement dispose
    super.dispose();
  }

  void playGreetingAudio() async {
    await audioController.playGreetingAudio();
  }

  @override
  void initState() {
    isActive ? stopTimer() : startTimer();
    playGreetingAudio();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset("assets/background.json",
              fit: BoxFit.cover, height: screenHeight, width: double.infinity),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const Spacer(),
                      const CircleAvatar(
                        radius: 75,
                        backgroundImage:
                            AssetImage('assets/samaanpklogo.jpg'),
                      ),
                      const Text(
                        "SAAMAAN PK",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Text(formatTime(seconds),
                          style: const TextStyle(color: Colors.white)),
                      const Text("+92123145661",
                          style: TextStyle(color: Colors.white)),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Obx(() {

                        if(recordingController.amplitude.value != null && recordingController.recordState.value == RecordState.record){
                          print("${recordingController.amplitude.value!.current.abs()}");
                          if ((recordingController.amplitude.value!.current.abs()) > 8) {

                            recordTimer = Timer(const Duration(seconds: 4), () {
                              if (recordingController.recordState.value == RecordState.record){
                                print('Executing the command...');
                                callTranscribe();
                              }

                              recordTimer?.cancel();
                            });
                          } else {
                            recordTimer?.cancel();
                          }

                        }

                        return Container();

                      }),
                      Obx(() {
                        if(!audioController.playingAudio.value && recordingController.recordState.value == RecordState.stop && transcribeAudioLoading.value == false){
                          print("recording");
                          recordingController.start();
                        }
                        if(audioController.playingAudio.value){
                          return Lottie.asset('assets/audio_animation.json',height: 100);
                        }else{
                          if(recordingController.recordState.value == RecordState.record ){
                            return Lottie.asset('assets/animation_lkoczw3r.json',height: 100);
                          }else{
                            return Container();
                          }
                        }
                      }),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await audioController.stopAudio();
                          Get.offAll(() =>  CallEndedScreen(api: widget.api,));
                        },
                        child: Container(
                          width: 70, // Set the width of the circle container
                          height:
                              70, // Set the height of the circle container
                          decoration: const BoxDecoration(
                            shape: BoxShape
                                .circle, // This makes the container circular
                            color: Colors
                                .red, // Set the background color of the container
                          ),
                          child: const Center(
                              child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                          )),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
