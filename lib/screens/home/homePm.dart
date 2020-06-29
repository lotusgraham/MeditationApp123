import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../details.dart';
import '../stories.dart';

class HomePm extends ChangeNotifier {
  List featuredStoryList = [];
  List categoryList = [];
  int selectedIndex = 0;
  bool wasVideoPlaying = false;

  BuildContext context;
  YoutubePlayerController controller;

  HomePm(this.context) {
    _getFeaturedStories();
    _getCategories();

    initYtController();
  }

  initYtController() {
    this.controller = YoutubePlayerController(
      initialVideoId: '54wc1r-toAw',
      flags: YoutubePlayerFlags(
        loop: true,
        autoPlay: false,
        startAt: 55,
      ),
    );
  }

  changeSelectedPage(int i) {
    if (i == 0 && wasVideoPlaying) {
      controller.play();
    } else if (selectedIndex == 0) {
      if (controller.value.isPlaying) {
        wasVideoPlaying = true;
        controller.pause();
      } else {
        wasVideoPlaying = false;
      }
    }
    selectedIndex = i;

    _notify();
  }

  _getFeaturedStories() async {
    return Firestore.instance
        .collection('fl_content')
        .where("_fl_meta_.schema", isEqualTo: "featuredStories")
        .snapshots()
        .listen((data) async {
      featuredStoryList = [];
      Map fetchedObj;
      for (var doc in data.documents) {
        fetchedObj = doc.data;
        String coverImage =
            await doc['coverImage'][0].get().then((documentSnapshot) {
          return documentSnapshot.data['file'];
        });
        fetchedObj['coverImage'] = coverImage;
        featuredStoryList.add(fetchedObj);
      }
      _notify();
      return featuredStoryList;
    });
  }

  _getCategories() async {
    return Firestore.instance
        .collection('fl_content')
        .where("_fl_meta_.schema", isEqualTo: "categories")
        .snapshots()
        .listen((data) async {
      categoryList =
          []; // Empty the array. Otherwise multiple stories will be made if database changes.
      Map fetchedObj;
      for (var doc in data.documents) {
        fetchedObj = doc.data;

        String coverImage =
            await doc['coverImage'][0].get().then((documentSnapshot) {
          return documentSnapshot.data['file'];
        });
        fetchedObj['coverImage'] = coverImage;
        categoryList.add(fetchedObj);
      }

      _notify();
      return categoryList;
    });
  }

  onCategorySelect(dynamic cl) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Details(
          id: cl['id'],
          coverImage: cl['coverImage'],
          name: cl['name'],
        ),
      ),
    );
  }

  onStorySelect(dynamic fsl) {
    Navigator.push(context,
        CupertinoPageRoute(builder: (context) => Stories(fsl['storyItems'])));
  }

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  _notify() {
    try {
      if (this.hasListeners) {
        notifyListeners();
      }
    } catch (e) {}
  }
}
