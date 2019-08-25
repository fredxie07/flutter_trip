import 'dart:async';
import 'dart:convert';
import 'package:flutter_trips/model/travel_model.dart';
import 'package:http/http.dart' as http;

const TRAVEL_TAB_URL = 'http://www.devio.org/io/flutter_app/json/travel_page.json';
//旅拍类别接口
class TravelTabDao {
  static Future<TravelModel> fetch() async {
    final response  = await http.get(TRAVEL_TAB_URL);
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //fix中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelModel.fromJson(result);
    }else {
      throw Exception('请求失败了~\r\n请联系管理员');
    }
  }
}