import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:untitled1/barrier.dart';
import 'package:untitled1/models/Highscore.dart';
import 'package:untitled1/bird.dart';
import 'package:untitled1/models/Highscore.dart';
import 'package:untitled1/models/api.services.dart';
import 'package:untitled1/models/api.services.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int score = 0;
  Highscore highscore = new Highscore();
  static double birdY= 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 2.5;
  double birdWidth = 0.3;
  double birdHeight =0.16;

  double sizeTop1 = 0.35;
  double sizeBottom1 = 0.35;

  double sizeTop2 = 0.25;
  double sizeBottom2 = 0.45;

  static double barrierWidth = 0.4;

  var numberRandom = Random();
  double numberSize = 0;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.7;

  bool gameHasStarted = false;




  void startGame(){
      getHighScore();
      gameHasStarted = true;
      Timer.periodic(const Duration(milliseconds: 50), (timer){
        height = gravity * time * time + velocity * time;
        setState(() {
          birdY = initialPos - height;
        });
        setState(() {
          if (barrierXone < -1.1) {
            numberSize = (numberRandom.nextInt(5)+1)/10 ;
            barrierXone += 3.4;
            sizeTop1 = numberSize;
            sizeBottom1 = 0.7 - sizeTop1;
          } else {
            barrierXone -= 0.03;
          }
          if (barrierXtwo < -1.1) {
            numberSize = (numberRandom.nextInt(5)+1)/10;
            barrierXtwo += 3.4;
            sizeTop2 = numberSize;
            sizeBottom2 = 0.7 - sizeTop2;
          } else {
            barrierXtwo -= 0.03;
          }
        });

        if(birdIsDead()){

          _showDialog();
          timer.cancel();
          gameHasStarted = false;

        }

        time += 0.04;

      });
      Timer.periodic(
        Duration(milliseconds: 2150),
            (timer) {
          if (gameHasStarted) {
            setState(() {
              score++;
            });
          }

        },
      );

  }
  void resetGame(){
    getHighScore();
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;

      sizeTop1 = 0.35;
      sizeBottom1 = 0.35;

      sizeTop2 = 0.25;
      sizeBottom2 = 0.45;

      numberRandom = Random();
      numberSize = 0;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.7;
      score = 0;
    });
  }
  void _showDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contet){
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              "GAME OVER",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),

            )
          ],
        );
      }
    );
  }
  bool birdIsDead(){

    double distX1 = (0 - barrierXone).abs();
    double distX2 = (0 - barrierXtwo).abs();

    double distYT1 = (birdY - (-0.9 + sizeTop1/2)).abs();
    double distYB1 = (birdY - (0.65 - sizeBottom1/2)).abs();
    double distYT2 = (birdY - (-0.9 + sizeTop2/2)).abs();
    double distYB2 = (birdY - (0.5 - sizeBottom2/2)).abs();

    double defaultX = (birdWidth/2) + (barrierWidth/2);
    double defaultY1 = (birdHeight/2) + (sizeTop1/2);
    double defaultY2 = (birdHeight/2) + (sizeBottom1/2);
    double defaultY3 = (birdHeight/2) + (sizeTop2/2);
    double defaultY4 = (birdHeight/2) + (sizeBottom2/2);



    if ((distX1 <= defaultX && distYT1 <= defaultY1) || (distX1 <= defaultX && distYB1 <= defaultY2) || (distX2 <= defaultX && distYT2 <= defaultY3) || (distX2 <= defaultX && distYB2 <= defaultY4)) {
      return true;
    }

    if(birdY < -1 || birdY > 1){
      return true;
    }

    return false;
  }
  void jump(){
    setState(() {
      time = 0;
      initialPos = birdY;
    });

  }

  void getHighScore(){
    APIServices.getData().then((response){
        //Iterable highScore = json.decode(response.body);
        Map<String, dynamic> highScore = jsonDecode(response);
        var score = highScore['highestScore'];
        print(score);
        setState(() {
          highscore = score as Highscore;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),

                      Container(
                          alignment: Alignment(0, -0.25),
                          child: gameHasStarted
                              ? Text("")
                              : Text("T A P  T O  P L A Y",
                              style: TextStyle(color: Colors.white, fontSize: 20)
                          )
                      ),

                      AnimatedContainer(
                        alignment: Alignment(barrierXone, -1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: sizeTop1,
                          barrierWidth: barrierWidth,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXone, 1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: sizeBottom1,
                          barrierWidth: barrierWidth,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXtwo, -1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: sizeTop2,
                          barrierWidth: barrierWidth,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXtwo, 1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: sizeBottom2,
                          barrierWidth: barrierWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                color: Colors.green,
                height: 15
            ),
            Expanded(
                child: Container(
                    color: Colors.brown,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("SCORE", style: TextStyle(color: Colors.white, fontSize: 20)),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(

                                    score.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 35)
                                )]
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("BEST", style: TextStyle(color: Colors.white, fontSize: 20)),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(highscore.getHighcore.toString(), style: TextStyle(color: Colors.white, fontSize: 35))]


                          )
                        ]
                    )
                )
            )
          ],
        ),
      ),
    ) ;
  }
}
