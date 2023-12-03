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
  final bool? showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final bool hideLineAbovFiled;
  final Icon? closeIcon;

  /// Background color of SelectionDialog
  final Color? backgroundColor;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  final EdgeInsetsGeometry dialogItemPadding;

  final EdgeInsetsGeometry searchPadding;
  String? txtFieldHintTxt="search";
  double  height =0.70;
  TextDirection textDirection;
  bool clickableFilepicker;
  Color txtFieldBorderColor;
  Color containerBorderColor;

  SelectionDialog(
      this.containerBorderColor,
      this.txtFieldBorderColor,
      this.clickableFilepicker,
      this.textDirection,
      this.height,
      this.txtFieldHintTxt,
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.boxDecoration,
    this.showFlag,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.backgroundColor,
    this.barrierColor,
    this.hideSearch = false,
    this.hideLineAbovFiled = false,
    this.closeIcon,
    this.dialogItemPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
        padding: const EdgeInsets.all(5.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: widget.size?.width ?? MediaQuery.of(context).size.width,
          height: widget.size?.height ?? MediaQuery.of(context).size.height * widget.height,
          decoration: widget.boxDecoration ??
              BoxDecoration(
                color: widget.backgroundColor ?? Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  border: Border.all(
                    color: widget.containerBorderColor,
                    width: 1,
                  ),
                boxShadow: [
                ],
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            //  if (!widget.hideCloseIcon)
             /* IconButton(
                padding: const EdgeInsets.all(0),
                iconSize: 20,
                icon: widget.closeIcon!,
                onPressed: () => Navigator.pop(context),
              ),*/

              SizedBox(height:10,) ,

              widget.hideLineAbovFiled?
              SizedBox():
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black, // Set line color
                        borderRadius: BorderRadius.all(
                          Radius.circular(20)

                        ),
                      ),
                      height: 4.0, // Set line thickness
                      width: 100.0, // Set line length
                    ),
                  ),
                ),


              SizedBox(height:25,) ,
              if (!widget.hideSearch)
                Padding(
                  padding: widget.searchPadding,
                  child: Directionality(
                    textDirection: widget.textDirection,

                    child: TextField(



                      decoration: InputDecoration(

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: widget.txtFieldBorderColor,// Change the border color as needed
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: widget.txtFieldBorderColor,  // Change the border color as needed
                            width: 1.0,
                          ),
                        ),


                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: widget.txtFieldBorderColor,  // Change the border color as needed
                            width: 1.0,          // Adjust the border width
                          ),
                        ),
                        hintText: widget.txtFieldHintTxt,
                        suffixIcon: Icon(Icons.search),
                      ),
                      style: widget.searchStyle,
                      //decoration: widget.searchDecoration,
                      onChanged: _filterElements,
                    ),
                  ),
                ),
              SizedBox(height:10,) ,

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListView(
                    children: [
                      widget.favoriteElements.isEmpty
                          ? const DecoratedBox(decoration: BoxDecoration())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...widget.favoriteElements.map(
                                  (f) => InkWell(
                                    onTap: () {
                                      widget.clickableFilepicker?
                                      _selectItem(f) :
                                          debugPrint("");
                                    },
                                    child: Padding(
                                      padding: widget.dialogItemPadding,
                                      child: _buildOption(f),
                                    )
                                  )
                                ),
                                const Divider(),
                              ],
                            ),
                      if (filteredElements.isEmpty)
                        _buildEmptySearchWidget(context)
                      else
                        ...filteredElements.map(
                          (e) => InkWell(
                            onTap: () {
                              widget.clickableFilepicker?
                              _selectItem(e) :
                              debugPrint("");
                            },
                            child: Padding(
                            padding: widget.dialogItemPadding,
                              child: _buildOption(e),
                            )
                          )
                        ),
                    ],
                  ),
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
                margin: const EdgeInsets.only(right: 16.0),
               // decoration: widget.flagDecoration,
                /*clipBehavior:
                    widget.flagDecoration == null ? Clip.none : Clip.hardEdge,*/
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0), // Set the circular border radius

                  child: Image.asset(
                    e.flagUri!,
                    package: 'country_code_picker',
                    width: 40,

                    //widget.flagWidth,
                    fit: BoxFit.cover, // Adjust the BoxFit as needed

                  ),
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
              style: TextStyle(fontWeight: FontWeight.w700),
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
