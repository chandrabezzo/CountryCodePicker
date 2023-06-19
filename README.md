![GitHub code size](https://img.shields.io/github/languages/code-size/chandrabezzo/CountryCodePicker)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

![GitHub contributors](https://img.shields.io/github/contributors/chandrabezzo/CountryCodePicker)
[![Pub](https://img.shields.io/pub/v/country_code_picker.svg)](https://pub.dartlang.org/packages/country_code_picker)
[![Linkedin](https://i.stack.imgur.com/gVE0j.png) LinkedIn](https://www.linkedin.com/in/salvatore-giordano/)
[![Linkedin](https://i.stack.imgur.com/gVE0j.png) LinkedIn](https://www.linkedin.com/in/chandra-abdul-fattah/)

# country_code_picker

A flutter package for showing a country code selector.

It supports i18n for 70 languages.

Check the example on web! https://imtoori.dev/CountryCodePicker/#/

<img src="https://raw.githubusercontent.com/Salvatore-Giordano/CountryCodePicker/master/screenshots/screen1.png" width="240"/>
<img src="https://raw.githubusercontent.com/Salvatore-Giordano/CountryCodePicker/master/screenshots/screen2.png" width="240"/>

## Usage

Just put the component in your application setting the onChanged callback.

```dart

@override
 Widget build(BuildContext context) => new Scaffold(
     body: Center(
       child: CountryCodePicker(
         onChanged: print,
         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
         initialSelection: 'IT',
         favorite: ['+39','FR'],
         // optional. Shows only country name and flag
         showCountryOnly: false,
         // optional. Shows only country name and flag when popup is closed.
         showOnlyCountryWhenClosed: false,
         // optional. aligns the flag and the Text left
         alignLeft: false,
       ),
     ),
 );

```

Example:

```dart

void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
  }

```

### i18n

Just add the `CountryLocalizations.delegate` in the list of your app delegates

```dart
 return new MaterialApp(
      supportedLocales: [
         Locale("af"),
        Locale("am"),
        Locale("ar"),
        Locale("az"),
        Locale("be"),
        Locale("bg"),
        Locale("bn"),
        Locale("bs"),
        Locale("ca"),
        Locale("cs"),
        Locale("da"),
        Locale("de"),
        Locale("el"),
        Locale("en"),
        Locale("es"),
        Locale("et"),
        Locale("fa"),
        Locale("fi"),
        Locale("fr"),
        Locale("gl"),
        Locale("ha"),
        Locale("he"),
        Locale("hi"),
        Locale("hr"),
        Locale("hu"),
        Locale("hy"),
        Locale("id"),
        Locale("is"),
        Locale("it"),
        Locale("ja"),
        Locale("ka"),
        Locale("kk"),
        Locale("km"),
        Locale("ko"),
        Locale("ku"),
        Locale("ky"),
        Locale("lt"),
        Locale("lv"),
        Locale("mk"),
        Locale("ml"),
        Locale("mn"),
        Locale("ms"),
        Locale("nb"),
        Locale("nl"),
        Locale("nn"),
        Locale("no"),
        Locale("pl"),
        Locale("ps"),
        Locale("pt"),
        Locale("ro"),
        Locale("ru"),
        Locale("sd"),
        Locale("sk"),
        Locale("sl"),
        Locale("so"),
        Locale("sq"),
        Locale("sr"),
        Locale("sv"),
        Locale("ta"),
        Locale("tg"),
        Locale("th"),
        Locale("tk"),
        Locale("tr"),
        Locale("tt"),
        Locale("uk"),
        Locale("ug"),
        Locale("ur"),
        Locale("uz"),
        Locale("vi"),
        Locale("zh")
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
 )
```

## Customization

Here is a list of properties available to customize your widget:

| Name                      | Type                      | Description                                                              |
| ------------------------- | ------------------------- | ------------------------------------------------------------------------ |
| alignLeft                 | bool                      | aligns the flag and the Text to the left                                 |
| builder                   | Function(CountryCode)     | use this to build a custom widget instead of the default FlatButton      |
| closeIcon                 | Widget                    | custom widget used to close the dialog                                   |
| comparator                | Comparator<CountryCode>   | use this to sort the countries in the selection dialog                   |
| countryFilter             | List<String>              | uses a list of strings to filter a sublist of countries                  |
| dialogSize                | Size                      | the size of the selection dialog                                         |
| dialogTitle               | Widget                    | custom widget used as title for the dialog.                              |
| emptySearchBuilder        | WidgetBuilder             | use this to customize the widget used when the search returns 0 elements |
| enabled                   | bool                      | set to false to disable the widget                                       |
| favorites                 | List<String>              | used to populate the favorite country list                               |
| flagDecoration            | Decoration                | used for styling the flags                                               |
| flagWidth                 | double                    | the width of the flags                                                   |
| hideSearch                | bool                      | if true, the search feature will be disabled                             |
| initialSelection          | String                    | used to set the initial selected value                                   |
| onChanged                 | ValueChanged<CountryCode> | callback invoked when the selection changes                              |
| onInit                    | ValueChanged<CountryCode> | callback invoked during initialization of the widget                     |
| padding                   | EdgeInsetsGeometry        | the padding applied to the button                                        |
| searchDecoration          | InputDecoration           | decoration applied to the TextField search widget                        |
| searchStyle               | TextStyle                 | style applied to the TextField search widget text                        |
| separator                 | Widget                    | separator widget for list items inside the dialog                        |
| showCountryOnly           | bool                      | true if you want to see only the countries in the selection dialog       |
| showFlag                  | bool                      | shows the flag everywhere                                                |
| showFlagsInDialog         | bool                      | shows the flag only in dialog                                            |
| showFlagMain              | bool                      | shows the flag only when the dialog closed                               |
| showOnlyCountryWhenClosed | bool                      | if true, it'll show only the country                                     |
| textOverflow              | TextOverflow              | the button text overflow behaviour                                       |
| textStyle                 | TextStyle                 | textStyle applied to the widget button                                   |

## Contributions

Contributions of any kind are more than welcome! Feel free to fork and improve country_code_picker in any way you want, make a pull request, or open an issue.

## Getting involved

First of all, thank you for even considering to get involved. You are a real super :star: and we :heart: you!

### Reporting bugs and issues

Use the configured [Github issue report template](https://github.com/imtoori/CountryCodePicker/issues/new?assignees=&labels=&template=bug_report.md&title=) when reporting an issue. Make sure to state your observations and expectations
as objectively and informative as possible so that we can understand your need and be able to troubleshoot.

### Discussions and ideas

We're happy to discuss and talk about ideas, post your
question to [StackOverflow](https://stackoverflow.com/search?q=country+code+picker).

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/chandra-abdul-fattah"><img src="https://avatars.githubusercontent.com/u/16184998?v=4?s=100" width="100px;" alt="Chandra Abdul Fattah"/><br /><sub><b>Chandra Abdul Fattah</b></sub></a><br /><a href="#infra-chandrabezzo" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/chandrabezzo/CountryCodePicker/commits?author=chandrabezzo" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/imtoori"><img src="https://avatars.githubusercontent.com/u/20601437?v=4?s=100" width="100px;" alt="Salvatore Giordano"/><br /><sub><b>Salvatore Giordano</b></sub></a><br /><a href="#infra-imtoori" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/chandrabezzo/CountryCodePicker/commits?author=imtoori" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
