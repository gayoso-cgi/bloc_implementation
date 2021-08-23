import 'package:bloc_implementation/src/helper/constants/api_constants.dart';

import 'entity/kategory.dart';
import 'entity/meta.dart';
import 'entity/tags.dart';
import 'icategory_content.dart';

class KategoryContentPDF implements ICategoryContent {
  int? id;
  int? kategoriId;

  @override
  String? jenisContent;
  String? isbn;
  String? youtubeUrl;
  String? youtubeVideoid;
  String? judul;
  String? author;
  String? deskripsiSingkat;
  String? body;
  String? cover;
  String? file;
  int? viewCount;
  int? likeCount;
  int? userId;
  String? createdAt;
  String? updatedAt;
  Kategori? kategori;
  Meta? meta;
  List<Tags>? tags;

  KategoryContentPDF(
      {this.id,
      this.kategoriId,
      this.jenisContent,
      this.isbn,
      this.youtubeUrl,
      this.youtubeVideoid,
      this.judul,
      this.author,
      this.deskripsiSingkat,
      this.body,
      this.cover,
      this.file,
      this.viewCount,
      this.likeCount,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.kategori,
      this.meta,
      this.tags});

  KategoryContentPDF.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kategoriId = json['kategori_id'];
    jenisContent = json['jenis_content'];
    isbn = json['isbn'];
    youtubeUrl = json['youtube_url'];
    youtubeVideoid = json['youtube_videoid'];
    judul = json['judul'];
    author = json['author'];
    deskripsiSingkat = json['deskripsi_singkat'];
    body = json['body'];
    cover =
        json['cover'] != null ? ApiEndpoint.BaseAssetUrl + json['cover'] : null;
    file =
        json['file'] != null ? ApiEndpoint.BaseAssetUrl + json['file'] : null;
    viewCount = json['view_count'];
    likeCount = json['like_count'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    kategori = json['kategori'] != null
        ? new Kategori.fromJson(json['kategori'])
        : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kategori_id'] = this.kategoriId;
    data['jenis_content'] = this.jenisContent;
    data['isbn'] = this.isbn;
    data['youtube_url'] = this.youtubeUrl;
    data['youtube_videoid'] = this.youtubeVideoid;
    data['judul'] = this.judul;
    data['author'] = this.author;
    data['deskripsi_singkat'] = this.deskripsiSingkat;
    data['body'] = this.body;
    data['cover'] = this.cover;
    data['file'] = this.file;
    data['view_count'] = this.viewCount;
    data['like_count'] = this.likeCount;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.kategori != null) {
      data['kategori'] = this.kategori!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
