import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Tutorial',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

const htmlData = r"""
<body style="background-color:powderblue;">
      <h3>Support for math equations:</h3>
      Solve for <var>x<sub>n</sub></var>: log<sub>2</sub>(<var>x</var><sup>2</sup>+<var>n</var>) = 9<sup>3</sup>
     <h3>Inline Styles:</h3>
      <p>This should be <span style='color: blue;'>BLUE style='color: blue;'</span></p>
      <h3>Table support (with custom styling!):</h3>
      <table>
      <colgroup>
        <col width="50%" />
        <col span="2" width="25%" />
      </colgroup>
      <thead>
      <tr><th>One</th><th>Two</th><th>Three</th></tr>
      </thead>
      <tbody>
      <tr>
        <td rowspan='2'>Rowspan</td><td>Data</td><td>Data</td>
      </tr>
      <tr>
        <td colspan="2"><img alt='Google' src='https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png' /></td>
      </tr>
      </tbody>
      <tfoot>
      <tr><td>fData</td><td>fData</td><td>fData</td></tr>
      </tfoot>
      </table>
      <h4>Below is the custom tag: Flutter tag</h4>
      <flutter vertical></flutter>
      <h3>List support:</h3>
      <ol>
            <li>This</li>
            <li><p>is</p></li>
            <li>
            ordered
            <ul>
            <li>This is a</li>
            <li>nested</li>
            <li>unordered list
            </li>
            </ul>
            </li>
      </ol>
      <h3>Images are also supported:</h3>
      <h3>Network png</h3>
     <img src="https://res.cloudinary.com/nitishk72/image/upload/v1586796259/nstack_in/courses/flutter/flutter-banner.png">
      <h3>Network svg</h3>
      <img src='https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/android.svg' />
     <h3>Data uri (with base64 support)</h3>
      <img alt='Red dot (png)' src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==' />
      <img alt='Green dot (base64 svg)' src='data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2aWV3Qm94PSIwIDAgMzAgMjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxjaXJjbGUgY3g9IjE1IiBjeT0iMTAiIHI9IjEwIiBmaWxsPSJncmVlbiIvPgo8L3N2Zz4=' />
      <img alt='Green dot (plain svg)' src='data:image/svg+xml,%3C?xml version="1.0" encoding="UTF-8"?%3E%3Csvg viewBox="0 0 30 20" xmlns="http://www.w3.org/2000/svg"%3E%3Ccircle cx="15" cy="10" r="10" fill="yellow"/%3E%3C/svg%3E' />
       
""";

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('GeeksForGeeks'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: htmlData,
          tagsList: Html.tags..add("flutter"),
          style: {
            //add style to the tags in HTML code
            "table": Style(
              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            ),
            "tr": Style(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: EdgeInsets.all(6),
              backgroundColor: Colors.grey,
            ),
            "td": Style(
              padding: EdgeInsets.all(6),
              alignment: Alignment.topLeft,
            ),
            'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
          },
          customRender: {
            "table": (context, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: (context.tree as TableLayoutElement).toWidget(context),
              );
            },
            //adding customizable tag
            "flutter": (RenderContext context, Widget child) {
              //giving style to Flutter tag with FlutterLogo() widget
              return FlutterLogo(
                style: (context.tree.element!.attributes['horizontal'] != null)
                    ? FlutterLogoStyle.horizontal
                    : FlutterLogoStyle.markOnly,
                textColor: context.style.color!,
                size: context.style.fontSize!.size! * 5,
              );
            },
          },
          customImageRenders: {
            //We can give similar features to elements from the same domain like for flutter.dev
//We can define any number of networkSourceMatcher
            networkSourceMatcher(domains: ["flutter.dev"]):
                (context, attributes, element) {
              return FlutterLogo(size: 36);
            },
            networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
              headers: {"Custom-Header": "some-value"},
              altWidget: (alt) => Text(alt ?? ""),
              loadingWidget: () => Text("Loading..."),
            ),
            // If relative paths starts with /wiki, prefix them with a base url
            (attr, _) =>
                    attr["src"] != null && attr["src"]!.startsWith("/wiki"):
                networkImageRender(
                    mapUrl: (url) => "https://upload.wikimedia.org" + url!),
            // If links for images are broken use Custom placeholder image
            networkSourceMatcher():
                networkImageRender(altWidget: (_) => FlutterLogo()),
          },
          onCssParseError: (css, messages) {
            //If error occurs while applying CSS to HTML
            print("css that errored: $css");
            print("error messages:");
            messages.forEach((element) {
              print(element);
            });
          },
        ),
      ),
    );
  }
}
