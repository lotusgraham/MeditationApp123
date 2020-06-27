import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'audioPlayer.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          buildReadyToBegin(),
          const SizedBox(height: 20),
          buildGroupMeditation(),
          const SizedBox(height: 20),
          buildMyCourse(),
        ],
      ),
    );
  }

  buildReadyToBegin() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AudioPlayerDemo(
                audioName: "name",
                url:
                    'https://firebasestorage.googleapis.com/v0/b/zombiechat-ac536.appspot.com/o/HeartChakra.mp3?alt=media&token=a9354b2b-4e6d-45c0-81f7-ac26e0eac074'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Ready to begin?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const Text("Start your journey with session 1 of the Basics",
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 20),
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('asset/img/Scroll-1.png'),
                      alignment: Alignment.centerRight,
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 135, 198, .3),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    )
                  ]),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 20, 100, 10),
                child: Column(
                  children: <Widget>[
                    const Text(
                        'Live happier and healthier by learning the fundamentals of meditation and mindfulness.',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '3 - 10 Min . COURSE',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RaisedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.play_circle_outline),
                      label: Text('Begin Course'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildGroupMeditation() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AudioPlayerDemo(
                audioName: "name",
                url:
                    'https://firebasestorage.googleapis.com/v0/b/zombiechat-ac536.appspot.com/o/HeartChakra.mp3?alt=media&token=a9354b2b-4e6d-45c0-81f7-ac26e0eac074'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Group Meditation",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const Text("Try 3 sessions for free",
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 20),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('asset/img/groupMeditation.jpg'),
                      alignment: Alignment.centerRight,
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 135, 198, .3),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    )
                  ]),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 100, 10),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Transforming the mind',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        const Text('3-20 min  . Meditation.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildMyCourse() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("My Courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 170,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AudioPlayerDemo(
                              audioName: "name",
                              url:
                                  'https://firebasestorage.googleapis.com/v0/b/zombiechat-ac536.appspot.com/o/HeartChakra.mp3?alt=media&token=a9354b2b-4e6d-45c0-81f7-ac26e0eac074'),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Image.network(
                        "http://www.sumadroid.com/wp-content/uploads/2015/11/Sqr-Icon-770x770.png",
                      ),
                      title: Text('Productivity'),
                      subtitle: Text('10-20 min. Course'),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
              physics: BouncingScrollPhysics(),
            ),
          )
        ],
      ),
    );
  }
}
