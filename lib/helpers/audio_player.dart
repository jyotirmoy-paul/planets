import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

typedef AudioPlayerFactory = ValueGetter<AudioPlayer>;

AudioPlayer getAudioPlayer() => AudioPlayer();

extension AudioPlayerExtension on AudioPlayer {
  Future<void> replay(Source source) async {
    await stop();
    await seek(Duration.zero);
    unawaited(play(source));
  }
}
