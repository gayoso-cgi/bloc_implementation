import 'dart:convert';

import 'package:bloc_implementation/src/models/CategoryContent/CategoryContent.dart';
import 'package:bloc_implementation/src/services/api_client.dart';

class DetailScreenRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryContent> getLainnya(String url) async {
    final response = await _helper.get(url);
    return CategoryContent.fromJson({
      "data": [response["data"]]
    });
  }
}
