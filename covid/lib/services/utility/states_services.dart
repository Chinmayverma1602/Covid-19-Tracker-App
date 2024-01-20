import 'dart:convert';

import 'package:covid/services/utility/app_url.dart';
import 'package:covid/view/model/worldstatesmodel.dart';
import 'package:covid/view/world_screen.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<Worldstatesmodel> fecthWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Worldstatesmodel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    var data;
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
       data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception('Error');
    }
  }
}
