import 'dart:async';
import 'dart:convert';
import 'package:flutter_trips/model/travel_model.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Map<String, dynamic> Params=  {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
  "pageIndex": 1,
  "pageSize": 10,
  "sortType": 9,
  "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {'cid': "09031014111431397988"},
  "contentType": "json"
};
//旅拍页接口
class TravelTabDao {
  /*
  * url post请求的接口
  * groupChannelCode 请求旅拍模块哪个类别下的数据
  * pageIndex 分页的第几页
  * pageSize 每页显示多少条
  * */
  static Future<TravelModel> fetch( String url, String groupChannelCode, int pageIndex, int pageSize ) async {
    //构造请求参数
    Map paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;
    final response  = await http.post(url, headers: {},body: jsonEncode(Params));
    if(response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //fix中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelModel.fromJson(result);
    }else {
      throw Exception('请求失败了~\r\n请联系管理员');
    }
  }
}