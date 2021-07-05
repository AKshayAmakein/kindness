import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:kindness/components/custome_drawer.dart';
import 'package:kindness/widgets/custom_widgets.dart';


late AudioPlayer advancedPlayer;
late AudioCache audioCache;

class HomeScreenMain extends StatefulWidget {

  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  ConfettiController? confetti;

  @override
  void initState() {
    confetti=ConfettiController(duration : Duration(seconds: 5));
    initAudioPlayer();
    super.initState();
  }

  initAudioPlayer(){
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          ScratchCard(context,confetti!);
        },
      ),
      appBar: AppBar(
        title: Text('My act'),
      ),
      drawer: CustomDrawer(),
    );
  }
}
