import 'dart:convert';

ProductoModel productFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {

  String id;
  String titulo;
  double valor;
  bool disponible;
  String fotoUrl;

  ProductoModel({
    this.id,
    this.titulo = "",
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
    id         : json["id"],
    titulo     : json["titulo"],
    valor      : json["valor"].toDouble(),
    disponible : json["disponible"],
    fotoUrl    : json["fotoUrl"],
  );

  Map<String, dynamic> toJson() => {
    //"id"         : id,
    "titulo"     : titulo,
    "valor"      : valor,
    "disponible" : disponible,
    "fotoUrl"    : fotoUrl,
  };
}
