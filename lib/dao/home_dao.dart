import 'dart:async';
import 'dart:convert';
import 'package:flutter_trips/model/home_model.dart';
import 'package:http/http.dart' as http;

const HOME_URL  = 'http://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao {
  static Future<HomeModel> fetch() async {
    final response  = await http.get("http://www.devio.org/io/flutter_app/json/home_page.json");
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //fix中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    }else {
      throw Exception('好可怕，请求失败了~\r\n请联系管理员\r\n管理员电话:17600636164');
    }
  }
}