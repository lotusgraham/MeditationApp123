import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/models/splash-model.dart';
import 'package:meditation/screens/auth/login/login.dart';
import 'package:meditation/util/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../util/color.dart';
import 'auth/login/login.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController _pagecontroller;
  int currentPage = 0;

  List<SplashModel> welcomeData = [
    SplashModel(
        header: "Relax and Smile",
        title: "It's Natural",
        description:
            "One thing you can do to help lower your anxiety and improve your overall sense of wellbeing is to smile to your heart.",
        img: "asset/img/Scroll-1.png"),
    SplashModel(
        header: "Free Live Sessions",
        title: "Calendar of Meditations",
        description:
            "Learn this simple method of connecting with the peace within you by attending some live guided sessions",
        img: "asset/img/Scroll-2.png"),
    SplashModel(
        header: "Attention Span",
        title: "Focused-Attention",
        description:
            "Meditation is like weight lifting for your attention span. It helps increase the strength and endurance of your attention.",
        img: "asset/img/Scroll-3.png"),
  ];

  @override
  void initState() {
    super.initState();
    _pagecontroller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: PageView.builder(
                        controller: _pagecontroller,
                        itemCount: 3,
                        itemBuilder: (context, position) {
                          SplashModel data = welcomeData[position];
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(data.img))),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Text(
                                          data.header,
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: 40,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 37),
                                    margin: const EdgeInsets.only(bottom: 40.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(data.title,
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(height: 15.0),
                                        Text(data.description,
                                            style: TextStyle(fontSize: 18))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
                buildBottomNavigationBar()
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            left: MediaQuery.of(context).size.width / 2.4,
            child: SmoothPageIndicator(
              controller: _pagecontroller,
              count: 3,
              effect: WormEffect(
                activeDotColor: primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Login()));
      },
      child: Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 40.0),
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints.expand(),
                color: primaryColor,
                child: Text(
                  "Get Started",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 23,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              color: darkPrimaryColor,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }
}
