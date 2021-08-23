import 'dart:convert';

import 'package:bloc_implementation/src/models/CategoryContent/category_content_artikel.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_pdf.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_video.dart';
import 'package:bloc_implementation/src/models/CategoryContent/icategory_content.dart';
import 'package:bloc_implementation/src/services/local_storages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CategoryContentEnum.dart';

class CategoryContent {
  final List<ICategoryContent> categoryContentList = [];
  ICategoryContent? content;
  LocalStorage? _preference = LocalStorage();
  bool? showDialogVideosOnFirst;

  Object? object;

  CategoryContent();

  CategoryContent.fromJson(json) {
    if (showDialogVideosOnFirst == null) {
      _checkIfDialogOnVideo().then((value) => value);
    }

    List data = json["data"];
    if (data != null) {
      data.map((e) {
        if (e["jenis_content"] == CategoryContentEnum.ARTICLE.name) {
          categoryContentList.add(KategoryContentArtikel.fromJson(e));
        } else if (e["jenis_content"] == CategoryContentEnum.VIDEO.name) {
          categoryContentList.add(KategoryContentVideo.fromJson(e));
        } else if (e["jenis_content"] == CategoryContentEnum.PDF.name) {
          categoryContentList.add(KategoryContentPDF.fromJson(e));
        }
      }).toList();
    }
  }

  List<KategoryContentArtikel>? articles() {
    final u = categoryContentList
        .where((element) =>
            element.jenisContent == CategoryContentEnum.ARTICLE.name)
        .toList();
    List<KategoryContentArtikel> _articles = [];
    u.map((element) {
      if (element is KategoryContentArtikel) {
        _articles.add(element);
      }
    }).toList();
    return _articles;
  }

  List<KategoryContentPDF>? pdfs() {
    final u = categoryContentList
        .where(
            (element) => element.jenisContent == CategoryContentEnum.PDF.name)
        .toList();
    List<KategoryContentPDF> _pdf = [];
    u.map((element) {
      if (element is KategoryContentPDF) {
        _pdf.add(element);
      }
    }).toList();
    return _pdf;
  }

  List<KategoryContentVideo>? videos() {
    final u = categoryContentList
        .where(
            (element) => element.jenisContent == CategoryContentEnum.VIDEO.name)
        .toList();
    List<KategoryContentVideo> _video = [];
    u.map((element) {
      if (element is KategoryContentVideo) {
        _video.add(element);
      }
    }).toList();
    return _video;
  }

  CategoryContent.setObject(Object objects) {
    object = objects;
  }

  CategoryContent.setContent(ICategoryContent? contents) {
    content = contents as ICategoryContent?;
  }

  Future _checkIfDialogOnVideo(
      {String name = "showDialogVideosOnFirst"}) async {
    showDialogVideosOnFirst = await _preference!.getStorage(name);
  }

  Future setIfDialogOnVideo({String name = "showDialogVideosOnFirst"}) async {
    await _preference!.setBoolStorage(name, true);
    await _checkIfDialogOnVideo();
  }

  reset(CategoryContentEnum contents){
    switch(contents){

      case  CategoryContentEnum.VIDEO:
        return categoryContentList.removeWhere((element) => element is KategoryContentVideo);

      case CategoryContentEnum.ARTICLE:
        return categoryContentList.removeWhere((element) => element is KategoryContentArtikel);

      case CategoryContentEnum.PDF:
        return categoryContentList.removeWhere((element) => element is KategoryContentPDF);

      case CategoryContentEnum.RESET:
        categoryContentList.clear();
        return ;

    }
  }
}
