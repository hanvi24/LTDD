import 'dart:async';

/// Giả lập đồng bộ dữ liệu giữa SQLite và Firestore
/// (sau này có thể thay bằng FirestoreService)
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  bool _isSyncing = false;

  Future<void> syncData() async {
    if (_isSyncing) return;
    _isSyncing = true;
    print('[SYNC] Bắt đầu đồng bộ dữ liệu...');
    await Future.delayed(const Duration(seconds: 2));
    print('[SYNC] Hoàn tất đồng bộ!');
    _isSyncing = false;
  }
}
