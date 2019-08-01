//首页模型的config Object
class ConfigModel {
  final String searchUrl;
  ConfigModel({this.searchUrl});
  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
        searchUrl: json['searchUrl']
    );
  }
  Map<String, String> toJson() {
    print('up---------------------');
    return { searchUrl: searchUrl};
  }
}