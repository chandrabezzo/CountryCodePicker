import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

import 'country_code.dart';
import 'country_localizations.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final bool? isFocused;
  final TextStyle? textStyle;
  final TextStyle headerTextStyle;
  final BoxDecoration? boxDecoration;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final bool hideCloseIcon;
  final Icon? closeIcon;
  final bool hideHeaderText;
  final String? headerText;
  final EdgeInsets topBarPadding;
  final MainAxisAlignment headerAlignment;

  /// Background color of SelectionDialog
  final Color? backgroundColor;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  final EdgeInsetsGeometry dialogItemPadding;

  final EdgeInsetsGeometry searchPadding;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.showCountryOnly,
    required this.hideHeaderText,
    this.emptySearchBuilder,
    required this.headerAlignment,
    required this.headerTextStyle,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.isFocused,
    this.textStyle,
    required this.topBarPadding,
    this.headerText,
    this.boxDecoration,
    this.showFlag,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.backgroundColor,
    this.barrierColor,
    this.hideSearch = false,
    this.hideCloseIcon = false,
    this.closeIcon,
    this.dialogItemPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.searchPadding = const EdgeInsets.symmetric(horizontal: 24),
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: widget.size?.width ?? MediaQuery.of(context).size.width,
          height:
              widget.size?.height ?? MediaQuery.of(context).size.height * 0.85,
          decoration: widget.boxDecoration ??
              BoxDecoration(
                color: widget.backgroundColor ?? Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: widget.barrierColor ?? Colors.grey.withAlpha(255),
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
              Padding(
                padding: !widget.hideHeaderText
                    ? widget.topBarPadding
                    : EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: widget.headerAlignment,
                  children: [
                    !widget.hideHeaderText && widget.headerText != null
                        ? Text(
                            widget.headerText!,
                            overflow: TextOverflow.fade,
                            style: widget.headerTextStyle,
                          )
                        : const SizedBox.shrink(),
                    if (!widget.hideCloseIcon)
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        iconSize: 20,
                        icon: widget.closeIcon!,
                        onPressed: () => Navigator.pop(context),
                      ),
                  ],
                ),
              ),
              if (!widget.hideSearch)
                Padding(
                  padding: widget.searchPadding,
                  child: TextField(
                    autofocus: widget.isFocused ?? false,
                    style: widget.searchStyle,
                    decoration: widget.searchDecoration,
                    onChanged: _filterElements,
                  ),
                ),
              Expanded(
                child: ListView(
                  children: [
                    widget.favoriteElements.isEmpty
                        ? const DecoratedBox(decoration: BoxDecoration())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.favoriteElements.map((f) => InkWell(
                                  onTap: () {
                                    _selectItem(f);
                                  },
                                  child: Padding(
                                    padding: widget.dialogItemPadding,
                                    child: _buildOption(f),
                                  ))),
                              const Divider(),
                            ],
                          ),
                    if (filteredElements.isEmpty)
                      _buildEmptySearchWidget(context)
                    else
                      ...filteredElements.map((e) => InkWell(
                          onTap: () {
                            _selectItem(e);
                          },
                          child: Padding(
                            padding: widget.dialogItemPadding,
                            child: _buildOption(e),
                          ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildOption(CountryCode e) {
    return SizedBox(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          if (widget.showFlag!)
            Flexible(
              child: Container(
                margin: Directionality.of(context) ==
                        TextDirection
                            .ltr // Here Adding padding depending on the locale language direction
                    ? const EdgeInsets.only(right: 16.0)
                    : const EdgeInsets.only(left: 16.0),
                decoration: widget.flagDecoration,
                clipBehavior:
                    widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                child: Image.asset(
                  e.flagUri!,
                  package: 'country_code_picker',
                  width: widget.flagWidth,
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Text(
              widget.showCountryOnly!
                  ? e.toCountryStringOnly()
                  : e.toLongString(),
              overflow: TextOverflow.fade,
              style: widget.textStyle,
            ),
          ),
        ],
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
    final normalizedSearch = removeDiacritics(s.toUpperCase());
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code!.contains(normalizedSearch) ||
              e.dialCode!.contains(normalizedSearch) ||
              removeDiacritics(e.name!.toUpperCase())
                  .contains(normalizedSearch))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
