import 'package:bloc_implementation/src/helper/constants/api_constants.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/services/api_client.dart';


class HomeScreenRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryContent> getDigitalContent() async {
    final response = await _helper.get(ApiEndpoint.getDigitalContent);
    return CategoryContent.fromJson(response["data"]);
  }

  Future<CategoryContent> getDigitalContentArticle(String page) async {
    final response = await _helper.get("${ApiEndpoint.getDigitalContentArticle}");
    //TODO comment for get page ...?page=${page}");
    // final response = await _helper.get("${ApiEndpoint.getDigitalContentArticle}?page=${page}");
    return CategoryContent.fromJson(response["data"]);
  }

  Future<CategoryContent> getDigitalContentPdf(String page) async {
    final response = await _helper.get("${ApiEndpoint.getDigitalContentPdf}");
    //TODO comment for get page ...?page=${page}");
    // final response = await _helper.get("${ApiEndpoint.getDigitalContentPdf}?page=${page}");
    return CategoryContent.fromJson(response["data"]);
  }

  Future<CategoryContent> getDigitalContentVideo(String page) async {
    final response = await _helper.get("${ApiEndpoint.getDigitalContentVideo}");
    //TODO comment for get page ...?page=${page}");
    // final response = await _helper.get("${ApiEndpoint.getDigitalContentVideo}?page=${page}");
    return CategoryContent.fromJson(response["data"]);
  }

  Future<CategoryContent> getSearch(String? value, String page) async {
    final response = await _helper.get("${ApiEndpoint.getSearch}${value}");
    //TODO comment for get page ...?page=${page}");
    // final response = await _helper.get("${ApiEndpoint.getSearch}${value}?page=${page}");
    return CategoryContent.fromJson(response["data"]);
  }
}
