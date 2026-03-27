import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Static utility class for downloading and caching card artwork from Scryfall.
class ArtworkCache {
  /// User-Agent header for Scryfall API etiquette.
  static const String userAgent = 'DisasDiary/1.0';

  /// Get the artwork cache directory (ApplicationSupportDirectory/artwork_cache/).
  static Future<Directory> getCacheDirectory() async {
    if (kIsWeb) {
      throw UnsupportedError(
          'File system caching not available on web platform');
    }

    final appDir = await getApplicationSupportDirectory();
    final cacheDir = Directory('${appDir.path}/artwork_cache');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir;
  }

  /// Generate a deterministic filename from a URL using MD5 hash.
  static String _urlToFilename(String url) {
    final bytes = utf8.encode(url);
    final hash = md5.convert(bytes);
    return '$hash.jpg';
  }

  /// Get cached file for a URL (null if not cached).
  static Future<File?> getCachedFile(String url) async {
    if (kIsWeb) return null;

    final cacheDir = await getCacheDirectory();
    final filename = _urlToFilename(url);
    final file = File('${cacheDir.path}/$filename');

    if (await file.exists()) {
      return file;
    }

    return null;
  }

  /// Download image from URL, cache locally, return cached File.
  /// Returns null on failure. Skips download if already cached.
  static Future<File?> downloadAndCache(String url) async {
    if (kIsWeb) return null;

    // Check if already cached
    final existing = await getCachedFile(url);
    if (existing != null) return existing;

    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(url));
      request.headers['User-Agent'] = userAgent;

      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode != 200) {
        if (kDebugMode) {
          print(
              'Failed to download artwork: HTTP ${streamedResponse.statusCode}');
        }
        return null;
      }

      final bytes = await streamedResponse.stream.toBytes();

      final cacheDir = await getCacheDirectory();
      final filename = _urlToFilename(url);
      final file = File('${cacheDir.path}/$filename');

      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading artwork: $e');
      }
      return null;
    } finally {
      client.close();
    }
  }

  /// Get total cache size in bytes.
  static Future<int> getTotalCacheSize() async {
    if (kIsWeb) return 0;

    try {
      final cacheDir = await getCacheDirectory();

      if (!await cacheDir.exists()) return 0;

      int totalSize = 0;
      await for (var entity in cacheDir.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return totalSize;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating cache size: $e');
      }
      return 0;
    }
  }

  /// Clear all cached artwork.
  static Future<bool> clearAll() async {
    if (kIsWeb) return true;

    try {
      final cacheDir = await getCacheDirectory();

      if (!await cacheDir.exists()) return true;

      await for (var entity in cacheDir.list()) {
        if (entity is File) {
          await entity.delete();
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing artwork cache: $e');
      }
      return false;
    }
  }

  /// Format bytes as human-readable string (e.g. "2.5 MB").
  static String formatSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)} GB';
    }
  }
}
