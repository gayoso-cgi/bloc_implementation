/*
  ROUTE LOGIN AND AKTIVATION
 */
import 'package:bloc_implementation/src/models/CategoryContent/category_content_artikel.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_pdf.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_video.dart';
import 'package:bloc_implementation/src/views/details_screens/detail_pdf_screens/detail_pdf_screen.dart';
import 'package:bloc_implementation/src/views/details_screens/detail_video_screens/detail_video_screens.dart';
import 'package:bloc_implementation/src/views/details_screens/details_article_screens/detail_article_screens.dart';
import 'package:bloc_implementation/src/views/home_screen/home_screens.dart';
import 'package:bloc_implementation/src/views/splash_screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.ROUTE_ID:
        return _materialPageRoute(
          settings,
          SplashScreen(),
        );

      case HomeScreens.ROUTE_ID:
        return _materialPageRoute(settings, HomeScreens());

      case DetailVideoScreens.ROUTE_ID:
        final params = settings.arguments as KategoryContentVideo;
        return _materialPageRoute(settings, DetailVideoScreens(params));

      case DetailArticleScreens.ROUTE_ID:
        final params = settings.arguments as KategoryContentArtikel;
        return _materialPageRoute(
            settings,
            DetailArticleScreens(
              articles: params,
            ));

      case DetailPdfScreens.ROUTE_ID:
        final params = settings.arguments as KategoryContentPDF;
        return _materialPageRoute(
            settings,
            DetailPdfScreens(
              pdfs: params,
            ));

      default:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
    }
  }

  static MaterialPageRoute _materialPageRoute(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute(
      builder: (_) => child,
    );
  }

  static initScreen() {
    return SplashScreen.ROUTE_ID;
  }
}
