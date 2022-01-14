
class Highscore{
  int _id = 0;
  int _highscore = 0;


  Highscore();
  Highscore.WithId(this._id, this._highscore);


  int get getId => _id;
  int get getHighcore => _highscore;

  set id (int id){
    _id = id;
  }
  set highsocre(int highscore){
    _highscore = highscore;
  }


}