import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:another_brother/custom_paper.dart';
import 'package:another_brother/label_info.dart';
import 'package:another_brother/printer_info.dart';
import 'package:another_brother/type_b_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = PageController(initialPage: 1);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Another Brother Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: QL820WNBPage(title: 'QL-820WNB Wi-Fi Sample'),
    );
  }
}

///==================== BEGIN ======================
///==================== BEGIN ======================
class QL820WNBPage extends StatefulWidget {
  QL820WNBPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _QL820WNBPageState createState() => _QL820WNBPageState();
}

class _QL820WNBPageState extends State<QL820WNBPage> {
  bool _error = false;

  void print(BuildContext context) async {
    var printer = new Printer();
    var printInfo = PrinterInfo();
    printInfo.printerModel = Model.QL_820NWB;
    printInfo.printMode = PrintMode.FIT_TO_PAGE;
    printInfo.isAutoCut = true;
    printInfo.port = Port.NET;
    // Set the label type.
    printInfo.labelNameIndex = 17;
    printInfo.paperSize = PaperSize.A4;

    // Set the printer info so we can use the SDK to get the printers.
    await printer.setPrinterInfo(printInfo);

    // Get a list of printers with my model available in the network.
    List<NetPrinter> printers = await printer.getNetPrinters([Model.QL_820NWB.getName()]);

    if (printers.isEmpty) {
      // Show a message if no printers are found.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("No printers found on your network."),
        ),
      ));

      return;
    }
    // Get the IP Address from the first printer found.
    printInfo.ipAddress = printers.single.ipAddress;

    printer.setPrinterInfo(printInfo);
    // printer.printImage(await loadImage('assets/brother_hack.png'));
    printer.printImage(await loadImage('assets/test.png'));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Don't forget to grant permissions to your app in Settings.",
                textAlign: TextAlign.center,
              ),
            ),
            // Image(image: AssetImage('assets/brother_hack.png'))
            Image(image: AssetImage('assets/test.png'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print(context),
        tooltip: 'Print',
        child: Icon(Icons.print),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<ui.Image> loadImage(String assetPath) async {
    final ByteData img = await rootBundle.load(assetPath);
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(new Uint8List.view(img.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}

///==================== END ========================
///==================== END ========================
