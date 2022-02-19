import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

typedef AudioPlayerFactory = ValueGetter<AudioPlayer>;

AudioPlayer getAudioPlayer() => AudioPlayer();

extension AudioPlayerExtension on AudioPlayer {
  Future<void> replay() async {
    await stop();
    await seek(null);
    unawaited(play());
  }
}
