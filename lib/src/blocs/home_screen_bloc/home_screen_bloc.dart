import 'package:bloc_implementation/src/services/api_repository.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/repositories/main_repository/home_screen_application.dart';
import 'package:bloc_implementation/src/repositories/main_repository/home_screen_repository.dart';

import 'dart:async';
import 'package:bloc_implementation/src/services/api_repository.dart';

class HomeScreenBloc {
  StreamController<ApiResponse<CategoryContent>> stateStream =
      StreamController<ApiResponse<CategoryContent>>.broadcast();

  Sink<ApiResponse<CategoryContent>> get _input => stateStream.sink;

  Stream<ApiResponse<CategoryContent>>? get streams => stateStream.stream;

  final HomeScreenRepository? _homeScreeenRepository = HomeScreenRepository();
  HomeScreenApplication application;

  HomeScreenBloc() : application = HomeScreenApplication();

  setStateApplication(HomeScreenApplication state) {
    application = state;
  }

  loadMoreBloc(CategoryContentEnum type) {
    application.isLoadingServiceSetTrue();
    try {
      application.nextPage();
      if (CategoryContentEnum.VIDEO == type) {
        return fetchContentVideoBloc();
      } else if (CategoryContentEnum.ARTICLE == type) {
        return fetchContentArticleBloc();
      } else if (CategoryContentEnum.PDF == type) {
        return fetchContentPdfBloc();
      } else if (CategoryContentEnum.SEARCH == type) {
        return fetchSearchBloc("");
      }
    } catch (e) {
      application.previeusePage();
      _error(e);
    }
  }

  fetchContentArticleBloc() async {
    application.isLoadingServiceSetTrue();
    _input.add(ApiResponse.loading('Please wait'));
    try {
      CategoryContent data = (await _homeScreeenRepository!
          .getDigitalContentArticle(application.currentPage.toString()));
      application.getArtikelContent(data);
      updateContext();
    } catch (e) {
      _error(e);
    }
  }

  fetchContentPdfBloc() async {
    application.isLoadingServiceSetTrue();
    _input.add(ApiResponse.loading('Please wait'));
    try {
      CategoryContent data = (await _homeScreeenRepository!
          .getDigitalContentPdf(application.currentPage.toString()));
      application.getPdfContent(data);
      updateContext();
    } catch (e) {
      _error(e);
    }
  }

  fetchContentVideoBloc() async {
    application.isLoadingServiceSetTrue();
    _input.add(ApiResponse.loading('Please wait'));
    try {
      CategoryContent data = (await _homeScreeenRepository!
          .getDigitalContentVideo(application.currentPage.toString()));
      application.getVideoContent(data);
      updateContext();
    } catch (e) {
      _error(e);
    }
  }

  fetchSearchBloc(String value) async {
    application.isLoadingServiceSetTrue();
    application.setTextSearch(value);
    _input.add(ApiResponse.loading('Please wait'));
    try {
      CategoryContent data = (await _homeScreeenRepository!
          .getSearch(value, application.currentPage.toString()));
      application.getSearchContent(data);
      updateContext();
    } catch (e) {
      _error(e);
    }
  }

  getContentBloc(CategoryContentEnum type, {String? search}) async {
    application.isLoadingServiceSetTrue();
    application.setCategoryType(type);
    application.isLihatSemuaFunc();
    try {
      if (CategoryContentEnum.VIDEO == type) {
        return fetchContentVideoBloc();
      } else if (CategoryContentEnum.ARTICLE == type) {
        return fetchContentArticleBloc();
      } else if (CategoryContentEnum.PDF == type) {
        return fetchContentPdfBloc();
      } else if (CategoryContentEnum.SEARCH == type) {
        return fetchSearchBloc(search ?? "");
      } else {
        reset(type);
      }
    } catch (e) {
      _error(e);
    }
  }

  reset(CategoryContentEnum contents, {String? search}) {
    application.isLoadingServiceSetTrue();
    application.resetApplications(contents);
    switch (contents) {
      case CategoryContentEnum.VIDEO:
        return fetchContentVideoBloc();

      case CategoryContentEnum.ARTICLE:
        return fetchContentArticleBloc();

      case CategoryContentEnum.PDF:
        return fetchContentPdfBloc();

      case CategoryContentEnum.SEARCH:
        return fetchSearchBloc(search ?? "");

      case CategoryContentEnum.RESET:
        fetchContentVideoBloc();
        fetchContentArticleBloc();
        fetchContentPdfBloc();
        print('back');
        return;
    }
  }

  updateContext() {
    application.isLoadingServiceSetFalse();
    _input.add(ApiResponse.completed(application.setContent()));
  }

  _error(e) {
    application.isLoadingServiceSetFalse();
    _input.add(ApiResponse.error(e.toString()));
    print(e);
  }

  dispose() {
    stateStream.close();
  }
}
