class BannerResponse {
  String? status;
  BannerData? data;

  BannerResponse({this.status, this.data});

  BannerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? BannerData.fromJson(json['data']) : null;
  }
}

class BannerData {
  List<BannerItem>? banners;

  BannerData({this.banners});

  BannerData.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = List<BannerItem>.from(
        json['banners'].map((x) => BannerItem.fromJson(x)),
      );
    }
  }
}

class BannerItem {
  int? id;
  String? title;
  String? image;

  BannerItem({this.id, this.title, this.image});

  BannerItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }
}
