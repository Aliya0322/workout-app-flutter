import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

class VideoInfo extends StatefulWidget {
  const VideoInfo({super.key});

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List videoInfo = [];
  bool _playArea = false;
  bool _isPlaying=false;
  bool _disposed = false;
  int _isPlayingIndex=-1;
  VideoPlayerController? _controller;

  Future<void> _initData() async {
    await DefaultAssetBundle.of(context).loadString("assets/video_info.json").then((value) {
      setState(() {
        videoInfo = jsonDecode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose(){
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller=null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _playArea==false?BoxDecoration(
           gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Colors.lightBlueAccent,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                ),
        ):BoxDecoration(
          color: Colors.blue
        ),
        child: Column(
          children: [
            _playArea==false?Container(
              padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.off(() => HomePage());
                        },
                        child: Icon(Icons.arrow_back_ios, size: 20,
                        color: Colors. white,),
                      ),
                      Expanded(child: Container()),
                      Icon(Icons.info_outline, size: 20,
                      color: Colors. white,),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                   Text(
                      "Legs Toning",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "and Glutes Workout",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Container(
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Colors.lightBlue,
                              Colors.lightBlue
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.timer, 
                              size: 20,
                              color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "60 min",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 20,),
                        Container(
                          width: 240,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Colors.lightBlue,
                              Colors.lightBlue
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.handyman_outlined, 
                              size: 20,
                              color: Colors.white),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Resistent band, kettebell",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ):Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top:50, left:30, right: 30),
                    height: 100,
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios,
                        size:20,
                        color: Colors.white),
                      ),
                      Expanded(child: Container()),
                      Icon(Icons.info_outline,
                      size:20,
                      color: Colors.white)
                    ],),
                  ),
                  _playView(context),
                  _controlView(context)
                ],
              ),
            ),
            Expanded(child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60) )
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30,),
                      Text(
                        "Circuit 1: Legs Toning",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: Container()),
                      Row(children: [
                        Icon(Icons.loop,
                        size: 30,
                        color: Colors.blueAccent),
                        SizedBox(width: 10,),
                        Text(
                          "4 sets",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent
                          ),
                        )
                      ],),
                      SizedBox(width: 20,)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Expanded(child: _listView()),
                ],
              ),
            ))
          ],
        ),
      ),
      );
  }
String convertTwo(int value) {
  return value < 10 ? '0$value' : '$value';
}
 Widget _controlView(BuildContext context) {
  final noMute=(_controller?.value.volume??0)>0;
  final duration = _duration?.inSeconds ?? 0;
  final head = _position?.inSeconds ?? 0;
  final remained = max(0, duration - head);
  final mins = convertTwo(remained ~/ 60.0);
  final secs = convertTwo(remained % 60);
  return Column(
  children: [
     SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTickMarkColor: Colors.red[700],
              inactiveTickMarkColor: Colors.red[100],
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 2.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
              thumbColor: Colors.redAccent,
              overlayColor: Colors.red.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28),
              tickMarkShape: RoundSliderTickMarkShape(),
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.redAccent,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            child: Slider(
              value: max(0, min(_progress*100, 100)),
              min: 0,
              max: 100,
              divisions: 100,
              label: _position?.toString().split(".")[0],
              onChanged: (value) {
                setState(() {
                  _progress=value*0.01;
                });
                onChangeStart:(value){
                  _controller?.pause();
                };
                onChangeEnd:(value){
                  final duration = _controller?.value.duration;
                  if (duration != null) {
                    var newValue=max(0,min(value,99))*0.01;
                    var millis = (duration.inMilliseconds*newValue).toInt();
                    _controller?.seekTo(Duration(milliseconds: millis));
                    _controller?.play();
                  }
                };
              },
            ),
          ),
    Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
               
              });
              if (noMute) {
                _controller?.setVolume(0.0);
              } else {
                _controller?.setVolume(1.0);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                child: Icon(
                  noMute ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final index = _isPlayingIndex - 1;
              if (index >= 0 && videoInfo.isNotEmpty) {
                _initializeVideo(index);
              } else {
                Get.snackbar(
                  "Video",
                  '',
                  snackPosition: SnackPosition.BOTTOM,
                  icon: Icon(
                    Icons.face,
                    size: 30,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                  messageText: Text(
                    "No more video to play",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
            child: Icon(
              Icons.fast_rewind,
              size: 36,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () async {
              if (_isPlaying) {
                setState(() {
                  _isPlaying = false;
                });
                _controller?.pause();
              } else {
                setState(() {
                  _isPlaying = true;
                });
                _controller?.play();
              }
            },
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 36,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () async {
              final index = _isPlayingIndex + 1;
              if (index <= videoInfo.length - 1) {
                _initializeVideo(index);
              } else {
                Get.snackbar(
                  "Video List",
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                  icon: Icon(
                    Icons.face,
                    size: 30,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                  messageText: Text(
                    "No more videos in the list",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
            child: Icon(
              Icons.fast_forward,
              size: 36,
              color: Colors.white,
            ),
          ),
          Text(
            "$mins:$secs",
            style: TextStyle(
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 1.0),
                  blurRadius: 4.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
);

}

  Widget _playView(BuildContext context){
    final controller = _controller;
    if(controller!=null&&controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16/9,
        child: VideoPlayer(controller),
      ) ;
    } else {
      return AspectRatio(
        aspectRatio: 16/9,
        child: Center(child: Text("Preparing...",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white
        ),)));
    }
  }
  var _onUpdateControllerTime = DateTime.now().millisecondsSinceEpoch;
  Duration? _duration;
  Duration? _position;
  var _progress=0.0;


  void _onControllerUpdate() async{
    if(_disposed){
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    if(_onUpdateControllerTime>now){
      return;
    }
    _onUpdateControllerTime=now+500;

    final controller = _controller;
    if(controller==null){
      debugPrint("controller is null");
      return;
    }
    if (!controller.value.isInitialized){
      debugPrint("controller cannot be initialized");
      return;
    }

    if(_duration==null) {
      _duration = _controller?.value.duration;
    }
    var duration = _duration;
    if(duration==null) return;

    var position = _duration;
    _position = position;

    _position = await controller.position;

    final playing = controller.value.isPlaying;
    if(playing) {
      if(_disposed) return;
      setState(() {
        _progress=position!.inMilliseconds.ceilToDouble()/duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying=playing;
  }


  _initializeVideo(int index) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(videoInfo[index]['videoURL']),
);
    final old = _controller;
    _controller = controller;
    if(old!=null){
      old.removeListener(()=>_onControllerUpdate());
      old.pause();
    }
    
    setState(() {
      
    });
    await controller.initialize();
  _isPlayingIndex = index;
  controller.addListener(() => _onControllerUpdate()); // ← Исправлено
  controller.play();

  setState(() {});
}
  _listView() {
    return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    itemCount: videoInfo.length,
                    itemBuilder: (_,int index){
                    return GestureDetector(
                      onTap: () {
                        _initializeVideo(index);
                        debugPrint(index.toString());
                        setState(() {
                          if(_playArea==false){
                            _playArea=true;
                          }
                        });
                        },
                        child: _buildCard(index),
                      );
                  });
    
  }
  _buildCard(int index){
    return Container(
                          height: 135,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 130,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          videoInfo[index]["thumbnail"]
                                        ),
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        videoInfo[index]["title"],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:3),
                                        child: Text(
                                          videoInfo[index]["time"],
                                          style: TextStyle(
                                            color: Colors.grey
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(
                                      child: Text(
                                        "15 sec rest",
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      for(int i=0; i<70; i++)
                                      i.isEven?Container(
                                        width: 3,
                                        height: 1,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(2)
                                        ),
                                      ):Container(
                                        width: 3,
                                        height: 1,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
  }
}