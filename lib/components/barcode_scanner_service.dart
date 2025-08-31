import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:elite_stocktaking/models/stock_model.dart';
import 'package:elite_stocktaking/integrations/supabase_service.dart';

class BarcodeScannerService {
  static Future<String?> scanBarcode(BuildContext context) async {
    try {
      final result = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: BarcodeAppBar(
          appBarTitle: 'Scan Barcode',
          centerTitle: true,
          enableBackButton: true,
          backButtonIcon: const Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
        cameraFace: CameraFace.back,
      );

      if (result == null || result == '-1') {
        return null;
      }

      return result;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text('Error scanning barcode: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return null;
    }
  }

  static Future<StockModel?> handleScannedBarcode(String barcode) async {
    try {
      final existingStock = await SupabaseService().getStockBySku(barcode);
      return existingStock;
    } catch (e) {
      return null;
    }
  }

  static void showExistingProductDialog(
    BuildContext context,
    StockModel existingStock,
    String barcode,
    VoidCallback onAddQuantity,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                Icons.inventory_2,
                color: Colors.blue.shade600,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 12.0),
            const Expanded(child: Text('Product Found!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This barcode matches an existing product in your inventory:',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existingStock.name ?? 'Unknown Product',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text('SKU: ${existingStock.sku}'),
                  Text('Category: ${existingStock.category ?? 'No Category'}'),
                  Text('Current Quantity: ${existingStock.quantity ?? 0}'),
                  if (existingStock.location != null) Text('Location: ${existingStock.location}'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onAddQuantity();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Quantity'),
          ),
        ],
      ),
    );
  }

  static void showScannedBarcodeSnackBar(BuildContext context, String barcode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.qr_code_scanner, color: Colors.white),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                'Barcode scanned: $barcode\nPlease fill remaining details manually.',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showExistingProductSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12.0),
            const Expanded(
              child: Text(
                'Existing product loaded. Set quantity to add to current stock.',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
