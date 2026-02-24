import 'package:flutter/material.dart';
import 'package:hikaronsfa/source/env/env.dart';

class CustomDropdown extends FormField<String> {
  CustomDropdown({
    super.key,
    required List<dynamic> items,
    required ValueChanged<String> onChanged,
    String hint = 'Select',
    double height = 50,
    String? initialValue,
    FormFieldValidator<String>? validator,
  }) : super(
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return _CustomDropdownBody(
              items: items,
              hint: hint,
              height: height,
              value: state.value,
              errorText: state.errorText,
              onChanged: (value) {
                state.didChange(value);
                onChanged(value);
              },
            );
          },
        );
}

class _CustomDropdownBody extends StatefulWidget {
  final List<dynamic> items;
  final String hint;
  final double height;
  final String? value;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _CustomDropdownBody({
    required this.items,
    required this.hint,
    required this.height,
    required this.onChanged,
    this.value,
    this.errorText,
  });

  @override
  State<_CustomDropdownBody> createState() => _CustomDropdownBodyState();
}

class _CustomDropdownBodyState extends State<_CustomDropdownBody> {
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _CustomDropdownBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _selectedValue) {
      _selectedValue = widget.value;
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 6),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('No data found')),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected =
                            item.toString() == _selectedValue;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedValue = item.toString();
                            });
                            widget.onChanged(item.toString());
                            _closeDropdown();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            color: isSelected
                                ? Colors.grey.shade100
                                : Colors.transparent,
                            child: Text(
                              item.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade800,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError ? merah2 : Colors.grey.shade400,
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedValue ?? widget.hint,
                      style: TextStyle(
                        color: _selectedValue == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              widget.errorText!,
              style:
                  const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
