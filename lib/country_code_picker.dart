library country_code_picker;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import 'src/bottom_sheet.dart';
import 'src/constants.dart';
import 'src/country_code.dart';
import 'src/country_codes.dart';
import 'src/selection_dialog.dart';

export 'src/country_code.dart';
export 'src/country_codes.dart';
export 'src/country_localizations.dart';
export 'src/selection_dialog.dart';
export 'src/bottom_sheet.dart';
export 'src/constants.dart';

class CountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryCode>? onChanged;
  final ValueChanged<CountryCode?>? onInit;
  final String? initialSelection;
  final List<String> favorite;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final TextStyle? dialogTextStyle;
  final WidgetBuilder? emptySearchBuilder;
  final Function(CountryCode?)? builder;
  final bool enabled;
  final TextOverflow textOverflow;
  final Icon closeIcon;

  ///Picker style [BottomSheet] or [Dialog]
  final PickerStyle pickerStyle;

  /// Barrier color of ModalBottomSheet
  final Color? barrierColor;

  /// Background color of ModalBottomSheet
  final Color? backgroundColor;

  /// BoxDecoration for dialog
  final BoxDecoration? boxDecoration;

  /// the size of the selection dialog
  final Size? dialogSize;

  /// Background color of selection dialog
  final Color? dialogBackgroundColor;

  /// used to customize the country list
  final List<String>? countryFilter;

  /// shows the name of the country instead of the dialcode
  final bool showOnlyCountryWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially useful in combination with [showOnlyCountryWhenClosed],
  /// because longer country names are displayed in one line
  final bool alignLeft;

  /// shows the flag
  final bool showFlag;

  final bool hideMainText;

  final bool? showFlagMain;

  final bool? showFlagDialog;

  /// Width of the flag images
  final double flagWidth;

  /// Use this property to change the order of the options
  final Comparator<CountryCode>? comparator;

  /// Set to true if you want to hide the search part
  final bool hideSearch;

  /// Set to true if you want to hide the close icon dialog
  final bool hideCloseIcon;

  /// Set to true if you want to show drop down button
  final bool showDropDownButton;

  /// [BoxDecoration] for the flag image
  final Decoration? flagDecoration;

  /// An optional argument for injecting a list of countries
  /// with customized codes.
  final List<Map<String, String>> countryList;

  final EdgeInsetsGeometry dialogItemPadding;

  final EdgeInsetsGeometry searchPadding;

  ///Use This To Hide The Header Text
  final bool hideHeaderText;

  ///Change The Header Text
  final String? headerText;

  ///Header Text Style
  final TextStyle headerTextStyle;

  ///Header Text Padding
  final EdgeInsets topBarPadding;

  ///Header Text Alignment
  final MainAxisAlignment headerAlignment;

  /// space after dropdown icon if shown
  final double? spaceAfterDropdownIcon;

  const CountryCodePicker({
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.favorite = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.dialogTextStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.showFlagDialog,
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
    this.hideCloseIcon = false,
    this.showDropDownButton = false,
    this.dialogSize,
    this.dialogBackgroundColor,
    this.closeIcon = const Icon(Icons.close),
    this.countryList = codes,
    this.pickerStyle = PickerStyle.dialog,
    this.dialogItemPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.searchPadding = const EdgeInsets.symmetric(horizontal: 24),
    this.headerAlignment = MainAxisAlignment.spaceBetween,
    this.headerText = "Select Country",
    this.headerTextStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.hideHeaderText = false,
    this.topBarPadding = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
    this.spaceAfterDropdownIcon,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    List<Map<String, String>> jsonList = countryList;

    List<CountryCode> elements = jsonList.map((json) => CountryCode.fromJson(json)).toList();

    if (comparator != null) {
      elements.sort(comparator);
    }

    if (countryFilter != null && countryFilter!.isNotEmpty) {
      final uppercaseCustomList = countryFilter!.map((criteria) => criteria.toUpperCase()).toList();
      elements = elements
          .where((criteria) =>
      uppercaseCustomList.contains(criteria.code) ||
          uppercaseCustomList.contains(criteria.name) ||
          uppercaseCustomList.contains(criteria.dialCode))
          .toList();
    }

    return CountryCodePickerState(elements, pickerStyle);
  }
}

class CountryCodePickerState extends State<CountryCodePicker> {
  CountryCode? selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];
  PickerStyle pickerStyle;

  CountryCodePickerState(this.elements, this.pickerStyle);

  @override
  Widget build(BuildContext context) {
    Widget internalWidget;
    if (widget.builder != null) {
      internalWidget = InkWell(
        onTap: pickerStyle == PickerStyle.dialog ? showCountryCodePickerDialog : showCountryCodePickerBottomSheet,
        child: widget.builder!(selectedItem),
      );
    } else {
      internalWidget = TextButton(
        onPressed: widget.enabled
            ? pickerStyle == PickerStyle.dialog
            ? showCountryCodePickerDialog
            : showCountryCodePickerBottomSheet
            : null,
        child: Padding(
          padding: widget.padding,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showFlagMain != null ? widget.showFlagMain! : widget.showFlag)
                Flexible(
                  flex: widget.alignLeft ? 0 : 1,
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Container(
                    clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                    decoration: widget.flagDecoration,
                    margin: widget.margin ??
                        (widget.alignLeft
                            ? const EdgeInsets.only(right: 16.0, left: 8.0)
                            : const EdgeInsets.only(right: 16.0)),
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
                    widget.showOnlyCountryWhenClosed ? selectedItem!.toCountryStringOnly() : selectedItem.toString(),
                    style: widget.textStyle ?? Theme.of(context).textTheme.labelLarge,
                    overflow: widget.textOverflow,
                  ),
                ),
              if (widget.showDropDownButton)
                Flexible(
                  flex: widget.alignLeft ? 0 : 1,
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Padding(
                      padding: (widget.alignLeft
                          ?  EdgeInsets.only(right: widget.spaceAfterDropdownIcon?? 16.0, left: 8.0)
                          :  EdgeInsets.only(right: widget.spaceAfterDropdownIcon?? 16.0)),
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
            (criteria.code!.toUpperCase() == widget.initialSelection!.toUpperCase()) ||
                (criteria.dialCode == widget.initialSelection) ||
                (criteria.name!.toUpperCase() == widget.initialSelection!.toUpperCase()),
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
          (item.code!.toUpperCase() == widget.initialSelection!.toUpperCase()) ||
              (item.dialCode == widget.initialSelection) ||
              (item.name!.toUpperCase() == widget.initialSelection!.toUpperCase()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((item) =>
    widget.favorite.firstWhereOrNull((criteria) =>
    item.code!.toUpperCase() == criteria.toUpperCase() ||
        item.dialCode == criteria ||
        item.name!.toUpperCase() == criteria.toUpperCase()) !=
        null)
        .toList();
  }

  void showCountryCodePickerDialog() async {
    final item = await showDialog(
      barrierColor: widget.barrierColor ?? Colors.grey.withAlpha(128),
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
            showFlag: widget.showFlagDialog ?? widget.showFlag,
            flagWidth: widget.flagWidth,
            size: widget.dialogSize,
            headerAlignment: widget.headerAlignment,
            headerText: widget.headerText,
            headerTextStyle: widget.headerTextStyle,
            hideHeaderText: widget.hideHeaderText,
            topBarPadding: widget.topBarPadding,
            backgroundColor: widget.dialogBackgroundColor,
            barrierColor: widget.barrierColor,
            hideSearch: widget.hideSearch,
            hideCloseIcon: widget.hideCloseIcon,
            closeIcon: widget.closeIcon,
            flagDecoration: widget.flagDecoration,
            dialogItemPadding: widget.dialogItemPadding,
            searchPadding: widget.searchPadding,
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

  void showCountryCodePickerBottomSheet() async {
    final item = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return SelectionBottomSheet(
          elements,
          favoriteElements,
          showCountryOnly: widget.showCountryOnly,
          emptySearchBuilder: widget.emptySearchBuilder,
          searchDecoration: widget.searchDecoration,
          searchStyle: widget.searchStyle,
          textStyle: widget.dialogTextStyle,
          boxDecoration: widget.boxDecoration,
          showFlag: widget.showFlagDialog ?? widget.showFlag,
          flagWidth: widget.flagWidth,
          size: widget.dialogSize,
          backgroundColor: widget.dialogBackgroundColor,
          barrierColor: widget.barrierColor,
          hideSearch: widget.hideSearch,
          closeIcon: widget.closeIcon,
          flagDecoration: widget.flagDecoration,
        );
      },
    );

    if (item == null) return;

    setState(() {
      selectedItem = item;
    });

    _publishSelection(item);
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
