library country_code_picker;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import 'src/country_code.dart';
import 'src/country_codes.dart';
import 'src/selection_dialog.dart';

export 'src/country_code.dart';
export 'src/country_codes.dart';
export 'src/country_localizations.dart';
export 'src/selection_dialog.dart';

class CountryCodePicker extends StatefulWidget {
  /// Callback invoked when the selection changes.
  final ValueChanged<CountryCode>? onChanged;

  /// Callback invoked during initialization of the widget.
  final ValueChanged<CountryCode?>? onInit;

  /// Used to set the initial selected value.
  final String? initialSelection;

  /// Used to populate the favorite country list.
  final List<String> favorites;

  /// TextStyle applied to the widget button.
  final TextStyle? textStyle;

  /// The padding applied to the button.
  final EdgeInsetsGeometry padding;

  /// When true, the dialog will not show the dial code, only the country name.
  final bool showCountryOnly;

  /// The input decoration for the search field in the dialog.
  final InputDecoration searchDecoration;

  /// The TextStyle of the search field.
  final TextStyle? searchStyle;

  /// The TextStyle of the country name and country code in the dialog.
  final TextStyle? dialogTextStyle;

  /// Use this to customize the widget used when the search returns 0 elements.
  final WidgetBuilder? emptySearchBuilder;

  /// Use this to build a custom widget instead of the default FlatButton.
  final Function(CountryCode?)? builder;

  /// Set to false to disable the widget.
  final bool enabled;

  /// The button text overflow behaviour.
  final TextOverflow textOverflow;

  /// Custom widget used to close the dialog.
  final Widget? closeIcon;

  /// Custom widget used as title for the dialog.
  final Widget? dialogTitle;

  /// Barrier color of ModalBottomSheet.
  final Color? barrierColor;

  /// Background color of ModalBottomSheet.
  final Color? backgroundColor;

  /// BoxDecoration for dialog.
  final BoxDecoration? boxDecoration;

  /// the size of the selection dialog.
  final Size? dialogSize;

  /// Background color of selection dialog.
  final Color? dialogBackgroundColor;

  /// used to customize the country list.
  final List<String>? countryFilter;

  /// shows the name of the country instead of the dialcode.
  final bool showOnlyCountryWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially useful in combination with [showOnlyCountryWhenClosed],
  /// because longer country names are displayed in one line.
  final bool alignLeft;

  /// Whether to show the flag on the button or not.
  final bool showFlag;

  /// When true, the button does not display the country code nor the country name.
  final bool hideMainText;

  /// Shows the flag only when the dialog closed.
  final bool? showFlagMain;

  /// Whether to show flags in the dialog or not.
  final bool? showFlagsInDialog;

  /// Width of the flag images.
  final double flagWidth;

  /// Use this property to change the order of the options.
  final Comparator<CountryCode>? comparator;

  /// Set to true if you want to hide the search part.
  final bool hideSearch;

  /// Set to true if you want to show drop down button.
  final bool showDropDownButton;

  /// [BoxDecoration] for the flag image.
  final Decoration? flagDecoration;

  /// An optional argument for injecting a list of countries
  /// with customized codes.
  final List<Map<String, String>> countryList;

  /// Separator widget for list items inside the dialog.
  final Widget? separator;

  const CountryCodePicker({
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.favorites = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(8.0),
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.dialogTextStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.showFlagsInDialog,
    this.hideMainText = false,
    this.showFlagMain,
    this.flagDecoration,
    this.builder,
    this.flagWidth = 32.0,
    this.enabled = true,
    this.textOverflow = TextOverflow.ellipsis,
    this.barrierColor,
    this.backgroundColor,
    this.boxDecoration,
    this.comparator,
    this.countryFilter,
    this.hideSearch = false,
    this.showDropDownButton = false,
    this.dialogSize,
    this.dialogBackgroundColor,
    this.closeIcon,
    this.dialogTitle,
    this.countryList = codes,
    this.separator,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    List<Map<String, String>> jsonList = countryList;

    List<CountryCode> elements =
        jsonList.map((json) => CountryCode.fromJson(json)).toList();

    if (comparator != null) {
      elements.sort(comparator);
    }

    if (countryFilter != null && countryFilter!.isNotEmpty) {
      final uppercaseCustomList =
          countryFilter!.map((criteria) => criteria.toUpperCase()).toList();
      elements = elements
          .where((criteria) =>
              uppercaseCustomList.contains(criteria.code) ||
              uppercaseCustomList.contains(criteria.name) ||
              uppercaseCustomList.contains(criteria.dialCode))
          .toList();
    }

    return CountryCodePickerState(elements);
  }
}

class CountryCodePickerState extends State<CountryCodePicker> {
  CountryCode? selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];

  CountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    Widget internalWidget;
    if (widget.builder != null) {
      internalWidget = InkWell(
        onTap: showCountryCodePickerDialog,
        child: widget.builder!(selectedItem),
      );
    } else {
      internalWidget = TextButton(
        onPressed: widget.enabled ? showCountryCodePickerDialog : null,
        child: Padding(
          padding: widget.padding,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showFlagMain != null
                  ? widget.showFlagMain!
                  : widget.showFlag)
                Flexible(
                  flex: widget.alignLeft ? 0 : 1,
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Container(
                    clipBehavior: widget.flagDecoration == null
                        ? Clip.none
                        : Clip.hardEdge,
                    decoration: widget.flagDecoration,
                    margin: widget.alignLeft
                        ? const EdgeInsets.only(right: 16.0, left: 8.0)
                        : const EdgeInsets.only(right: 16.0),
                    child: Image.asset(
                      selectedItem!.flagUri!,
                      package: 'country_code_picker',
                      width: widget.flagWidth,
                    ),
                  ),
                ),
              if (!widget.hideMainText)
                Flexible(
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Text(
                    widget.showOnlyCountryWhenClosed
                        ? selectedItem!.toCountryStringOnly()
                        : selectedItem.toString(),
                    style: widget.textStyle ??
                        Theme.of(context).textTheme.labelLarge,
                    overflow: widget.textOverflow,
                  ),
                ),
              if (widget.showDropDownButton)
                Flexible(
                  flex: widget.alignLeft ? 0 : 1,
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Padding(
                      padding: widget.alignLeft
                          ? const EdgeInsets.only(right: 16.0, left: 8.0)
                          : const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                        size: widget.flagWidth,
                      )),
                ),
            ],
          ),
        ),
      );
    }
    return internalWidget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    elements = elements.map((element) => element.localize(context)).toList();
    _onInit(selectedItem);
  }

  @override
  void didUpdateWidget(CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      if (widget.initialSelection != null) {
        selectedItem = elements.firstWhere(
            (criteria) =>
                (criteria.code!.toUpperCase() ==
                    widget.initialSelection!.toUpperCase()) ||
                (criteria.dialCode == widget.initialSelection) ||
                (criteria.name!.toUpperCase() ==
                    widget.initialSelection!.toUpperCase()),
            orElse: () => elements[0]);
      } else {
        selectedItem = elements[0];
      }
      _onInit(selectedItem);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (item) =>
              (item.code!.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()) ||
              (item.dialCode == widget.initialSelection) ||
              (item.name!.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((item) =>
            widget.favorites.firstWhereOrNull((criteria) =>
                item.code!.toUpperCase() == criteria.toUpperCase() ||
                item.dialCode == criteria ||
                item.name!.toUpperCase() == criteria.toUpperCase()) !=
            null)
        .toList();
  }

  void showCountryCodePickerDialog() async {
    final item = await showDialog(
      barrierColor: widget.barrierColor ?? Colors.grey.withOpacity(0.5),
      context: context,
      builder: (context) => Center(
        child: Dialog(
          child: SelectionDialog(
            elements,
            favoriteElements,
            showCountryOnly: widget.showCountryOnly,
            emptySearchBuilder: widget.emptySearchBuilder,
            searchDecoration: widget.searchDecoration,
            searchStyle: widget.searchStyle,
            textStyle: widget.dialogTextStyle,
            boxDecoration: widget.boxDecoration,
            showFlag: widget.showFlagsInDialog ?? widget.showFlag,
            flagWidth: widget.flagWidth,
            size: widget.dialogSize,
            backgroundColor: widget.dialogBackgroundColor,
            barrierColor: widget.barrierColor,
            hideSearch: widget.hideSearch,
            closeIcon: widget.closeIcon,
            title: widget.dialogTitle,
            flagDecoration: widget.flagDecoration,
            separator: widget.separator,
          ),
        ),
      ),
    );

    if (item != null) {
      setState(() {
        selectedItem = item;
      });

      _publishSelection(item);
    }
  }

  void _publishSelection(CountryCode countryCode) {
    if (widget.onChanged != null) {
      widget.onChanged!(countryCode);
    }
  }

  void _onInit(CountryCode? countryCode) {
    if (widget.onInit != null) {
      widget.onInit!(countryCode);
    }
  }
}
