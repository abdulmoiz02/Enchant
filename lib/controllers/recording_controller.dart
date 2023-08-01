import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class RecordingController extends GetxController {
  final Record record = Record();
  StreamSubscription<Amplitude>? amplitudeSub;
  Rx<Amplitude?> amplitude = Rx<Amplitude?>(null);
  StreamSubscription<RecordState>? recordSub;
  Rx<RecordState> recordState = RecordState.stop.obs;



  @override
  void onInit() {
    recordSub = record.onStateChanged().listen((state) {
      recordState.value = state;
    });

    amplitudeSub = record
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
          amplitude.value = amp;

        }
    );
    // TODO: implement onInit
    super.onInit();
  }

  // void updateRecordState(RecordState recordState) {
  //   recordState = recordState;
  //
  //   switch (recordState) {
  //     case RecordState.pause:
  //       _timer?.cancel();
  //       break;
  //     case RecordState.record:
  //       _startTimer();
  //       break;
  //     case RecordState.stop:
  //       _timer?.cancel();
  //       _recordDuration = 0;
  //       break;
  //   }
  // }

  Future<void> start() async {
    try {
      if (await record.hasPermission()) {
        const encoder = AudioEncoder.aacLc;

        // We don't do anything with this but printing
        final isSupported = await record.isEncoderSupported(
          encoder,
        );
        debugPrint('${encoder.name} supported: $isSupported');
        final devs = await record.listInputDevices();
        debugPrint(devs.toString());
        // Record to file
        String path;
        if (kIsWeb) {
          path = '';
        } else {
          final dir = await getApplicationDocumentsDirectory();
          path = p.join(
            dir.path,
            'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
          );
        }
        await record.start(path: path);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String?> stop() async {
    final path = await record.stop();
    print("saved recording in : $path");
    return path;
  }

  Future<void> pause() => record.pause();

  Future<void> resume() => record.resume();

  @override
  void dispose() {
    stop();
    // TODO: implement dispose
    super.dispose();
  }
}
