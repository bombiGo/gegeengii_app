import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/audio.dart';
import 'package:rxdart/rxdart.dart';

import 'components/audio_player_task.dart';

// Future<List<Audio>> fetchAudios() async {
//   final response = await http.get('https://gegeengii.mn/api/sounds');
//   if (response.statusCode == 200) {
//     List<dynamic> body = json.decode(response.body)['sounds'];
//     List<Audio> audios =
//         body.map((dynamic item) => Audio.fromJson(item)).toList();
//     return audios;
//   } else {
//     throw "Can't get audios";
//   }
// }

class SoundScreen extends StatefulWidget {
  @override
  _SoundScreenState createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  Future<List<Audio>> futureAudios;

  /// Tracks the position while the user drags the seek bar.
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    // futureAudios = fetchAudios();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_audio.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        // child: FutureBuilder<List<Audio>>(
        //   future: futureAudios,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //   return
        // } else if (snapshot.hasError) {
        //   return Text("${snapshot.error}");
        // }
        // return CircularProgressIndicator(
        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        // );
        // },
        child: StreamBuilder<ScreenState>(
          stream: _screenStateStream,
          builder: (context, snapshot) {
            final screenState = snapshot.data;
            final queue = screenState?.queue;
            final mediaItem = screenState?.mediaItem;
            final state = screenState?.playbackState;
            final processingState =
                state?.processingState ?? AudioProcessingState.none;
            final playing = state?.playing ?? false;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (processingState == AudioProcessingState.none) ...[
                  audioPlayerButton(),
                ] else ...[
                  if (mediaItem?.title != null)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        mediaItem.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (queue != null && queue.isNotEmpty)
                    SizedBox(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.skip_previous),
                            iconSize: 36.0,
                            onPressed: mediaItem == queue.first
                                ? null
                                : AudioService.skipToPrevious,
                          ),
                          SizedBox(width: 20),
                          if ("$processingState"
                                  .replaceAll(RegExp(r'^.*\.'), '') ==
                              "ready")
                            playing ? pauseButton() : playButton()
                          else
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          SizedBox(width: 20),
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.skip_next),
                            iconSize: 36.0,
                            onPressed: mediaItem == queue.last
                                ? null
                                : AudioService.skipToNext,
                          ),
                        ],
                      ),
                    ),
                  positionIndicator(mediaItem, state, queue),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  /// Encapsulate all the different data we're interested in into a single
  /// stream so we don't have to nest StreamBuilders.
  Stream<ScreenState> get _screenStateStream =>
      Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          (queue, mediaItem, playbackState) =>
              ScreenState(queue, mediaItem, playbackState));

  RaisedButton audioPlayerButton() => startButton(
        'Дуу тоглуулах',
        () {
          AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            // Enable this if you want the Android service to exit the foreground state on pause.
            //androidStopForegroundOnPause: true,
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            androidEnableQueue: true,
          );
        },
      );

  RaisedButton startButton(String label, VoidCallback onPressed) =>
      RaisedButton(
        child: Text(label),
        onPressed: onPressed,
      );

  IconButton playButton() => IconButton(
        color: Colors.white,
        icon: Icon(Icons.play_arrow),
        iconSize: 36.0,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        color: Colors.white,
        icon: Icon(Icons.pause),
        iconSize: 36.0,
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        color: Colors.white,
        icon: Icon(Icons.stop),
        iconSize: 36.0,
        onPressed: AudioService.stop,
      );

  Widget positionIndicator(
      MediaItem mediaItem, PlaybackState state, List<MediaItem> queue) {
    double seekPos;

    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position =
            snapshot.data ?? state.currentPosition.inMilliseconds.toDouble();
        double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        return Column(
          children: [
            if (duration != null)
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 5),
                    child: Text(
                      "${state.currentPosition.toString().substring(0, 7)}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 2.0,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        thumbColor: Colors.white,
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 8.0),
                        tickMarkShape: RoundSliderTickMarkShape(),
                        activeTickMarkColor: Colors.white,
                        inactiveTickMarkColor: Colors.white.withOpacity(0.3),
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        valueIndicatorColor: Colors.white,
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        min: 0.0,
                        max: duration,
                        value: seekPos ?? max(0.0, min(position, duration)),
                        onChanged: (value) {
                          _dragPositionSubject.add(value);
                        },
                        onChangeEnd: (value) {
                          AudioService.seekTo(
                              Duration(milliseconds: value.toInt()));
                          seekPos = value;
                          _dragPositionSubject.add(null);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 20),
                    child: Text(
                      "${mediaItem.duration.toString().substring(0, 7)}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: kPrimaryColor),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (builder) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 1 - 50,
                            color: Color(0xFF737373),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(30.0),
                                  topRight: const Radius.circular(30.0),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      "Дууны жагсаалт",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: queue.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => Material(
                                        color: queue[index].id == mediaItem.id
                                            ? Colors.grey.shade300
                                            : null,
                                        child: ListTile(
                                          title: Text(queue[index].title),
                                          onTap: () {
                                            AudioService.skipToQueueItem(
                                                queue[index].id);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    child: Text(
                      "Жагсаалт".toUpperCase(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {},
                    elevation: 1.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.favorite_border,
                      size: 24.0,
                      color: kPrimaryColor,
                    ),
                    padding: EdgeInsets.all(7.0),
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
