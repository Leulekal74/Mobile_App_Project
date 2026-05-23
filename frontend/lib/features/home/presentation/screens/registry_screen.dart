import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_nav_bar.dart';
import '../../../../core/widgets/site_footer.dart';
import '../../../archive/application/archive_providers.dart';
import '../../../archive/domain/entities/artisan.dart';
import '../../../archive/domain/entities/dye.dart';
import '../../../archive/domain/entities/pattern.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/domain/entities/auth_session.dart';

class RegistryScreen extends ConsumerStatefulWidget {
  const RegistryScreen({super.key});

  @override
  ConsumerState<RegistryScreen> createState() => _RegistryScreenState();
}

class _RegistryScreenState extends ConsumerState<RegistryScreen> {
  int _selectedIndex = 0;
  bool _hasPrimedRemoteData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasPrimedRemoteData) return;
    _hasPrimedRemoteData = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(patternsControllerProvider.notifier).refresh();
      ref.read(dyesControllerProvider.notifier).refresh();
      ref.read(artisansControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final session = ref.watch(currentSessionProvider);
    final canWrite = ref.watch(canWriteProvider);

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Log in to access the archive registry.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: canWrite
          ? FloatingActionButton.small(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              onPressed: () => _showCreateDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PrimaryNavBar(currentRoute: '/registry'),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFDF9),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.stroke),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'National Textile Archive',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Browse Ethiopia\'s documentation of motif drafts, dye knowledge, and artisan records.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Core Registry Pillars',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.brandYellowDeep,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            IconButton(
                              onPressed: _refreshCurrentTab,
                              icon: const Icon(Icons.refresh_rounded),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 12,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Wrap(
                              spacing: 6,
                              children: [
                                _SegmentChip(
                                  label: 'Pattern',
                                  selected: _selectedIndex == 0,
                                  onTap: () => setState(() => _selectedIndex = 0),
                                ),
                                _SegmentChip(
                                  label: 'Dye',
                                  selected: _selectedIndex == 1,
                                  onTap: () => setState(() => _selectedIndex = 1),
                                ),
                                _SegmentChip(
                                  label: 'Artisan',
                                  selected: _selectedIndex == 2,
                                  onTap: () => setState(() => _selectedIndex = 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: KeyedSubtree(
                            key: ValueKey(_selectedIndex),
                            child: _buildCurrentTab(session, canWrite),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SiteFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTab(AuthSession session, bool canWrite) {
    switch (_selectedIndex) {
      case 1:
        return _DyesView(session: session, canWrite: canWrite);
      case 2:
        return _ArtisansView(session: session, canWrite: canWrite);
      default:
        return _PatternsView(session: session, canWrite: canWrite);
    }
  }

  void _refreshCurrentTab() {
    switch (_selectedIndex) {
      case 1:
        ref.read(dyesControllerProvider.notifier).refresh();
        break;
      case 2:
        ref.read(artisansControllerProvider.notifier).refresh();
        break;
      default:
        ref.read(patternsControllerProvider.notifier).refresh();
    }
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    switch (_selectedIndex) {
      case 1:
        final dyePayload = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (_) => const _DyeDialog(),
        );
        if (dyePayload != null) {
          await ref.read(dyesControllerProvider.notifier).save(dyePayload);
        }
        break;
      case 2:
        final artisanPayload = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (_) => const _ArtisanDialog(),
        );
        if (artisanPayload != null) {
          await ref.read(artisansControllerProvider.notifier).save(artisanPayload);
        }
        break;
      default:
        final patternPayload = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (_) => const _PatternDialog(),
        );
        if (patternPayload != null) {
          await ref.read(patternsControllerProvider.notifier).save(patternPayload);
        }
    }
  }
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1E88E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _PatternsView extends ConsumerWidget {
  const _PatternsView({
    required this.session,
    required this.canWrite,
  });

  final AuthSession session;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(patternsControllerProvider);

    return state.when(
      data: (patterns) => _RegistryGrid(
        children: patterns
            .map(
              (record) => _PatternFigmaCard(
                record: record,
                canWrite: canWrite,
                session: session,
              ),
            )
            .toList(),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text(error.toString())),
      ),
    );
  }
}

class _DyesView extends ConsumerWidget {
  const _DyesView({
    required this.session,
    required this.canWrite,
  });

  final AuthSession session;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dyesControllerProvider);

    return state.when(
      data: (dyes) => _RegistryGrid(
        children: dyes
            .map(
              (record) => _DyeFigmaCard(
                record: record,
                canWrite: canWrite,
                session: session,
              ),
            )
            .toList(),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text(error.toString())),
      ),
    );
  }
}

class _ArtisansView extends ConsumerWidget {
  const _ArtisansView({
    required this.session,
    required this.canWrite,
  });

  final AuthSession session;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(artisansControllerProvider);

    return state.when(
      data: (artisans) => _RegistryGrid(
        children: artisans
            .map(
              (record) => _ArtisanFigmaCard(
                record: record,
                canWrite: canWrite,
                session: session,
              ),
            )
            .toList(),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text(error.toString())),
      ),
    );
  }
}

class _RegistryGrid extends StatelessWidget {
  const _RegistryGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text('No records available yet.')),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSingleColumn = constraints.maxWidth < 680;
        if (isSingleColumn) {
          return Column(
            children: children
                .expand((card) => [card, const SizedBox(height: 14)])
                .toList()
              ..removeLast(),
          );
        }

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: children
              .map(
                (child) => SizedBox(
                  width: (constraints.maxWidth - 14) / 2,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _PatternFigmaCard extends ConsumerWidget {
  const _PatternFigmaCard({
    required this.record,
    required this.canWrite,
    required this.session,
  });

  final PatternRecord record;
  final bool canWrite;
  final AuthSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = canWrite &&
        (session.user.role.name == 'admin' || session.user.id == record.ownerId);

    return _FigmaCardShell(
      imagePath: 'assets/images/image.png',
      title: record.name,
      meta: '${record.region} • ${record.technique}',
      body:
          'Thread count: ${record.threadCount}\n${record.description.isEmpty ? 'Traditional border documentation entry.' : record.description}',
      footer: 'View Pattern Entry',
      canEdit: canEdit,
      onView: () => _showRecordDetails(
        context,
        title: record.name,
        meta: '${record.region} • ${record.technique}',
        body:
            'Thread count: ${record.threadCount}\n\n${record.description.isEmpty ? 'Traditional border documentation entry.' : record.description}',
      ),
      onEdit: () async {
        final payload = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (_) => _PatternDialog(record: record),
        );
        if (payload != null) {
          await ref
              .read(patternsControllerProvider.notifier)
              .save(payload, id: record.id);
        }
      },
      onDelete: () => _confirmDelete(
        context,
        onConfirm: () => ref.read(patternsControllerProvider.notifier).remove(record.id),
      ),
    );
  }
}

class _DyeFigmaCard extends ConsumerWidget {
  const _DyeFigmaCard({
    required this.record,
    required this.canWrite,
    required this.session,
  });

  final DyeRecord record;
  final bool canWrite;
  final AuthSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = canWrite &&
        (session.user.role.name == 'admin' || session.user.id == record.ownerId);

    return _FigmaCardShell(
      imagePath: 'assets/images/image.png',
      title: record.name,
      meta: '${record.region} • ${record.sourceMaterial}',
      body:
          'Formula: ${record.formula}\n${record.notes.isEmpty ? 'Natural dye archive record with preparation notes.' : record.notes}',
      footer: 'View Dye Formula',
      canEdit: canEdit,
      onView: () => _showRecordDetails(
        context,
        title: record.name,
        meta: '${record.region} • ${record.sourceMaterial}',
        body:
            'Formula: ${record.formula}\n\n${record.notes.isEmpty ? 'Natural dye archive record with preparation notes.' : record.notes}',
      ),
      onEdit: () async {
        final payload = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (_) => _DyeDialog(record: record),
        );
        if (payload != null) {
          await ref.read(dyesControllerProvider.notifier).save(payload, id: record.id);
        }
      },
      onDelete: () => _confirmDelete(
        context,
        onConfirm: () => ref.read(dyesControllerProvider.notifier).remove(record.id),
      ),
    );
  }
}

class _ArtisanFigmaCard extends ConsumerWidget {
  const _ArtisanFigmaCard({
    required this.record,
    required this.canWrite,
    required this.session,
  });

  final ArtisanRecord record;
  final bool canWrite;
  final AuthSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = canWrite &&
        (session.user.role.name == 'admin' || session.user.id == record.ownerId);

    return _FigmaCardShell(
      imagePath: 'assets/images/image.png',
      title: record.name,
      meta: '${record.region} • ${record.specialty}',
      body:
          'Experience: ${record.experienceYears} years\n${record.bio.isEmpty ? 'Artisan profile documenting workshop practice and regional expertise.' : record.bio}',
      footer: 'View Artisan Profile',
      canEdit: canEdit,
      onView: () => _showRecordDetails(
        context,
        title: record.name,
        meta: '${record.region} • ${record.specialty}',
        body:
            'Experience: ${record.experienceYears} years\n\n${record.bio.isEmpty ? 'Artisan profile documenting workshop practice and regional expertise.' : record.bio}',
      ),
      onEdit: () async {
        final payload = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (_) => _ArtisanDialog(record: record),
        );
        if (payload != null) {
          await ref
              .read(artisansControllerProvider.notifier)
              .save(payload, id: record.id);
        }
      },
      onDelete: () => _confirmDelete(
        context,
        onConfirm: () =>
            ref.read(artisansControllerProvider.notifier).remove(record.id),
      ),
    );
  }
}

class _FigmaCardShell extends StatelessWidget {
  const _FigmaCardShell({
    required this.imagePath,
    required this.title,
    required this.meta,
    required this.body,
    required this.footer,
    required this.canEdit,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final String imagePath;
  final String title;
  final String meta;
  final String body;
  final String footer;
  final bool canEdit;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9D0BC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 144,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (canEdit) ...[
                      InkWell(
                        onTap: onEdit,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.edit_outlined, size: 16),
                        ),
                      ),
                      InkWell(
                        onTap: onDelete,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.close, size: 16),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF595959),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF494949),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: InkWell(
                    onTap: onView,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brandYellow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        footer,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternDialog extends StatefulWidget {
  const _PatternDialog({this.record});

  final PatternRecord? record;

  @override
  State<_PatternDialog> createState() => _PatternDialogState();
}

class _PatternDialogState extends State<_PatternDialog> {
  late final TextEditingController nameController;
  late final TextEditingController regionController;
  late final TextEditingController techniqueController;
  late final TextEditingController descriptionController;
  late final TextEditingController threadCountController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.record?.name ?? '');
    regionController = TextEditingController(text: widget.record?.region ?? '');
    techniqueController = TextEditingController(text: widget.record?.technique ?? '');
    descriptionController =
        TextEditingController(text: widget.record?.description ?? '');
    threadCountController =
        TextEditingController(text: widget.record?.threadCount ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return _FormDialog(
      title: widget.record == null ? 'Add Pattern' : 'Edit Pattern',
      fields: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: regionController,
          decoration: const InputDecoration(labelText: 'Region'),
        ),
        TextField(
          controller: techniqueController,
          decoration: const InputDecoration(labelText: 'Technique'),
        ),
        TextField(
          controller: threadCountController,
          decoration: const InputDecoration(labelText: 'Thread count'),
        ),
        TextField(
          controller: descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
      ],
      onSubmit: () => Navigator.of(context).pop({
        'name': nameController.text.trim(),
        'region': regionController.text.trim(),
        'technique': techniqueController.text.trim(),
        'threadCount': threadCountController.text.trim(),
        'description': descriptionController.text.trim(),
      }),
    );
  }
}

class _DyeDialog extends StatefulWidget {
  const _DyeDialog({this.record});

  final DyeRecord? record;

  @override
  State<_DyeDialog> createState() => _DyeDialogState();
}

class _DyeDialogState extends State<_DyeDialog> {
  late final TextEditingController nameController;
  late final TextEditingController sourceController;
  late final TextEditingController regionController;
  late final TextEditingController formulaController;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.record?.name ?? '');
    sourceController =
        TextEditingController(text: widget.record?.sourceMaterial ?? '');
    regionController = TextEditingController(text: widget.record?.region ?? '');
    formulaController = TextEditingController(text: widget.record?.formula ?? '');
    notesController = TextEditingController(text: widget.record?.notes ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return _FormDialog(
      title: widget.record == null ? 'Add Dye Formula' : 'Edit Dye Formula',
      fields: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: sourceController,
          decoration: const InputDecoration(labelText: 'Source material'),
        ),
        TextField(
          controller: regionController,
          decoration: const InputDecoration(labelText: 'Region'),
        ),
        TextField(
          controller: formulaController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Formula'),
        ),
        TextField(
          controller: notesController,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Notes'),
        ),
      ],
      onSubmit: () => Navigator.of(context).pop({
        'name': nameController.text.trim(),
        'sourceMaterial': sourceController.text.trim(),
        'region': regionController.text.trim(),
        'formula': formulaController.text.trim(),
        'notes': notesController.text.trim(),
      }),
    );
  }
}

class _ArtisanDialog extends StatefulWidget {
  const _ArtisanDialog({this.record});

  final ArtisanRecord? record;

  @override
  State<_ArtisanDialog> createState() => _ArtisanDialogState();
}

class _ArtisanDialogState extends State<_ArtisanDialog> {
  late final TextEditingController nameController;
  late final TextEditingController specialtyController;
  late final TextEditingController regionController;
  late final TextEditingController yearsController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.record?.name ?? '');
    specialtyController =
        TextEditingController(text: widget.record?.specialty ?? '');
    regionController = TextEditingController(text: widget.record?.region ?? '');
    yearsController =
        TextEditingController(text: '${widget.record?.experienceYears ?? 0}');
    bioController = TextEditingController(text: widget.record?.bio ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return _FormDialog(
      title: widget.record == null ? 'Add Artisan' : 'Edit Artisan',
      fields: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: specialtyController,
          decoration: const InputDecoration(labelText: 'Specialty'),
        ),
        TextField(
          controller: regionController,
          decoration: const InputDecoration(labelText: 'Region'),
        ),
        TextField(
          controller: yearsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Experience years'),
        ),
        TextField(
          controller: bioController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Bio'),
        ),
      ],
      onSubmit: () => Navigator.of(context).pop({
        'name': nameController.text.trim(),
        'specialty': specialtyController.text.trim(),
        'region': regionController.text.trim(),
        'experienceYears': int.tryParse(yearsController.text.trim()) ?? 0,
        'bio': bioController.text.trim(),
      }),
    );
  }
}

class _FormDialog extends StatelessWidget {
  const _FormDialog({
    required this.title,
    required this.fields,
    required this.onSubmit,
  });

  final String title;
  final List<Widget> fields;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: fields
                .expand((field) => [field, const SizedBox(height: 12)])
                .toList()
              ..removeLast(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context, {
  required Future<void> Function() onConfirm,
}) async {
  final approved = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete record?'),
      content: const Text('This action removes the selected entry from the registry.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (approved == true) {
    await onConfirm();
  }
}

void _showRecordDetails(
  BuildContext context, {
  required String title,
  required String meta,
  required String body,
}) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
