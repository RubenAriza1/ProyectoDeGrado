import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/post_repository.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onRefresh;

  const PostCard({
    super.key,
    required this.post,
    required this.onRefresh,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final _repository = PostRepository();
  late bool _hasLiked;
  late int _likesCount;
  bool _isLoadingLike = false;

  @override
  void initState() {
    super.initState();
    _hasLiked = widget.post['hasLiked'] ?? false;
    _likesCount = widget.post['likesCount'] ?? 0;
  }

  Future<void> _toggleLike() async {
    if (_isLoadingLike) return;
    setState(() => _isLoadingLike = true);

    try {
      final res = await _repository.toggleLike(widget.post['_id']);
      if (mounted) {
        setState(() {
          _hasLiked = res['hasLiked'];
          _likesCount = res['likesCount'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLike = false);
    }
  }

  Future<void> _handleMenuAction(String value) async {
    final postId = widget.post['_id'];

    try {
      if (value == 'favorite') {
        await _repository.toggleFavorite(postId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favoritos actualizado.')),
        );
      } else if (value == 'block') {
        await _repository.blockPost(postId);
        widget.onRefresh(); // Refresh feed to hide it
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación bloqueada y oculta del feed.')),
        );
      } else if (value == 'report') {
        await _repository.reportPost(postId, 'OFENSIVO', 'Reportado vía app.');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación denunciada.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final autor = widget.post['autor'] ?? {};
    final String authorName = autor['nombre'] ?? 'Usuario Desconocido';
    final String authorRole = autor['rol'] ?? 'usuario';
    final int commentsCount = widget.post['comentariosCount'] ?? 0;

    final String tipoPost = widget.post['tipoPost'] ?? 'GENERAL';
    final int? vacantes = widget.post['vacantes'];
    final num? precio = widget.post['precio'];
    final List<dynamic> evidencias = widget.post['evidencias'] ?? [];

    final createdAt = DateTime.tryParse(widget.post['createdAt'] ?? '');
    final String timeStr = createdAt != null 
        ? '${createdAt.day}/${createdAt.month}/${createdAt.year}' 
        : 'Reciente';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    final autorId = autor['_id'];
                    if (autorId != null) {
                      context.push('/profile/$autorId');
                    }
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white12,
                    child: Icon(Icons.music_note, color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('$authorRole • $timeStr', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                  onSelected: _handleMenuAction,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'favorite',
                      child: Text('Agregar a Favoritos'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'block',
                      child: Text('Bloquear publicación'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'report',
                      child: Text('Denunciar publicación', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            
            // Etiqueta de Tipo de Post
            if (tipoPost != 'GENERAL')
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tipoPost == 'BUSCANDO_PERSONAL' ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: tipoPost == 'BUSCANDO_PERSONAL' ? Colors.blue : Colors.amber,
                  )
                ),
                child: Text(
                  tipoPost == 'BUSCANDO_PERSONAL' ? 'Buscando Personal' : 'Busca Oportunidad',
                  style: TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.bold,
                    color: tipoPost == 'BUSCANDO_PERSONAL' ? Colors.blue : Colors.amber,
                  ),
                ),
              ),

            Text(widget.post['contenido'] ?? '', style: theme.textTheme.bodyMedium),
            
            // Vacantes y Precio
            if (vacantes != null || precio != null)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (vacantes != null) ...[
                      const Icon(Icons.people, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('Vacantes: $vacantes', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                    ],
                    if (precio != null) ...[
                      const Icon(Icons.monetization_on, size: 16, color: Colors.greenAccent),
                      const SizedBox(width: 4),
                      Text('Precio: \$$precio', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                    ],
                  ],
                ),
              ),

             // Evidencias (Fotos)
             if (evidencias.isNotEmpty)
               Container(
                 margin: const EdgeInsets.only(top: 12),
                 height: 120,
                 child: ListView.separated(
                   scrollDirection: Axis.horizontal,
                   itemCount: evidencias.length,
                   separatorBuilder: (_, __) => const SizedBox(width: 8),
                   itemBuilder: (context, index) {
                     return ClipRRect(
                       borderRadius: BorderRadius.circular(8),
                       child: Image.network(
                         evidencias[index],
                         width: 120,
                         height: 120,
                         fit: BoxFit.cover,
                         errorBuilder: (_, __, ___) => Container(
                           width: 120,
                           height: 120,
                           color: Colors.grey.shade900,
                           child: const Icon(Icons.broken_image, color: Colors.white54),
                         ),
                       ),
                     );
                   },
                 ),
               ),

            const SizedBox(height: 18),
            Row(
              children: [
                InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(
                          _hasLiked ? Icons.favorite : Icons.favorite_border, 
                          size: 20, 
                          color: _hasLiked ? Colors.redAccent : Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text('$_likesCount', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                InkWell(
                  onTap: () {
                     context.push('/post/${widget.post['_id']}');
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.comment, size: 20, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text('$commentsCount', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                     context.push('/post/${widget.post['_id']}');
                  }, 
                  child: const Text('Ver detalles'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
