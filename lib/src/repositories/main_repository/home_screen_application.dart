import '../../models/CategoryContent/CategoryContent.dart';
import '../../models/CategoryContent/CategoryContentEnum.dart';
import '../../models/CategoryContent/icategory_content.dart';

class HomeScreenApplication {
  List<ICategoryContent>? pdfContent;
  List<ICategoryContent>? artikelContent;
  List<ICategoryContent>? videoContent;
  List<ICategoryContent>? searchContent;
  String? textSearch;
  int currentPage = 0;
  bool isLoadingService = true;
  bool isLihatSemua = true;
  ICategoryContent? detailContent;
  CategoryContentEnum currentCategory = CategoryContentEnum.RESET;

  CategoryContent? content;
  HomeScreenApplication({
    this.pdfContent,
    this.artikelContent,
    this.videoContent,
    this.searchContent,
    this.textSearch,
    this.currentPage = 0,
    this.isLoadingService = true,
    this.isLihatSemua = true,
    this.detailContent = null,
    this.currentCategory = CategoryContentEnum.RESET,
    this.content = null,
  }) {
    if (pdfContent == null) {
      pdfContent = [];
    }
    if (artikelContent == null) {
      artikelContent = [];
    }
    if (videoContent == null) {
      videoContent = [];
    }
    if (searchContent == null) {
      searchContent = [];
    }
  }

  nextPage() {
    currentPage = currentPage + 1;
  }

  previeusePage() {
    if (currentPage != 0) {
      currentPage = currentPage - 1;
    }
  }

  setTextSearch(String value) {
    textSearch = value;
  }

  setCategoryType(CategoryContentEnum type) {
    currentCategory = type;
  }

  isLoadingServiceSetTrue() {
    isLoadingService = true;
  }

  isLoadingServiceSetFalse() {
    isLoadingService = false;
  }

  isLihatSemuaFunc() {
    if (currentCategory != CategoryContentEnum.RESET) {
      isLihatSemua = false;
    } else {
      isLihatSemua = true;
    }
  }

  setLihatSemuaTrue() {
    isLihatSemua = true;
  }

  setLihatSemuaFalse() {
    isLihatSemua = false;
  }

  List<ICategoryContent>? getArtikelContent(CategoryContent content) {
    // setCategoryType(CategoryContentEnum.ARTICLE);
    pdfContent!.addAll(content.articles()!);
    return pdfContent;
  }

  List<ICategoryContent>? getPdfContent(CategoryContent content) {
    // setCategoryType(CategoryContentEnum.PDF);
    artikelContent!.addAll(content.pdfs()!);
    return artikelContent;
  }

  List<ICategoryContent>? getVideoContent(CategoryContent content) {
    // setCategoryType(CategoryContentEnum.VIDEO);
    videoContent!.addAll(content.videos()!);
    return videoContent;
  }

  getSearchContent(CategoryContent content) {
    // setCategoryType(CategoryContentEnum.SEARCH);
    searchContent!.addAll(content.categoryContentList);
    return searchContent;
  }

  resetApplications(CategoryContentEnum contents) {
    currentCategory = contents;
    isLihatSemuaFunc();
    isLoadingServiceSetFalse();
    switch (contents) {
      case CategoryContentEnum.VIDEO:
        videoContent!.clear();
        return this;

      case CategoryContentEnum.ARTICLE:
        artikelContent!.clear();
        return this;

      case CategoryContentEnum.PDF:
        pdfContent!.clear();
        return this;

      case CategoryContentEnum.RESET:
        clearData();
        textSearch = "";
        currentPage = 0;
        return this;
    }
  }

  clearData() {
    videoContent!.clear();
    artikelContent!.clear();
    pdfContent!.clear();
    searchContent!.clear();
    isLihatSemuaFunc();
  }

  setDeatil(ICategoryContent d) {
    detailContent = d;
  }

  CategoryContent? setContent() {
    content = CategoryContent();
    content!.categoryContentList.addAll(pdfContent!);
    content!.categoryContentList.addAll(artikelContent!);
    content!.categoryContentList.addAll(videoContent!);
    content!.categoryContentList.addAll(searchContent!);
    return content;
  }

  HomeScreenApplication copyWith(HomeScreenApplication homeScreenApplication) {
    return HomeScreenApplication(
      pdfContent: homeScreenApplication.pdfContent ?? this.pdfContent,
      artikelContent:
          homeScreenApplication.artikelContent ?? this.artikelContent,
      videoContent: homeScreenApplication.videoContent ?? this.videoContent,
      searchContent: homeScreenApplication.searchContent ?? this.searchContent,
      textSearch: homeScreenApplication.textSearch ?? this.textSearch,
      currentPage: homeScreenApplication.currentPage,
      isLoadingService: homeScreenApplication.isLoadingService,
      isLihatSemua: homeScreenApplication.isLihatSemua,
      detailContent: homeScreenApplication.detailContent ?? this.detailContent,
    );
  }
}
