import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class StockModel {
  const StockModel({
    this.stockId,
    this.name,
    this.sku,
    this.description,
    this.category,
    this.quantity,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      stockId: json['stock_id'] as String?,
      name: json['name'] as String?,
      sku: json['sku'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      quantity: json['quantity'] as int?,
      location: json['location'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  final String? stockId;

  final String? name;

  final String? sku;

  final String? description;

  final String? category;

  final int? quantity;

  final String? location;

  final String? createdAt;

  final String? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'stock_id': stockId,
      'name': name,
      'sku': sku,
      'description': description,
      'category': category,
      'quantity': quantity,
      'location': location,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
