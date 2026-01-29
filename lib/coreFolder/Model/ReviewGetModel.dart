import 'dart:convert';

ReviewGetModel reviewGetModelFromJson(String str) =>
    ReviewGetModel.fromJson(json.decode(str));

String reviewGetModelToJson(ReviewGetModel data) => json.encode(data.toJson());

class ReviewGetModel {
  bool? status;
  Collage? collage;
  List<Review> reviews;

  ReviewGetModel({
    this.status,
    this.collage,
    required this.reviews,
  });

  factory ReviewGetModel.fromJson(Map<String, dynamic> json) => ReviewGetModel(
        status: json["status"],
        collage:
            json["collage"] == null ? null : Collage.fromJson(json["collage"]),
        reviews: (json["reviews"] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map((e) => Review.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "collage": collage?.toJson(),
        "reviews": reviews.map((x) => x.toJson()).toList(),
      };
}

class Collage {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? email;
  String? website;
  String? image;
  String? city;
  String? pincode;
  String? type;
  double? rating;
  int? totalReviews;
  Map<String, int> distribution;

  Collage({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.email,
    this.website,
    this.image,
    this.city,
    this.pincode,
    this.type,
    this.rating,
    this.totalReviews,
    required this.distribution,
  });

  factory Collage.fromJson(Map<String, dynamic> json) => Collage(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        email: json["email"],
        website: json["website"],
        image: json["image"],
        city: json["city"],
        pincode: json["pincode"],
        type: json["type"],
        rating: json["rating"]?.toDouble(),
        totalReviews: json["total_reviews"],
        distribution: (json["distribution"] as Map?)
                ?.map((k, v) => MapEntry(k.toString(), v as int)) ??
            {},
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "phone": phone,
        "email": email,
        "website": website,
        "image": image,
        "city": city,
        "pincode": pincode,
        "type": type,
        "rating": rating,
        "total_reviews": totalReviews,
        "distribution": distribution,
      };
}

class Review {
  int? userId;
  int? rating;
  String? description;
  String? title;
  dynamic name;
  NameWiseRating? nameWiseRating;
  List<dynamic> skills;
  DateTime? createdAt;
  String? fullName;

  Review({
    this.userId,
    this.rating,
    this.description,
    this.title,
    this.name,
    this.nameWiseRating,
    required this.skills,
    this.createdAt,
    this.fullName,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["user_id"],
        rating: json["rating"],
        description: json["description"],
        title: json["title"],
        name: json["name"],
        fullName: json['full_name'],
        nameWiseRating: json["name_wise_rating"] == null
            ? null
            : NameWiseRating.fromJson(
                json["name_wise_rating"] as Map<String, dynamic>),
        skills: (json["skills"] as List?) ?? [],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "rating": rating,
        "description": description,
        "title": title,
        "name": name,
        "name_wise_rating": nameWiseRating?.toJson(),
        "skills": skills,
        "created_at": createdAt?.toIso8601String(),
        "full_name": fullName,
      };
}

class NameWiseRating {
  String? description;
  String? averageRating;
  int? totalReviews;
  List<Reviewer> reviewers;

  NameWiseRating({
    this.description,
    this.averageRating,
    this.totalReviews,
    required this.reviewers,
  });

  factory NameWiseRating.fromJson(Map<String, dynamic> json) => NameWiseRating(
        description: json["description"],
        averageRating: json["average_rating"],
        totalReviews: json["total_reviews"],
        reviewers: (json["reviewers"] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map((e) => Reviewer.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "average_rating": averageRating,
        "total_reviews": totalReviews,
        "reviewers": reviewers.map((x) => x.toJson()).toList(),
      };
}

class Reviewer {
  String? reviewerName;
  int? reviewerCount;

  Reviewer({
    this.reviewerName,
    this.reviewerCount,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
        reviewerName: json["reviewer_name"],
        reviewerCount: json["reviewer_count"],
      );

  Map<String, dynamic> toJson() => {
        "reviewer_name": reviewerName,
        "reviewer_count": reviewerCount,
      };
}
