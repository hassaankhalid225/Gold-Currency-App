import 'package:flutter/material.dart';

// SearchableDropdown: Autocomplete-style dropdown that shows an inline menu.
class SearchableDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final String hint;
  final ValueChanged<T?> onChanged;
  final Widget Function(T)? iconBuilder;

  const SearchableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.hint = 'Select',
    this.iconBuilder,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    if (widget.value != null) {
      _controller.text = widget.labelBuilder(widget.value!);
    }
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _openDropdown();
    } else {
      // Small delay to allow tapping an item before menu disappears
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _closeDropdown();
      });
    }
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _controller.text = widget.labelBuilder(widget.value!);
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _openDropdown() {
    _removeOverlay();
    _filteredItems = widget.items;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _removeOverlay();
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            shadowColor: Colors.black26,
            color: Theme.of(context).cardColor,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    dense: true,
                    leading: widget.iconBuilder != null ? widget.iconBuilder!(item) : null,
                    title: Text(widget.labelBuilder(item)),
                    onTap: () {
                      widget.onChanged(item);
                      _controller.text = widget.labelBuilder(item);
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items.where((item) {
        return widget.labelBuilder(item).toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onTap: () {
          if (!_isOpen) _openDropdown();
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: widget.value != null && widget.iconBuilder != null 
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: widget.iconBuilder!(widget.value!),
                )
              : null,
          suffixIcon: Icon(
            _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: Theme.of(context).primaryColor,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        onChanged: _filterItems,
      ),
    );
  }
}

// SearchableSelectionSheet: Bottom sheet version for Home screen (+) button
class SearchableSelectionSheet<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;
  final Widget Function(T)? iconBuilder;
  final String title;

  const SearchableSelectionSheet({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.iconBuilder,
    required this.title,
  });

  @override
  State<SearchableSelectionSheet<T>> createState() => _SearchableSelectionSheetState<T>();
}

class _SearchableSelectionSheetState<T> extends State<SearchableSelectionSheet<T>> {
  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
     final filteredItems = widget.items.where((item) {
       return widget.labelBuilder(item).toLowerCase().contains(_searchQuery.toLowerCase());
     }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              minHeight: 0,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  leading: widget.iconBuilder != null ? widget.iconBuilder!(item) : null,
                  title: Text(widget.labelBuilder(item)),
                  onTap: () {
                    widget.onChanged(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
