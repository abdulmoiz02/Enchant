import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioController extends GetxController{
  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? playerStateSub;
  RxBool playingAudio = false.obs;

  @override
  void onInit() {
    playerStateSub = audioPlayer.onPlayerStateChanged.listen((playerState) {
      if(playerState == PlayerState.completed){
        print("completed Audio Stream");
        playingAudio.value = false;
      }
    });
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> setAudio(String filename)async{
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load(filename);
    await audioPlayer.setSourceUrl(url.path);
  }
  Future<void> playGreetingAudio() async {
    playingAudio.value = true;
    await setAudio('intro.mp3');
    await audioPlayer.resume();
  }

  Future<void> playRingtoneAudio() async {
    playingAudio.value = true;
    await setAudio('iphone_rigntone.mp3');
    await audioPlayer.resume();
  }

  Future<void> setByteSourceAudio(Uint8List bytes) async {
    playingAudio.value = true;
    await audioPlayer.setSourceBytes(bytes);
    await audioPlayer.resume();
  }

  void pauseAudio() {
    audioPlayer.pause();
  }

  Future<void> stopAudio() async{
    await audioPlayer.stop();
  }

  void setupAudioPlayer() {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      print("Player state: $state");
    });
  }

  void releaseAudioPlayer() {
    audioPlayer.release();
  }

  @override
  void dispose() {
    stopAudio();
    playerStateSub!.cancel();
    releaseAudioPlayer();
    // TODO: implement dispose
    super.dispose();
  }

}