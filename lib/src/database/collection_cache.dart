import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:teta_cms/teta_cms.dart';

class CachedCollectionRepository {
  const CachedCollectionRepository();

  static const String _boxKey = 'cache_tetacms_repository';
  static const String _selectListKey = 'get_collection_key';

  Future<Box<dynamic>> _getBox() => Hive.openBox<dynamic>(_boxKey);

  Future<void> resetCache() async {
    final box = await _getBox();
    await box.deleteFromDisk();
  }

  Future<TetaResponse<List<dynamic>?, TetaErrorResponse?>> getCollection(
    final String? from, {
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) async {
    try {
      final box = await _getBox();
      final json = jsonEncode(
        box.get('$_selectListKey$from$filters$page$limit$showDrafts'),
      );
      final map = jsonDecode(json) as Map<String, dynamic>?;
      if (map != null && map['list'] != null) {
        final createdAt = DateTime.tryParse('${map['created_at']}');
        if (createdAt == null) {
          return TetaResponse(
            data: null,
            error: TetaErrorResponse(
              message: 'created_at not found',
            ),
          );
        }
        const lifespan = Duration(milliseconds: 500);
        final expireDate = createdAt.add(lifespan);
        if (expireDate.isBefore(DateTime.now())) {
          return TetaResponse(
            data: null,
            error: TetaErrorResponse(
              message: 'Data cached not found, timer is expired',
            ),
          );
        }
        return TetaResponse(
          data: map['list'] as List<dynamic>?,
          error: null,
        );
      }
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          message: 'Data cached not found',
        ),
      );
    } catch (e) {
      TetaCMS.printError('TetaCMS - Error caching selectList, error: $e');
      return TetaResponse(
        data: null,
        error: TetaErrorResponse(
          message: 'Data cached not found, error: $e',
        ),
      );
    }
  }

  Future<void> cacheList(
    final List<dynamic>? list,
    final String? from, {
    final List<Filter> filters = const [],
    final int page = 0,
    final int limit = 20,
    final bool showDrafts = false,
  }) async {
    final box = await _getBox();
    await box.put(
      '$_selectListKey$from$filters$page$limit$showDrafts',
      <String, dynamic>{
        'list': list,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }
}
