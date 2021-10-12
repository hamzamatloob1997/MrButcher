// To parse this JSON data, do
//
//     final butcher = butcherFromJson(jsonString);

import 'dart:convert';

Butcher butcherFromJson(String str) => Butcher.fromJson(json.decode(str));

String butcherToJson(Butcher data) => json.encode(data.toJson());

class Butcher {
    Butcher({
        this.email,
        this.bLatitude,
        this.address,
        this.city,
        this.henButcheringRate,
        this.userPhoto,
        this.name,
        this.overAllRating,
        this.goatLambButcheringRate,
        this.cattleRate,
        this.phoneNo,
        this.cnic,
        this.bLongitude,
    });

    String email;
    double bLatitude;
    String address;
    String city;
    String henButcheringRate;
    String userPhoto;
    String name;
    String overAllRating;
    String goatLambButcheringRate;
    String cattleRate;
    String phoneNo;
    String cnic;
    double bLongitude;

    factory Butcher.fromJson(Map<String, dynamic> json) => Butcher(
        email: json["Email"],
        bLatitude: json["BLatitude"].toDouble(),
        address: json["Address"],
        city: json["city"],
        henButcheringRate: json["HenButcheringRate"],
        userPhoto: json["User Photo"],
        name: json["Name"],
        overAllRating: json["overAllRating"],
        goatLambButcheringRate: json["GoatLambButcheringRate"],
        cattleRate: json["CattleRate"],
        phoneNo: json["PhoneNo"],
        cnic: json["CNIC"],
        bLongitude: json["BLongitude"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "Email": email,
        "BLatitude": bLatitude,
        "Address": address,
        "city": city,
        "HenButcheringRate": henButcheringRate,
        "User Photo": userPhoto,
        "Name": name,
        "overAllRating": overAllRating,
        "GoatLambButcheringRate": goatLambButcheringRate,
        "CattleRate": cattleRate,
        "PhoneNo": phoneNo,
        "CNIC": cnic,
        "BLongitude": bLongitude,
    };
}
