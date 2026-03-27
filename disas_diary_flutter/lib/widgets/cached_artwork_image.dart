import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/artwork_cache.dart';

/// A reusable widget that displays a cached network image.
///
/// On native platforms, checks the local cache first and falls back to
/// downloading and caching the image. On web, uses [Image.network] directly.
class CachedArtworkImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedArtworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<CachedArtworkImage> createState() => _CachedArtworkImageState();
}

class _CachedArtworkImageState extends State<CachedArtworkImage> {
  File? _cachedFile;
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadImage();
    }
  }

  @override
  void didUpdateWidget(CachedArtworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _cachedFile = null;
      _loading = true;
      _hasError = false;
      if (!kIsWeb) {
        _loadImage();
      }
    }
  }

  Future<void> _loadImage() async {
    // Check cache first
    var file = await ArtworkCache.getCachedFile(widget.imageUrl);
    if (file != null) {
      if (mounted) {
        setState(() {
          _cachedFile = file;
          _loading = false;
        });
      }
      return;
    }

    // Download and cache
    file = await ArtworkCache.downloadAndCache(widget.imageUrl);
    if (mounted) {
      setState(() {
        _cachedFile = file;
        _loading = false;
        _hasError = file == null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // On web, skip caching and use Image.network directly
    if (kIsWeb) {
      return Image.network(
        widget.imageUrl,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return widget.placeholder ??
              const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ??
              const Center(child: Icon(Icons.broken_image, size: 48));
        },
      );
    }

    if (_loading) {
      return widget.placeholder ??
          const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _cachedFile == null) {
      return widget.errorWidget ??
          const Center(child: Icon(Icons.broken_image, size: 48));
    }

    return Image.file(
      _cachedFile!,
      fit: widget.fit,
    );
  }
}
