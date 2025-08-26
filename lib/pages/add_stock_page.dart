import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:elite_stocktaking/models/stock_model.dart';
import 'package:elite_stocktaking/integrations/supabase_service.dart';
import 'package:elite_stocktaking/models/stock_transaction_model.dart';

@NowaGenerated()
class AddStockPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const AddStockPage({super.key});

  @override
  State<AddStockPage> createState() {
    return _AddStockPageState();
  }
}

@NowaGenerated()
class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _skuController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _categoryController = TextEditingController();

  final _quantityController = TextEditingController();

  final _locationController = TextEditingController();

  bool _isLoading = false;

  String? _errorMessage;

  String? _successMessage;

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Food & Beverages',
    'Office Supplies',
    'Medical Supplies',
    'Tools & Equipment',
    'Books & Media',
    'Sports & Recreation',
    'Other',
  ];

  String? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String _generateStockId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'STK-$random';
  }

  Future<void> _showCategoryConflictDialog(
    StockModel existingStock,
    String newCategory,
    int quantityToAdd,
  ) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade600),
            const SizedBox(width: 12.0),
            const Text('Category Conflict'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'An item with the same SKU "${existingStock.sku}" and name "${existingStock.name}" already exists but with a different category.',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Please choose which category to use:',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Existing Category:',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    existingStock.category ?? 'No Category',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Category:',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    newCategory,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'existing'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keep Existing'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'new'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Use New'),
          ),
        ],
      ),
    );
    if (result != null && result != 'cancel') {
      final categoryToUse = result == 'existing' ? existingStock.category : newCategory;
      await _updateExistingStock(existingStock, quantityToAdd, categoryToUse);
    }
  }

  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'TXN-$random';
  }

  Future<void> _updateExistingStock(
    StockModel existingStock,
    int quantityToAdd,
    String? categoryToUse,
  ) async {
    try {
      final newQuantity = (existingStock.quantity ?? 0) + quantityToAdd;
      final updatedStock = StockModel(
        stockId: existingStock.stockId,
        name: existingStock.name,
        sku: existingStock.sku,
        description: existingStock.description,
        category: categoryToUse,
        quantity: newQuantity,
        location: existingStock.location,
        createdAt: existingStock.createdAt,
        updatedAt: existingStock.updatedAt,
      );
      final result = await SupabaseService().updateStock(updatedStock);
      if (result != null) {
        final transaction = StockTransactionModel(
          transactionId: _generateTransactionId(),
          stockId: existingStock.stockId,
          sku: existingStock.sku,
          name: existingStock.name,
          quantityAdded: quantityToAdd,
          totalQuantityAfter: newQuantity,
          transactionType: 'add',
          notes: quantityToAdd > 0 ? 'Added $quantityToAdd items via stock addition' : 'Stock updated - no quantity change',
        );
        await SupabaseService().createStockTransaction(transaction);
        if (mounted) {
          setState(() {
            _successMessage = quantityToAdd > 0
                ? 'Added $quantityToAdd items to "${existingStock.name}". New quantity: $newQuantity. Category: ${categoryToUse ?? 'No Category'}'
                : 'Updated "${existingStock.name}" category to: ${categoryToUse ?? 'No Category'}';
          });
          _formKey.currentState?.reset();
          _nameController.clear();
          _skuController.clear();
          _descriptionController.clear();
          _categoryController.clear();
          _quantityController.clear();
          _locationController.clear();
          _selectedCategory = null;
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _successMessage = null;
              });
            }
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to update existing stock item. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to update stock item. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Add Stock Item',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.add_box,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Stock Item',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'All fields marked with * are required',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Stock Name *',
                    hintText: 'Enter the stock item name',
                    prefixIcon: Icon(
                      Icons.inventory_2,
                      color: Colors.grey.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the stock name';
                    }
                    if (value.trim().length < 2) {
                      return 'Stock name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _skuController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'SKU *',
                    hintText: 'Enter unique stock keeping unit code',
                    helperStyle: TextStyle(
                      color: Colors.orange.shade600,
                      fontSize: 12.0,
                    ),
                    prefixIcon: Icon(
                      Icons.qr_code,
                      color: Colors.grey.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the SKU';
                    }
                    if (value.trim().length < 3) {
                      return 'SKU must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category *',
                        hintText: 'Select a category',
                        prefixIcon: Icon(
                          Icons.category,
                          color: Colors.grey.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.blue.shade600,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          if (value != 'Other') {
                            _categoryController.clear();
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                    if (_selectedCategory == 'Other') ...[
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _categoryController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Custom Category *',
                          hintText: 'Enter custom category name',
                          prefixIcon: Icon(
                            Icons.edit,
                            color: Colors.grey.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.blue.shade600,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.red.shade400,
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (_selectedCategory == 'Other' && (value == null || value.isEmpty)) {
                            return 'Please enter a custom category name';
                          }
                          if (_selectedCategory == 'Other' && value != null && value.trim().length < 2) {
                            return 'Category name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Quantity *',
                    hintText: 'Enter initial stock quantity',
                    helperStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 12.0,
                    ),
                    prefixIcon: Icon(
                      Icons.numbers,
                      color: Colors.grey.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null) {
                      return 'Please enter a valid number';
                    }
                    if (quantity < 0) {
                      return 'Quantity cannot be negative';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _locationController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Location (Optional)',
                    hintText: 'Enter storage location',
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.grey.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter item description or notes',
                    prefixIcon: Icon(
                      Icons.description,
                      color: Colors.grey.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onFieldSubmitted: (_) => _addStock(),
                ),
                const SizedBox(height: 24.0),
                if (_successMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            _successMessage!,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade600),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_errorMessage != null || _successMessage != null) const SizedBox(height: 16.0),
                SizedBox(
                  height: 56.0,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addStock,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 2.0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 20.0),
                              SizedBox(width: 8.0),
                              Text(
                                'Add Stock Item',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 48.0,
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            _formKey.currentState?.reset();
                            _nameController.clear();
                            _skuController.clear();
                            _descriptionController.clear();
                            _categoryController.clear();
                            _quantityController.clear();
                            _locationController.clear();
                            setState(() {
                              _selectedCategory = null;
                              _errorMessage = null;
                              _successMessage = null;
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Clear Form',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addStock() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      final enteredQuantity = int.tryParse(_quantityController.text.trim()) ?? 0;
      final newCategory = _selectedCategory == 'Other' ? _categoryController.text.trim() : _selectedCategory;
      final existingStock = await SupabaseService().getStockBySku(
        _skuController.text.trim(),
      );
      if (existingStock != null) {
        final existingName = existingStock.name!.toLowerCase().trim();
        final newName = _nameController.text.toLowerCase().trim();
        if (existingName == newName) {
          final existingCategory = existingStock.category!.toLowerCase().trim();
          final newCategoryLower = newCategory!.toLowerCase().trim();
          if (existingCategory != newCategoryLower) {
            setState(() {
              _isLoading = false;
            });
            await _showCategoryConflictDialog(
              existingStock,
              newCategory,
              enteredQuantity,
            );
            return;
          } else {
            await _updateExistingStock(
              existingStock,
              enteredQuantity,
              existingStock.category,
            );
            return;
          }
        } else {
          setState(() {
            _errorMessage = 'SKU "${existingStock.sku}" already exists with different name "${existingStock.name}". SKUs must be unique.';
            _isLoading = false;
          });
          return;
        }
      }
      final stockId = _generateStockId();
      final stockModel = StockModel(
        stockId: stockId,
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        category: newCategory,
        quantity: enteredQuantity,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      );
      final createdStock = await SupabaseService().createStock(stockModel);
      if (mounted) {
        if (createdStock != null) {
          final transaction = StockTransactionModel(
            transactionId: _generateTransactionId(),
            stockId: stockId,
            sku: createdStock.sku,
            name: createdStock.name,
            quantityAdded: enteredQuantity,
            totalQuantityAfter: enteredQuantity,
            transactionType: 'add',
            notes: 'Initial stock creation with $enteredQuantity items',
          );
          await SupabaseService().createStockTransaction(transaction);
          setState(() {
            _successMessage = 'New stock item created successfully!';
          });
          _formKey.currentState?.reset();
          _nameController.clear();
          _skuController.clear();
          _descriptionController.clear();
          _categoryController.clear();
          _quantityController.clear();
          _locationController.clear();
          _selectedCategory = null;
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _successMessage = null;
              });
            }
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to create stock item. Please try again.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              e.toString().contains('duplicate') ? 'Stock ID already exists. Please try again.' : 'An error occurred. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
