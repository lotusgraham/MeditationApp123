import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audio/audio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meditation/screens/song/particle-animation.dart';
import 'package:meditation/util/color.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class AudioPlayerDemo extends StatefulWidget {
  final String url;
  final String audioName;
  AudioPlayerDemo({this.url, this.audioName});
  @override
  State<StatefulWidget> createState() => AudioPlayerDemoState();
}

class AudioPlayerDemoState extends State<AudioPlayerDemo> {
  int totaltime, sessioncompleted, averageduration;

  Audio audioPlayer = new Audio(single: true);
  AudioPlayerState state = AudioPlayerState.STOPPED;
  double position = 0;
  int buffering = 0;
  StreamSubscription<AudioPlayerState> _playerStateSubscription;
  StreamSubscription<double> _playerPositionController;
  StreamSubscription<int> _playerBufferingSubscription;
  StreamSubscription<AudioPlayerError> _playerErrorSubscription;

  Stopwatch watch = Stopwatch();
  Timer timer;
  String elapsedTime = '00:00';

  /// check internet is available or not
  checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Oops! Internet lost'),
              content: Text(
                  'Sorry, Please check your internet connection and then try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  onPressed: () {
                    checkConnectivity();
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else if (result == ConnectivityResult.mobile) {
    } else if (result == ConnectivityResult.wifi) {}
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();

    /// Check Audio Player state
    _playerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      if (mounted) setState(() => this.state = state);
    });

    _playerPositionController =
        audioPlayer.onPlayerPositionChanged.listen((double position) {
      updateTime(position);
      if (mounted) setState(() => this.position = position);
    });

    _playerBufferingSubscription =
        audioPlayer.onPlayerBufferingChanged.listen((int percent) {
      if (mounted && buffering != percent) setState(() => buffering = percent);
    });

    _playerErrorSubscription =
        audioPlayer.onPlayerError.listen((AudioPlayerError error) {
      throw ("onPlayerError: ${error.code} ${error.message}");
    });

    audioPlayer.preload(widget.url);
  }

  final _chartSize = const Size(300.0, 300.0);
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  List<CircularStackEntry> _generateChartData(int minute, int second) {
    /// Check the graph position
    List<CircularStackEntry> data = [
      CircularStackEntry([
        CircularSegmentEntry(
          second.toDouble(),
          Colors.blue,
          rankKey: 'completed',
        ),
        CircularSegmentEntry(
          ((audioPlayer.duration / 1000).round() - second.toDouble()),
          Colors.white,
          rankKey: 'remaining',
        )
      ])
    ];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    Widget status = Container();

    /// cheange display icon using according to state
    switch (state) {
      case AudioPlayerState.LOADING:
        {
          status = Container(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Center(
                    child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 4.0,
                      backgroundColor: Colors.blueAccent,
                    ),
                    Text("$buffering%",
                        style: TextStyle(fontSize: 8.0, color: Colors.white),
                        textAlign: TextAlign.center)
                  ],
                )),
              ));
          if (buffering > 30 && state != AudioPlayerState.READY) onPlay();
          break;
        }

      case AudioPlayerState.PLAYING:
        {
          status = IconButton(
            icon: Icon(Icons.pause, size: 28.0),
            onPressed: onPause,
            color: Colors.white,
          );
          break;
        }

      case AudioPlayerState.READY:
        {
          onPlay();
          break;
        }

      case AudioPlayerState.PAUSED:

      case AudioPlayerState.STOPPED:
        {
          status = IconButton(
              icon: Icon(Icons.play_arrow, size: 28.0),
              onPressed: onPlay,
              color: Colors.white);

          if (state == AudioPlayerState.STOPPED) {
            audioPlayer.seek(0.0);
          }
          if (audioPlayer.isCompleted == true) {
            watch.stop();
          }
          break;
        }
    }

    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 130.0),
          child: FloatingActionButton(
            elevation: 10,
            child: BackButton(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              dispose();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: <Widget>[
          ParticleAnimation(
            screenSize: MediaQuery.of(context).size,
            bgColor: primaryColor,
          ),
          Positioned(
            top: 250,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedCircularChart(
                        key: _chartKey,
                        size: _chartSize,
                        initialChartData:
                            // todo: Refactor.
                            // _generateChartData(0,0),
                            <CircularStackEntry>[
                          new CircularStackEntry(
                            <CircularSegmentEntry>[
                              new CircularSegmentEntry(
                                00.00,
                                Colors.blue,
                                rankKey: 'completed',
                              ),
                              new CircularSegmentEntry(
                                100.00,
                                Colors.white,
                                rankKey: 'remaining',
                              ),
                            ],
                            rankKey: 'progress',
                          ),
                        ],
                        chartType: CircularChartType.Radial,
                        percentageValues: false,
                        holeLabel: '$elapsedTime',
                        labelStyle: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Row(
                          children: <Widget>[
                            status,
                            // FIX: https://github.com/flutter/flutter/issues/29896
                            Slider(
                              max: audioPlayer.duration.toDouble() > 0
                                  ? audioPlayer.duration.toDouble()
                                  : 0,
                              value: audioPlayer.duration.toDouble() >
                                      position.toDouble()
                                  ? position.toDouble()
                                  : audioPlayer.duration.toDouble(),
                              onChanged: onSeek,
                            ),
                            Text(
                              "${transformMilliseconds(audioPlayer.duration)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Positioned(
              top: 100,
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  widget.audioName,
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ))
        ],
      ),
    );
  }

  ///Update time of circular progress bar
  updateTime(timer) {
    if (watch.isRunning) {
      var milliseconds = timer;
      int hundreds = (milliseconds / 10).truncate();
      int seconds = (hundreds / 100).truncate();
      int minutes = (seconds / 60).truncate();

      setState(() {
        elapsedTime =
            '${(minutes % 60).toString().padLeft(2, '0')} : ${(seconds % 60).toString().padLeft(2, '0')}';
        // elapsedTime = transformMilliseconds(watch.elapsedMilliseconds);
        List<CircularStackEntry> data = _generateChartData(minutes, seconds);
        _chartKey.currentState.updateData(data);
      });
    }
  }

  transformMilliseconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minuteStr = (minutes % 60).toString().padLeft(2, '0');
    String secondStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minuteStr:$secondStr";
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _playerPositionController.cancel();
    _playerBufferingSubscription.cancel();
    _playerErrorSubscription.cancel();
    audioPlayer.stop();
    // audioPlayer.release(); Ref: https://github.com/idofilus/flutter_audio/issues/10
    super.dispose();
  }

  onPlay() {
    audioPlayer.play(widget.url);
    watch.start();
  }

  onPause() {
    audioPlayer.pause();
    watch.stop();
  }

  onSeek(double value) {
    audioPlayer.seek(value);
  }
}
