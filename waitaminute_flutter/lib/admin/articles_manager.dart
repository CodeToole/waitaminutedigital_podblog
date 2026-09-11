import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import '../services/serverpod_service.dart';
import '../theme/app_theme.dart';
import '../widgets/badge_tag.dart';

/// Admin CRUD manager for editorial articles and devlogs.
class ArticlesManager extends StatefulWidget {
  const ArticlesManager({super.key});

  @override
  State<ArticlesManager> createState() => _ArticlesManagerState();
}

class _ArticlesManagerState extends State<ArticlesManager> {
  final ServerpodService _service = ServerpodService.instance;
  List<Article> _articles = [];
  bool _isLoading = true;
  String _filterBadge = 'ALL';

  final List<String> _badgeOptions = [
    'ARCHITECTURE',
    'POST-MORTEM',
    'SHIPPED',
    'DEVLOG',
    'NEWS',
  ];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    final list = await _service.fetchArticlesAdmin(includeDrafts: true);
    if (mounted) {
      setState(() {
        _articles = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePublish(Article article) async {
    final updated = article.copyWith(
      isPublished: !article.isPublished,
      publishedAt: !article.isPublished ? DateTime.now() : article.publishedAt,
    );
    await _service.saveArticle(updated);
    _loadArticles();
  }

  Future<void> _deleteArticle(Article article) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16161C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF26262B)),
        ),
        title: Text(
          'Delete Article?',
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to permanently delete "${article.title}"?',
          style: GoogleFonts.inter(color: const Color(0xFFCBD5E1), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.spaceMono(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.neonMagenta,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: GoogleFonts.spaceMono(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true && article.id != null) {
      await _service.deleteArticle(article.id!);
      _loadArticles();
    }
  }

  void _openEditor([Article? initial]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121216),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: Color(0xFF26262B)),
      ),
      builder: (ctx) => _ArticleEditorSheet(
        initial: initial,
        badgeOptions: _badgeOptions,
        onSaved: () {
          Navigator.pop(ctx);
          _loadArticles();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var displayed = _articles;
    if (_filterBadge != 'ALL') {
      displayed = displayed.where((a) => a.badge.toUpperCase() == _filterBadge).toList();
    }

    return Column(
      children: [
        // Action Bar: Filter & Add New Article
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Text(
                'DISPATCHES (${_articles.length})',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              // New Article Button
              Container(
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppTheme.buttonGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _openEditor(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'New Article',
                            style: GoogleFonts.spaceMono(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Badge Filter Chips
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: ['ALL', ..._badgeOptions].map((badge) {
              final isSel = _filterBadge == badge;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    badge,
                    style: GoogleFonts.spaceMono(
                      color: isSel ? Colors.black : const Color(0xFF94A3B8),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppTheme.neonCyan,
                  backgroundColor: const Color(0xFF16161D),
                  side: BorderSide(
                    color: isSel ? AppTheme.neonCyan : const Color(0xFF26262B),
                  ),
                  onSelected: (_) => setState(() => _filterBadge = badge),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Articles List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.neonCyan))
              : displayed.isEmpty
                  ? Center(
                      child: Text(
                        'No articles found.',
                        style: GoogleFonts.inter(color: AppTheme.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: displayed.length,
                      itemBuilder: (context, index) {
                        final article = displayed[index];
                        return _buildArticleItem(article);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildArticleItem(Article article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14141A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF26262B)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BadgeTag(label: article.badge, isSmall: true),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: article.isPublished
                            ? AppTheme.neonGreen.withValues(alpha: 0.15)
                            : AppTheme.neonAmber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.isPublished ? 'PUBLISHED' : 'DRAFT',
                        style: GoogleFonts.spaceMono(
                          color: article.isPublished ? AppTheme.neonGreen : AppTheme.neonAmber,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.slug,
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.neonCyan.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  article.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Actions
          Column(
            children: [
              // Publish Switch
              Tooltip(
                message: article.isPublished ? 'Set as Draft' : 'Publish Article',
                child: Switch(
                  value: article.isPublished,
                  activeThumbColor: AppTheme.neonCyan,
                  onChanged: (_) => _togglePublish(article),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white70),
                    tooltip: 'Edit',
                    onPressed: () => _openEditor(article),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.neonMagenta),
                    tooltip: 'Delete',
                    onPressed: () => _deleteArticle(article),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Modal editor sheet for creating or editing an article.
class _ArticleEditorSheet extends StatefulWidget {
  final Article? initial;
  final List<String> badgeOptions;
  final VoidCallback onSaved;

  const _ArticleEditorSheet({
    required this.initial,
    required this.badgeOptions,
    required this.onSaved,
  });

  @override
  State<_ArticleEditorSheet> createState() => _ArticleEditorSheetState();
}

class _ArticleEditorSheetState extends State<_ArticleEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _slugController;
  late final TextEditingController _summaryController;
  late final TextEditingController _coverUrlController;
  late final TextEditingController _bodyController;
  late String _badge;
  late bool _isPublished;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initial;
    _titleController = TextEditingController(text: a?.title ?? '');
    _slugController = TextEditingController(text: a?.slug ?? '');
    _summaryController = TextEditingController(text: a?.summary ?? '');
    _coverUrlController = TextEditingController(text: a?.coverImageUrl ?? '');
    _bodyController = TextEditingController(text: a?.body ?? '');
    _badge = a?.badge ?? widget.badgeOptions.first;
    _isPublished = a?.isPublished ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _summaryController.dispose();
    _coverUrlController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _generateSlug(String title) {
    if (_slugController.text.isEmpty || widget.initial == null) {
      final slug = title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
      _slugController.text = slug;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final article = Article(
      id: widget.initial?.id,
      title: _titleController.text.trim(),
      slug: _slugController.text.trim(),
      summary: _summaryController.text.trim(),
      body: _bodyController.text.trim(),
      badge: _badge,
      coverImageUrl: _coverUrlController.text.trim().isEmpty ? null : _coverUrlController.text.trim(),
      isPublished: _isPublished,
      publishedAt: widget.initial?.publishedAt ?? (_isPublished ? DateTime.now() : null),
    );

    await ServerpodService.instance.saveArticle(article);
    setState(() => _isSaving = false);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initial == null ? 'NEW DISPATCH' : 'EDIT DISPATCH',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: _inputDeco('Article Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onChanged: _generateSlug,
              ),
              const SizedBox(height: 12),

              // Slug
              TextFormField(
                controller: _slugController,
                style: GoogleFonts.spaceMono(color: AppTheme.neonCyan, fontSize: 13),
                decoration: _inputDeco('URL Slug (e.g. why-we-tested-serverpod)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Category Badge & Published Toggle Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _badge,
                      dropdownColor: const Color(0xFF1A1A22),
                      style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 12),
                      decoration: _inputDeco('Category'),
                      items: widget.badgeOptions
                          .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _badge = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Text(
                        'Published',
                        style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 12),
                      ),
                      Switch(
                        value: _isPublished,
                        activeThumbColor: AppTheme.neonCyan,
                        onChanged: (v) => setState(() => _isPublished = v),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Summary
              TextFormField(
                controller: _summaryController,
                style: GoogleFonts.inter(color: Colors.white),
                maxLines: 2,
                decoration: _inputDeco('Summary Snippet'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Cover Image URL
              TextFormField(
                controller: _coverUrlController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: _inputDeco('Cover Image URL (Unsplash or CDN)'),
              ),
              const SizedBox(height: 12),

              // Markdown Body Field
              TextFormField(
                controller: _bodyController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                maxLines: 8,
                decoration: _inputDeco('Full Article Content (Markdown)'),
                validator: (v) => v == null || v.isEmpty ? 'Content required' : null,
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonCyan,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : Text(
                          'SAVE ARTICLE',
                          style: GoogleFonts.spaceMono(fontWeight: FontWeight.w800, letterSpacing: 1.1),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF16161D),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF26262B)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.neonCyan),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
