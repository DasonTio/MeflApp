import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/pages/home/home_view.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/print/model/BluePrint.dart';
import 'package:mefl_app_bloc/services/transaction_service.dart';

class MenuPrintPage extends StatefulWidget {
  MenuPrintPage({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  String transactionId;
  @override
  _MenuPrintPageState createState() => _MenuPrintPageState();
}

class _MenuPrintPageState extends State<MenuPrintPage> {
  TransactionService _service = TransactionService();
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult>? scanResult;

  @override
  void initState() {
    _service.loadSingle(transactionId: widget.transactionId);
    findDevices();
  }

  void findDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResult = results;
      });
    });
  }

  void printWithDevice({
    required BluetoothDevice device,
    required TransactionDetail products,
  }) async {
    await device.connect();
    final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
    final printer = BluePrint();
    printer.add(
      gen.text(
        "Mefl  Restaurant",
        styles: PosStyles(
          width: PosTextSize.size6,
        ),
      ),
    );

    printer.add(gen.hr());
    products.models.forEach((e) {
      final product = e.menu;
      final money = moneyFormat.format(product.price);
      printer.add(gen.row([
        PosColumn(
            text: product.name,
            width: 6,
            styles: PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: moneyFormat.format(product.price),
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              width: PosTextSize.size1,
            )),
      ]));
      printer.add(
        gen.text(
          '$money x ${e.model.quantity}',
          styles: PosStyles(
            width: PosTextSize.size1,
          ),
        ),
      );
    });
    final grandtotal = products.models.fold(
        0.00, (prev, next) => prev += next.menu.price * next.model.quantity);
    printer.add(gen.hr());
    printer.add(
      gen.text(
        "GrandTotal: ${moneyFormat.format(grandtotal)}",
        styles: PosStyles(
          align: PosAlign.right,
        ),
      ),
    );
    printer.add(gen.cut());

    await printer.printData(device);
    device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: StreamBuilder(
        stream: _service.single,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return SafeArea(
              child: Column(
                children: [
                  paddingContent(Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeView(),
                              ));
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: blackColor,
                          size: SizeConfig.blockHorizontal! * 6,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.blockHorizontal! * 13,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Tambah Menu',
                          style: boldFont.copyWith(
                            fontSize: SizeConfig.blockHorizontal! * 6,
                            color: blackColor,
                          ),
                        ),
                      )
                    ],
                  )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: scanResult?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                            leading:
                                scanResult![index].device.type.name == "printer"
                                    ? Icon(Icons.print_rounded)
                                    : Icon(Icons.help),
                            title: Text(scanResult![index].device.name == ""
                                ? "Unknown"
                                : scanResult![index].device.name),
                            subtitle: Text(scanResult![index].device.id.id),
                            onTap: () {
                              printWithDevice(
                                device: scanResult![index].device,
                                products: data,
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget paddingContent(Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockVertical! * 4,
        horizontal: SizeConfig.blockHorizontal! * 4,
      ),
      child: child,
    );
  }

  Widget horizontalPaddingContent(Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockHorizontal! * 8,
      ),
      child: child,
    );
  }
}
