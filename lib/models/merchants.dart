class MerchantListResponse {
  String? status;
  MerchantPaginationData? data;

  MerchantListResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] != null
        ? MerchantPaginationData.fromJson(json["data"])
        : null;
  }
}

class MerchantPaginationData {
  int? currentPage;
  List<MerchantData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<PageLink>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  MerchantPaginationData.fromJson(Map<String, dynamic> json) {
    currentPage = json["current_page"];
    firstPageUrl = json["first_page_url"];
    from = json["from"];
    lastPage = json["last_page"];
    lastPageUrl = json["last_page_url"];
    nextPageUrl = json["next_page_url"];
    path = json["path"];
    perPage = json["per_page"];
    prevPageUrl = json["prev_page_url"];
    to = json["to"];
    total = json["total"];

    if (json["data"] != null) {
      data = (json["data"] as List)
          .map((e) => MerchantData.fromJson(e))
          .toList();
    }

    if (json["links"] != null) {
      links = (json["links"] as List)
          .map((e) => PageLink.fromJson(e))
          .toList();
    }
  }
}

class MerchantData {
  int? id;
  String? merchantId;
  String? businessName;
  String? ownerName;
  String? email;
  String? phone;
  MerchantLocation? location;
  String? image;

  MerchantData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    merchantId = json["merchant_id"];
    businessName = json["business_name"];
    ownerName = json["owner_name"];
    email = json["email"];
    phone = json["phone"];
    image = json["image"];

    location = json["location"] != null
        ? MerchantLocation.fromJson(json["location"])
        : null;
  }
}

class MerchantLocation {
  String? address;
  String? businessAddress;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? countryCode;

  MerchantLocation.fromJson(Map<String, dynamic> json) {
    address = json["address"];
    businessAddress = json["business_address"];
    city = json["city"];
    state = json["state"];
    zipCode = json["zip_code"];
    country = json["country"];
    countryCode = json["country_code"];
  }
}

class PageLink {
  String? url;
  String? label;
  bool? active;

  PageLink.fromJson(Map<String, dynamic> json) {
    url = json["url"];
    label = json["label"];
    active = json["active"];
  }
}
