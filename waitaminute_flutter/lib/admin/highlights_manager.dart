import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waitaminute_serverpod_client/waitaminute_serverpod_client.dart';
import '../services/serverpod_service.dart';
import '../theme/app_theme.dart';

/// Admin CRUD manager for carousel highlights and portfolio case studies.
class HighlightsManager extends StatefulWidget {
  const HighlightsManager({super.key});

  @override
  State<HighlightsManager> createState() => _HighlightsManagerState();
}

class _HighlightsManagerState extends State<HighlightsManager> {
  final ServerpodService _service = ServerpodService.instance;
  List<ProjectHighlight> _highlights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHighlights();
  }

  Future<void> _loadHighlights() async {
    setState(() => _isLoading = true);
    final list = await _service.fetchAllHighlights();
    if (mounted) {
      setState(() {
        _highlights = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFeatured(ProjectHighlight project) async {
    final updated = project.copyWith(isFeatured: !project.isFeatured);
    await _service.saveHighlight(updated);
    _loadHighlights();
  }

  Future<void> _deleteHighlight(ProjectHighlight project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16161C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF26262B)),
        ),
        title: Text(
          'Delete Highlight?',
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to remove "${project.title}" from highlights?',
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

    if (confirmed == true && project.id != null) {
      await _service.deleteHighlight(project.id!);
      _loadHighlights();
    }
  }

  void _openEditor([ProjectHighlight? initial]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121216),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: Color(0xFF26262B)),
      ),
      builder: (ctx) => _HighlightEditorSheet(
        initial: initial,
        orderCount: _highlights.length,
        onSaved: () {
          Navigator.pop(ctx);
          _loadHighlights();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Action Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Text(
                'CAROUSEL HIGHLIGHTS (${_highlights.length})',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
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
                            'New Highlight',
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

        // List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.neonCyan))
              : _highlights.isEmpty
                  ? Center(
                      child: Text(
                        'No highlights found.',
                        style: GoogleFonts.inter(color: AppTheme.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _highlights.length,
                      itemBuilder: (context, index) {
                        final highlight = _highlights[index];
                        return _buildHighlightCard(highlight);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard(ProjectHighlight highlight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF14141A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight.isFeatured
              ? AppTheme.neonCyan.withValues(alpha: 0.6)
              : const Color(0xFF26262B),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail / Icon
            Container(
              width: 70,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF1E1E28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: highlight.coverImageUrl != null && highlight.coverImageUrl!.isNotEmpty
                    ? Image.network(
                        highlight.coverImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, color: AppTheme.textMuted),
                      )
                    : const Icon(Icons.auto_awesome_motion, color: AppTheme.neonCyan),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.neonViolet.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          highlight.client.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.neonViolet,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '#${highlight.order}',
                        style: GoogleFonts.spaceMono(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    highlight.title,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    highlight.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Actions
            Column(
              children: [
                Tooltip(
                  message: highlight.isFeatured ? 'Featured on Carousel' : 'Hidden from Carousel',
                  child: Switch(
                    value: highlight.isFeatured,
                    activeThumbColor: AppTheme.neonCyan,
                    onChanged: (_) => _toggleFeatured(highlight),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white70),
                      tooltip: 'Edit',
                      onPressed: () => _openEditor(highlight),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.neonMagenta),
                      tooltip: 'Delete',
                      onPressed: () => _deleteHighlight(highlight),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal editor sheet for creating or editing a highlight.
class _HighlightEditorSheet extends StatefulWidget {
  final ProjectHighlight? initial;
  final int orderCount;
  final VoidCallback onSaved;

  const _HighlightEditorSheet({
    required this.initial,
    required this.orderCount,
    required this.onSaved,
  });

  @override
  State<_HighlightEditorSheet> createState() => _HighlightEditorSheetState();
}

class _HighlightEditorSheetState extends State<_HighlightEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _clientController;
  late final TextEditingController _summaryController;
  late final TextEditingController _coverUrlController;
  late final TextEditingController _extUrlController;
  late int _order;
  late bool _isFeatured;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _titleController = TextEditingController(text: p?.title ?? '');
    _clientController = TextEditingController(text: p?.client ?? '');
    _summaryController = TextEditingController(text: p?.summary ?? '');
    _coverUrlController = TextEditingController(text: p?.coverImageUrl ?? '');
    _extUrlController = TextEditingController(text: p?.externalUrl ?? '');
    _order = p?.order ?? (widget.orderCount + 1);
    _isFeatured = p?.isFeatured ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _clientController.dispose();
    _summaryController.dispose();
    _coverUrlController.dispose();
    _extUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final highlight = ProjectHighlight(
      id: widget.initial?.id,
      title: _titleController.text.trim(),
      client: _clientController.text.trim(),
      summary: _summaryController.text.trim(),
      coverImageUrl: _coverUrlController.text.trim().isEmpty ? null : _coverUrlController.text.trim(),
      externalUrl: _extUrlController.text.trim().isEmpty ? null : _extUrlController.text.trim(),
      order: _order,
      isFeatured: _isFeatured,
    );

    await ServerpodService.instance.saveHighlight(highlight);
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
                    widget.initial == null ? 'NEW HIGHLIGHT' : 'EDIT HIGHLIGHT',
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

              TextFormField(
                controller: _titleController,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: _inputDeco('Project Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _clientController,
                      style: GoogleFonts.spaceMono(color: AppTheme.neonViolet, fontSize: 13),
                      decoration: _inputDeco('Client Tag (e.g. FINTECH)'),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: _order.toString(),
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 13),
                      decoration: _inputDeco('Order #'),
                      onChanged: (v) => _order = int.tryParse(v) ?? _order,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _summaryController,
                style: GoogleFonts.inter(color: Colors.white),
                maxLines: 2,
                decoration: _inputDeco('Summary'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _coverUrlController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: _inputDeco('Cover Image URL'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _extUrlController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: _inputDeco('External Link / Case Study URL'),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Text(
                    'Featured in Carousel',
                    style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 12),
                  ),
                  const Spacer(),
                  Switch(
                    value: _isFeatured,
                    activeThumbColor: AppTheme.neonCyan,
                    onChanged: (v) => setState(() => _isFeatured = v),
                  ),
                ],
              ),
              const SizedBox(height: 18),

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
                          'SAVE HIGHLIGHT',
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
