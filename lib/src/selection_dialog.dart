import 'package:flutter/material.dart';

import 'country_code.dart';
import 'country_localizations.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final WidgetBuilder? emptySearchBuilder;
  final bool showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final Widget? closeIcon;
  final Widget? title;

  /// Separator widget for list items.
  final Widget? separator;

  /// Background color of SelectionDialog
  final Color? backgroundColor;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.boxDecoration,
    this.showFlag = false,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.backgroundColor,
    this.barrierColor,
    this.hideSearch = false,
    this.closeIcon,
    this.title,
    this.separator,
  })  : searchDecoration = searchDecoration.prefixIcon == null
            ? searchDecoration.copyWith(prefixIcon: const Icon(Icons.search))
            : searchDecoration,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  late List<CountryCode> filteredElements;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: widget.size?.width ?? MediaQuery.of(context).size.width,
      height: widget.size?.height ?? MediaQuery.of(context).size.height * 0.85,
      decoration: widget.boxDecoration ??
          BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                color: widget.barrierColor ?? Colors.grey.withOpacity(1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.title ?? const SizedBox.shrink(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.closeIcon ?? const Icon(Icons.close),
                ),
              ),
            ],
          ),
          if (!widget.hideSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextField(
                style: widget.searchStyle,
                decoration: widget.searchDecoration,
                onChanged: _filterElements,
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 12),
              children: [
                widget.favoriteElements.isEmpty
                    ? const DecoratedBox(decoration: BoxDecoration())
                    : Column(
                        children: [
                          ListView.separated(
                            itemCount: widget.favoriteElements.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return widget.separator ??
                                  const SizedBox(height: 16);
                            },
                            itemBuilder: (context, index) {
                              final item = widget.favoriteElements[index];
                              return SimpleDialogOption(
                                onPressed: () => _selectItem(item),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: _buildOption(item),
                              );
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                if (filteredElements.isEmpty)
                  _buildEmptySearchWidget(context)
                else
                  ListView.separated(
                    itemCount: filteredElements.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return widget.separator ?? const SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      final item = filteredElements[index];
                      return SimpleDialogOption(
                        onPressed: () => _selectItem(item),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildOption(item),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(CountryCode e) {
    return ListTile(
      leading: widget.showFlag
          ? Container(
              decoration: widget.flagDecoration,
              clipBehavior:
                  widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
              child: Image.asset(
                e.flagUri!,
                package: 'country_code_picker',
                width: widget.flagWidth,
              ),
            )
          : null,
      title: Text(
        e.toCountryStringOnly(),
        overflow: TextOverflow.fade,
        style: widget.textStyle,
      ),
      trailing: Text(
        widget.showCountryOnly! ? '' : e.toString(),
        style: widget.textStyle,
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder!(context);
    }

    return Center(
      child: Text(CountryLocalizations.of(context)?.translate('no_country') ??
          'No country found'),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code!.contains(s) ||
              e.dialCode!.contains(s) ||
              e.name!.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
