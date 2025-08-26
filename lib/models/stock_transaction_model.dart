import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class StockTransactionModel {
  const StockTransactionModel({
    this.transactionId,
    this.stockId,
    this.sku,
    this.name,
    this.quantityAdded,
    this.totalQuantityAfter,
    this.transactionType,
    this.notes,
    this.createdAt,
  });

  factory StockTransactionModel.fromJson(Map<String, dynamic> json) {
    return StockTransactionModel(
      transactionId: json['transaction_id'] as String?,
      stockId: json['stock_id'] as String?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      quantityAdded: json['quantity_added'] as int?,
      totalQuantityAfter: json['total_quantity_after'] as int?,
      transactionType: json['transaction_type'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  final String? transactionId;

  final String? stockId;

  final String? sku;

  final String? name;

  final int? quantityAdded;

  final int? totalQuantityAfter;

  final String? transactionType;

  final String? notes;

  final String? createdAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'transaction_id': transactionId,
      'stock_id': stockId,
      'sku': sku,
      'name': name,
      'quantity_added': quantityAdded,
      'total_quantity_after': totalQuantityAfter,
      'transaction_type': transactionType,
      'notes': notes,
    };
    if (createdAt != null) {
      json['created_at'] = createdAt;
    }
    return json;
  }
}
