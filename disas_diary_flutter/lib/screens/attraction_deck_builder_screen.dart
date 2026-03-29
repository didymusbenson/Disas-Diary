import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/attraction.dart';
import '../models/attraction_deck.dart';
import '../providers/attractions_state.dart';
import '../widgets/attraction_card.dart';
import '../widgets/mana_icons.dart';

/// Screen for creating or editing an attraction deck
class AttractionDeckBuilderScreen extends StatefulWidget {
  /// Pass an existing deck to edit; null to create new
  final AttractionDeck? deck;

  const AttractionDeckBuilderScreen({super.key, this.deck});

  @override
  State<AttractionDeckBuilderScreen> createState() =>
      _AttractionDeckBuilderScreenState();
}

class _AttractionDeckBuilderScreenState
    extends State<AttractionDeckBuilderScreen> {
  late final TextEditingController _nameController;

  /// Maps attraction name -> selected variant (by collector number key)
  /// Stores the selected Attraction object for each chosen name
  final Map<String, Attraction> _selections = {};

  /// Tracks which attraction name is currently expanded for variant picking
  String? _expandedName;

  bool get _isEditing => widget.deck != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.deck?.name ?? '',
    );
    _prepopulateSelections();
  }

  void _prepopulateSelections() {
    if (widget.deck == null) return;

    final state = context.read<AttractionsState>();
    final byName = state.attractionsByName;

    for (final entry in widget.deck!.entries) {
      // Find matching Attraction object from the catalog
      final variants = byName[entry.attractionName];
      if (variants != null) {
        final match = variants.cast<Attraction?>().firstWhere(
              (a) =>
                  _listsEqual(a!.attractionLights, entry.attractionLights),
              orElse: () => null,
            );
        if (match != null) {
          _selections[entry.attractionName] = match;
        }
      }
    }
  }

  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int get _uniqueNamesSelected => _selections.length;

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final entries = _selections.values.map((attraction) {
      return AttractionDeckEntry(
        attractionName: attraction.name,
        attractionLights: attraction.attractionLights,
        securityStamp: attraction.securityStamp,
        commanderLegal: attraction.commanderLegal,
        oracleText: attraction.oracleText,
      );
    }).toList();

    final state = context.read<AttractionsState>();

    try {
      if (_isEditing) {
        await state.updateDeck(widget.deck!.id, name: name, entries: entries);
      } else {
        await state.createDeck(name, entries);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<AttractionsState>();

    // Apply commander legal filter to grouped attractions
    final filteredAttractions = state.filteredAttractions;
    final groupedFiltered = Attraction.groupByName(filteredAttractions);
    final sortedNames = groupedFiltered.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit: ${widget.deck!.name}' : 'New Deck',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _uniqueNamesSelected >= 10 &&
                    _nameController.text.trim().isNotEmpty
                ? _save
                : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: _uniqueNamesSelected >= 10 &&
                        _nameController.text.trim().isNotEmpty
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onPrimary.withValues(alpha: 0.38),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Deck name field
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Deck name',
                  hintText: 'Enter a name for your deck',
                  isDense: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            // Commander legal filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(
                    'Commander legal only',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Switch(
                    value: state.commanderLegalFilter,
                    onChanged: (value) =>
                        state.setCommanderLegalFilter(value),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Attraction list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 60),
                itemCount: sortedNames.length,
                itemBuilder: (context, index) {
                  final name = sortedNames[index];
                  final variants = groupedFiltered[name]!;
                  final isSelected = _selections.containsKey(name);
                  final isExpanded = _expandedName == name;

                  return _AttractionListItem(
                    name: name,
                    variants: variants,
                    isSelected: isSelected,
                    isExpanded: isExpanded,
                    selectedVariant:
                        isSelected ? _selections[name] : null,
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          // Collapse
                          _expandedName = null;
                        } else {
                          // Expand
                          _expandedName = name;
                        }
                      });
                    },
                    onSelectVariant: (attraction) {
                      setState(() {
                        _selections[name] = attraction;
                        _expandedName = null;
                      });
                    },
                    onDeselect: () {
                      setState(() {
                        _selections.remove(name);
                        _expandedName = null;
                      });
                    },
                  );
                },
              ),
            ),
            // Bottom count bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _uniqueNamesSelected >= 10
                        ? '$_uniqueNamesSelected attractions selected'
                        : '$_uniqueNamesSelected attractions selected (10 minimum)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _uniqueNamesSelected >= 10
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual attraction name entry in the deck builder list
class _AttractionListItem extends StatelessWidget {
  final String name;
  final List<Attraction> variants;
  final bool isSelected;
  final bool isExpanded;
  final Attraction? selectedVariant;
  final VoidCallback onTap;
  final ValueChanged<Attraction> onSelectVariant;
  final VoidCallback onDeselect;

  const _AttractionListItem({
    required this.name,
    required this.variants,
    required this.isSelected,
    required this.isExpanded,
    required this.selectedVariant,
    required this.onTap,
    required this.onSelectVariant,
    required this.onDeselect,
  });

  bool get _hasAcorn =>
      variants.any((v) => v.securityStamp == 'acorn');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main row
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Checkbox indicator
                GestureDetector(
                  onTap: isSelected ? onDeselect : null,
                  child: Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 20,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                // Name and oracle text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (_hasAcorn)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(
                                ManaIcons.acorn,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        variants.first.oracleText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow: isExpanded ? TextOverflow.clip : TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Selected variant lights (when collapsed and selected)
                if (isSelected && !isExpanded && selectedVariant != null)
                  AttractionLightsRow(
                    lights: selectedVariant!.attractionLights,
                  ),
                // Expand indicator
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        // Expanded variant list
        if (isExpanded) ...[
          // Variant rows
          for (final variant in variants)
            _VariantRow(
              variant: variant,
              isSelected: selectedVariant != null &&
                  _listsEqual(selectedVariant!.attractionLights,
                      variant.attractionLights),
              onTap: () => onSelectVariant(variant),
            ),
          // Deselect option if already selected
          if (isSelected)
            InkWell(
              onTap: onDeselect,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.close,
                      size: 16,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Remove',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
        ],
        const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// A single variant row showing the lit-up numbers for selection
class _VariantRow extends StatelessWidget {
  final Attraction variant;
  final bool isSelected;
  final VoidCallback onTap;

  const _VariantRow({
    required this.variant,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            AttractionLightsRow(lights: variant.attractionLights),
          ],
        ),
      ),
    );
  }
}
