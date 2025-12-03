import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:senandika/data/models/mood_log_model.dart';
import 'package:senandika/data/sources/pocketbase.dart';
// import 'package:senandika/data/repositories/auth_repository.dart'; // Diperlukan di constructor

// Interface (Tetap sama)
abstract class IJournalRepository {
  Future<List<MoodLogModel>> getMonthlyMoodLogs(
    DateTime startOfMonth,
    DateTime endOfMonth,
    String userId,
  );
  Future<MoodLogModel?> getMoodLogByDate(DateTime date, String userId);
  Future<void> createMoodLog(
    int score,
    String text,
    List<String> tags,
    String userId,
  );
  Future<MoodLogModel?> getMoodLogById(String logId);
}

class JournalRepository implements IJournalRepository {
  // Asumsi PocketBaseService di-inject di constructor
  final PocketBaseService _pbService;

  // Anda dapat menyuntikkan IAuthRepository di sini jika Anda mau
  JournalRepository(this._pbService /*, this._authRepository*/);

  PocketBase get _pb => _pbService.pb;

  static const String _collectionName = 'mood_logs';

  // Helper untuk mendapatkan timestamp ISO8601 UTC yang digunakan untuk filter range (Exclusive End)
  String _toUtcIso8601(DateTime dt) {
    // Menggunakan .toUtc() dan menghilangkan milidetik
    return dt.toUtc().toIso8601String().split('.')[0] + 'Z';
  }

  // Helper untuk mendapatkan batas waktu yang mencakup seluruh hari LOKAL
  Map<String, String> _getUtcRangeForLocalDay(DateTime date) {
    // 1. Dapatkan awal hari LOKAL (00:00:00)
    final startOfDayLocal = DateTime(date.year, date.month, date.day);
    // 2. Dapatkan awal hari berikutnya LOKAL (00:00:00)
    final startOfNextDayLocal = startOfDayLocal.add(const Duration(days: 1));

    // 3. Konversi kedua titik waktu tersebut ke UTC string (untuk filter)
    final String startUtc = _toUtcIso8601(startOfDayLocal);
    final String endUtc = _toUtcIso8601(
      startOfNextDayLocal,
    ); // Eksklusif (timestamp < endUtc)

    return {'start': startUtc, 'end': endUtc};
  }

  // 1. Memuat Log Bulanan
  @override
  Future<List<MoodLogModel>> getMonthlyMoodLogs(
    DateTime startOfMonth,
    DateTime
    endOfMonth, // endOfMonth ini diabaikan dan diganti dengan perhitungan yang lebih aman
    String userId,
  ) async {
    return _pbService
        .handleApiCall<List<MoodLogModel>>(() async {
          // 1. Dapatkan awal bulan LOKAL berikutnya
          final startOfNextMonth = DateTime(
            startOfMonth.year,
            startOfMonth.month + 1,
            1,
          );

          // 2. Konversi Awal Bulan LOKAL saat ini dan Awal Bulan LOKAL berikutnya ke UTC string
          final String start = _toUtcIso8601(startOfMonth);
          final String end = _toUtcIso8601(
            startOfNextMonth,
          ); // Ini adalah batas eksklusif!

          final String filter =
              // Ganti `<=` dengan `<` dan batas akhirnya adalah awal bulan berikutnya.
              'user = \'$userId\' && timestamp >= \'$start\' && timestamp < \'$end\''; // ⬅️ PERUBAHAN UTAMA

          final records = await _pb
              .collection(_collectionName)
              .getList(
                page: 1,
                perPage: 500,
                filter: filter,
                sort: '-timestamp',
              );

          print('object records $records');

          return records.items
              .map((record) => MoodLogModel.fromRecord(record))
              .toList();
        })
        .catchError((error) {
          if (error is ClientException) {
            throw Exception(
              'Gagal memuat riwayat jurnal. Status: ${error.statusCode}',
            );
          }
          throw error;
        });
  }

  // 2. Memuat Log Berdasarkan Tanggal Spesifik (Mencegah Duplikasi)
  @override
  Future<MoodLogModel?> getMoodLogByDate(DateTime date, String userId) async {
    return _pbService
        .handleApiCall<MoodLogModel?>(() async {
          // ⬅️ MENGGUNAKAN LOGIKA RENTANG LOKAL->UTC
          final range = _getUtcRangeForLocalDay(date);
          final String startUtc = range['start']!;
          final String endUtc = range['end']!; // Eksklusif (hari berikutnya)

          // Filter: Mencari entri dalam rentang 24 jam LOKAL yang dikonversi ke UTC
          final String filter =
              'user = \'$userId\' && timestamp >= \'$startUtc\' && timestamp < \'$endUtc\'';

          final records = await _pb
              .collection(_collectionName)
              .getList(page: 1, perPage: 1, filter: filter);

          if (records.items.isNotEmpty) {
            return MoodLogModel.fromRecord(records.items.first);
          }
          return null;
        })
        .catchError((error) {
          if (error is ClientException) {
            print('Error fetching log by date: ${error.statusCode}');
            return null;
          }
          throw error;
        });
  }

  // 3. CREATE MOOD LOG
  @override
  Future<void> createMoodLog(
    int score,
    String text,
    List<String> tags,
    String userId,
  ) async {
    // Pengecekan Log Hari Ini (Mencegah Duplikasi LOKAL)
    // Gunakan tanggal saat ini LOKAL (DateTime.now())
    final existingLog = await getMoodLogByDate(DateTime.now(), userId);

    if (existingLog != null) {
      throw Exception(
        'Anda sudah mencatat jurnal untuk hari ini. Silakan edit entri yang sudah ada.',
      );
    }

    return _pbService
        .handleApiCall<void>(() async {
          final body = <String, dynamic>{
            'user': userId,
            'score': score,
            'text': text,
            'tags': tags,
            // ⚠️ PENTING: Jangan kirim timestamp. Biarkan PocketBase menggunakan timestamp created/updated.
            // Jika Anda mengirim timestamp, kirim DateTime.now().toUtc()
            'timestamp': _toUtcIso8601(
              DateTime.now(),
            ), // Opsional: kirim jika field timestamp diperlukan
          };

          await _pb.collection(_collectionName).create(body: body);
        })
        .catchError((error) {
          if (error is ClientException) {
            print('PocketBase Create Log Error: ${error.response}');
            if (error.statusCode == 400) {
              throw Exception('Gagal menyimpan jurnal. Data tidak valid.');
            }
            throw Exception(
              'Gagal menyimpan jurnal. Status: ${error.statusCode}',
            );
          }
          throw error;
        });
  }

  @override
  Future<MoodLogModel?> getMoodLogById(String logId) async {
    return _pbService
        .handleApiCall<MoodLogModel?>(() async {
          final record = await _pb.collection(_collectionName).getOne(logId);

          return MoodLogModel.fromRecord(record);
        })
        .catchError((error) {
          if (error is ClientException) {
            if (error.statusCode == 404) return null; // Log not found
            throw Exception(
              'Gagal memuat detail jurnal. Status: ${error.statusCode}',
            );
          }
          throw error;
        });
  }
}
