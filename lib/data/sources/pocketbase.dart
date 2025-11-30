import 'dart:async';

import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseService extends GetxService {
  late final PocketBase pb;

  @override
  void onInit() {
    super.onInit();

    // Use your public PocketBase URL
    pb = PocketBase(
      'http://pocketbase-z000koccok0o800wcsos0k44.103.197.190.23.sslip.io',
    );

    print('🚀 PocketBaseService initialized with URL: ${pb.baseUrl}');
  }

  Future<bool> testConnection() async {
    try {
      print('🔌 Testing connection to: ${pb.baseUrl}');

      // Use a public endpoint that doesn't require auth
      final response = await pb
          .send('/api/health', method: 'GET')
          .timeout(const Duration(seconds: 10));

      print('✅ PocketBase connection successful!');
      print('🏥 Health check passed - Server is ready');
      return true;
    } on ClientException catch (e) {
      if (e.statusCode == 401) {
        print('⚠️  Connection successful but requires auth (expected)');
        print('💡 This is normal - the server is protected');
        return true; // Still consider it connected
      } else {
        print('❌ Connection failed: ${e.statusCode} - ${e.originalError}');
        return false;
      }
    } on TimeoutException {
      print('❌ Connection timeout');
      return false;
    } catch (e) {
      print('❌ Unexpected error: $e');
      return false;
    }
  }
}
