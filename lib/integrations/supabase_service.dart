import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:elite_stocktaking/models/user_model.dart';
import 'package:elite_stocktaking/models/stock_model.dart';
import 'package:elite_stocktaking/models/stock_transaction_model.dart';

@NowaGenerated()
class SupabaseService {
  SupabaseService._();

  factory SupabaseService() {
    return _instance;
  }

  static final SupabaseService _instance = SupabaseService._();

  Future initialize() async {
    await Supabase.initialize(
      url: 'https://fjolpzqnnqidefguwlif.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqb2xwenFubnFpZGVmZ3V3bGlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMTE1NDUsImV4cCI6MjA3MTY4NzU0NX0.ld1fACnt9kCnCjX3zSDVgjMuyuEQAWEP17VDOD95oJA',
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<UserModel?> createUser(UserModel user) async {
    final response = await Supabase.instance.client.from('users').insert(user.toJson()).select().single();
    return UserModel.fromJson(response);
  }

  Future<List<UserModel>> getAllUsers() async {
    final response = await Supabase.instance.client.from('users').select().withConverter((rows) => rows.map(UserModel.fromJson).toList());
    return response;
  }

  Future<UserModel?> getUserById(int id) async {
    final response = await Supabase.instance.client.from('users').select().eq('id', id).single();
    return UserModel.fromJson(response);
  }

  Future<UserModel?> updateUser(UserModel user) async {
    if (user.id == null) {
      throw Exception('User ID is required for update');
    }
    final response = await Supabase.instance.client.from('users').update(user.toJson()).eq('id', user.id!).select().single();
    return UserModel.fromJson(response);
  }

  Future<bool> deleteUser(int id) async {
    final response = await Supabase.instance.client.from('users').delete().eq('id', id);
    return response != null;
  }

  Future<StockModel?> createStock(StockModel stock) async {
    final response = await Supabase.instance.client.from('stocks').insert(stock.toJson()).select().single();
    return StockModel.fromJson(response);
  }

  Future<List<StockModel>> getAllStocks() async {
    final response = await Supabase.instance.client.from('stocks').select().withConverter((rows) => rows.map(StockModel.fromJson).toList());
    return response;
  }

  Future<StockModel?> getStockById(String stockId) async {
    final response = await Supabase.instance.client.from('stocks').select().eq('stock_id', stockId).single();
    return StockModel.fromJson(response);
  }

  Future<StockModel?> updateStock(StockModel stock) async {
    if (stock.stockId == null) {
      throw Exception('Stock ID is required for update');
    }
    final response = await Supabase.instance.client.from('stocks').update(stock.toJson()).eq('stock_id', stock.stockId!).select().single();
    return StockModel.fromJson(response);
  }

  Future<bool> deleteStock(String stockId) async {
    final response = await Supabase.instance.client.from('stocks').delete().eq('stock_id', stockId);
    return response != null;
  }

  Future<UserModel?> getCurrentUserProfile() async {
    final currentAuthUser = Supabase.instance.client.auth.currentUser;
    if (currentAuthUser != null) {
      final users = await getAllUsers();
      return users.where((u) => u.email == currentAuthUser.email).firstOrNull!;
    }
    return null;
  }

  Future<StockModel?> getStockBySku(String sku) async {
    final response = await Supabase.instance.client.from('stocks').select().eq('sku', sku).limit(1);
    if (response.isNotEmpty) {
      return StockModel.fromJson(response.first);
    }
    return null;
  }

  Future<StockTransactionModel?> createStockTransaction(
    StockTransactionModel transaction,
  ) async {
    final response = await Supabase.instance.client.from('stock_transactions').insert(transaction.toJson()).select().single();
    return StockTransactionModel.fromJson(response);
  }

  Future<List<StockTransactionModel>> getStockTransactionsBySku(
    String sku,
  ) async {
    final response =
        await Supabase.instance.client.from('stock_transactions').select().eq('sku', sku).order('created_at', ascending: false);
    return response
        .map<StockTransactionModel>(
          (json) => StockTransactionModel.fromJson(json),
        )
        .toList();
  }

  Future<List<StockTransactionModel>> getStockTransactionsByStockId(
    String stockId,
  ) async {
    final response =
        await Supabase.instance.client.from('stock_transactions').select().eq('stock_id', stockId).order('created_at', ascending: false);
    return response
        .map<StockTransactionModel>(
          (json) => StockTransactionModel.fromJson(json),
        )
        .toList();
  }
}
