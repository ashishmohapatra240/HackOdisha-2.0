import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nirbhaya/constants.dart';
import 'package:nirbhaya/features/widgets/article_desc.dart';
import 'package:nirbhaya/features/widgets/safe_webview.dart';

class Carousel extends StatelessWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 160,
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
          items: List.generate(
              imageSliders.length,
              (index) => Hero(
                    tag: articleTitle[index],
                    child: Card(
                      elevation:0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          // WebviewScaffold(
                          //   url: "https://www.google.com",
                          //   appBar: new AppBar(
                          //     title: new Text("Widget webview"),
                          //   ),
                          // ),
                          if (index == 0) {
                            navigateToRoute(
                                context,
                                SafeWebView(
                                    index: index,
                                    title: "Read Mandakani's story",
                                    url:
                                        "https://gulfnews.com/world/asia/pakistan/womens-day-10-pakistani-women-inspiring-the-country-1.77696239"));
                          } else if (index == 1) {
                            navigateToRoute(
                                context,
                                SafeWebView(
                                    index: index,
                                    title: "Read Kamala's story",
                                    url:
                                        "https://plan-international.org/ending-violence/16-ways-end-violence-girls"));
                          } else if (index == 2) {
                            navigateToRoute(context, ArticleDesc(index: index));
                          } else {
                            navigateToRoute(
                                context,
                                SafeWebView(
                                    index: index,
                                    title: "Read Supriya's story",
                                    url:
                                        "https://www.healthline.com/health/womens-health/self-defense-tips-escape"));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(imageSliders[index]),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.5),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight)),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Text(
                                  articleTitle[index],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width * 0.05,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  void navigateToRoute(
    BuildContext context,
    Widget route,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => route,
      ),
    );
  }
}
