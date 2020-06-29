import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:story_view/story_view.dart';
import 'package:meditation/util/color.dart';
import 'package:shimmer/shimmer.dart';

class Stories extends StatefulWidget {
  final dynamic fsl;
  const Stories(this.fsl);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  List<dynamic> storyItemDetails = [];
  _getStoryItems() async {
    for (var items in widget.fsl) {
      Map tempObj = {};
      if (items['storyImage'].length > 0)
        tempObj['storyImage'] =
            await items['storyImage'][0].get().then((documentSnapshot) {
          return documentSnapshot.data['file'];
        });
      if (items.containsKey('caption') && items['caption'] != "")
        tempObj['caption'] = items['caption'];
      storyItemDetails.add(tempObj);
    }
    if (mounted) {
      setState(() {});
    }
  }

  initState() {
    super.initState();
    _getStoryItems();
  }

  final storyController = StoryController();

  /// dispose stories Controller
  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  ///Displaying Static story
  @override
  Widget build(BuildContext context) {
    List<StoryItem> items = [];
    var n = 0;
    while (storyItemDetails.length > n) {
      // When there is image or gif.
      if (storyItemDetails[n].containsKey('storyImage')) {
        items.add(
          StoryItem.pageGif(
            "https://firebasestorage.googleapis.com/v0/b/${GlobalConfiguration().getString("firebaseProjectID")}.appspot.com/o/flamelink%2Fmedia%2F${storyItemDetails[n]['storyImage']}?alt=media",
            imageFit: BoxFit.cover,
            duration: const Duration(seconds: 10),
            // shown: true,
            controller: storyController,
            caption: storyItemDetails[n].containsKey('caption')
                ? storyItemDetails[n]['caption']
                : null,
          ),
        );
      }
      // When there is only caption and no image.
      if (!storyItemDetails[n].containsKey('storyImage') &&
          storyItemDetails[n].containsKey('caption')) {
        items.add(StoryItem.text(
          storyItemDetails[n]['caption'],
          primaryColor,
        ));
      }
      n++;
    }
    return Scaffold(
      body: storyItemDetails.length > 0
          ? StoryView(
              items,
              onStoryShow: (s) {},
              onComplete: () {
                Navigator.pop(context);
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: storyController,
            )
          : Container(
              color: Colors.black87,
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: darkPrimaryColor,
                child: Center(
                  child: Image.asset(
                    'asset/img/logo-with-text.png',
                    height: 100.0,
                  ),
                ),
              ),
            ),
    );
  }
}
