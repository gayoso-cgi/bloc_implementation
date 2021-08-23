import 'package:bloc_implementation/src/helper/constants/api_constants.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/models/CategoryContent/CategoryContentEnum.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_artikel.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_pdf.dart';
import 'package:bloc_implementation/src/models/CategoryContent/category_content_video.dart';
import 'package:bloc_implementation/src/models/CategoryContent/icategory_content.dart';
import 'package:bloc_implementation/src/repositories/details_repository/details_repository.dart';
import 'package:bloc_implementation/src/repositories/main_repository/home_screen_repository.dart';

import 'dart:async';
import 'package:bloc_implementation/src/services/api_repository.dart';

class DetailsScreenBloc {
  DetailScreenRepository? _detailScreenRepository;
  StreamController<ApiResponse<CategoryContent>> stateStream =
      StreamController<ApiResponse<CategoryContent>>();

  Sink<ApiResponse<CategoryContent>> get _input => stateStream.sink;

  Stream<ApiResponse<CategoryContent>>? get streams => stateStream.stream;

  DetailsScreenBloc() {
    _detailScreenRepository = DetailScreenRepository();
  }

  fetchDetailContent(ICategoryContent content, CategoryContentEnum type) async {
    _input.add(ApiResponse.loading('Please wait'));
    try {
      CategoryContent data = (await _detailScreenRepository!
          .getLainnya("${ApiEndpoint.getDetail}${content.id.toString()}"));
      _input.add(ApiResponse.completed(data));
    } catch (e) {
      _input.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchContentVideoLainnya(
      ICategoryContent content, CategoryContentEnum type) async {
    _input.add(ApiResponse.loading('Please wait'));
    try {
      CategoryContent data = (await _detailScreenRepository!
          .getLainnya(ApiEndpoint.getDigitalContentVideo));
      // _input.add(ApiResponse.completed(data));
      return _update(data, type);
    } catch (e) {
      _input.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  _update(CategoryContent data, content) {
    data.categoryContentList.removeWhere((element) {
      if (element is KategoryContentVideo) {
        return element.id == content.id;
      } else if (element is KategoryContentPDF) {
        return element.id == content.id;
      } else if (element is KategoryContentArtikel) {
        return element.id == content.id;
      } else {
        return false;
      }
    });
    _input.add(ApiResponse.completed(data));
  }

  dispose() {
    stateStream.close();
  }
}
