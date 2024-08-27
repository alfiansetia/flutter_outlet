import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_outlet/core/extensions/int_ext.dart';
import 'package:flutter_outlet/features/auth/repository/auth_repository.dart';
import 'package:flutter_outlet/features/branch/models/branch.dart';
import 'package:flutter_outlet/features/order/models/order.dart';
import 'package:flutter_outlet/features/setting/models/setting.dart';
import 'package:flutter_outlet/features/setting/repository/setting_repository.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_outlet/models/custom_error.dart';
import 'package:flutter_outlet/features/printer/models/printer.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterServices {
  Future<List<Printer>> getAll() async {
    await _checkStatus();
    List<Printer> data = [];
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      data.add(
        Printer(
          name: bluetooth.name,
          mac: bluetooth.macAdress,
        ),
      );
    });
    return data;
  }

  Future<int> batteryLevel(Printer printer) async {
    await _checkStatus();
    return await PrintBluetoothThermal.batteryLevel;
  }

  Future<bool> printOrder({required Order order}) async {
    final Setting setting = await SettingRepository().getData();
    await _checkStatus();
    if (setting.defaultMac.isEmpty) {
      throw const CustomError(message: 'Default Device Not set!');
    }
    if (await PrintBluetoothThermal.connectionStatus) {
      await PrintBluetoothThermal.disconnect;
    }
    bool connect = await PrintBluetoothThermal.connect(
        macPrinterAddress: setting.defaultMac);
    if (!connect) {
      throw const CustomError(message: 'Failed to Connect!');
    }
    bool status = await PrintBluetoothThermal.connectionStatus;
    if (!status) {
      throw const CustomError(message: 'Device Not Connect!');
    }
    final branch = await AuthRepository().getBranch();
    List<int> ticket =
        await _getBytesOrder(order: order, branch: branch, setting: setting);
    // bool result =
    await PrintBluetoothThermal.writeBytes(ticket);
    // if (!result) {
    //   throw const CustomError(message: 'Error Printing!');
    // }
    return true;
  }

  Future<bool> printTest(
      {required Printer printer, required Setting setting}) async {
    await _checkStatus();
    if (await PrintBluetoothThermal.connectionStatus) {
      await PrintBluetoothThermal.disconnect;
    }
    bool connect =
        await PrintBluetoothThermal.connect(macPrinterAddress: printer.mac);
    if (!connect) {
      throw const CustomError(message: 'Failed to Connect!');
    }
    bool status = await PrintBluetoothThermal.connectionStatus;
    if (!status) {
      throw const CustomError(message: 'Device Not Connect!');
    }
    List<int> ticket = await _testTicket(setting: setting);
    // bool result =
    await PrintBluetoothThermal.writeBytes(ticket);
    // if (!result) {
    //   throw const CustomError(message: 'Error Printing!');
    // }
    return true;
  }

  Future<bool> _checkStatus() async {
    bool granted = await PrintBluetoothThermal.isPermissionBluetoothGranted;
    if (!granted) {
      throw const CustomError(message: 'Permission bluetooth not granted');
    }
    bool enabled = await PrintBluetoothThermal.bluetoothEnabled;
    if (!enabled) {
      throw const CustomError(message: 'Bluetooth Not Enabled!');
    }
    return true;
  }

  Future<List<int>> _testTicket({
    required Setting setting,
  }) async {
    List<int> bytes = [];

    PaperSize papersize = PaperSize.mm58;
    if (setting.paper == PaperSetting.mm80) {
      papersize = PaperSize.mm80;
    } else if (setting.paper == PaperSetting.mm72) {
      papersize = PaperSize.mm72;
    }
    final profile = await CapabilityProfile.load();
    final generator = Generator(papersize, profile);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/images/logo_gs.png');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image image = img.decodeImage(bytesImg)!;
    img.Image resizedImg = img.copyResize(image, width: 180);
    img.Image grayscaleImg = img.grayscale(resizedImg, amount: 10);
    bytes += generator.imageRaster(grayscaleImg, align: PosAlign.center);

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);
    //barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    //QR code
    bytes += generator.qrcode('example.com');

    bytes += generator.text(
      'Text size 50%',
      styles: const PosStyles(
        fontType: PosFontType.fontB,
      ),
    );
    bytes += generator.text(
      'Text size 100%',
      styles: const PosStyles(
        fontType: PosFontType.fontA,
      ),
    );
    bytes += generator.text(
      'Text size 200%',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> _getBytesOrder({
    required Order order,
    required Branch branch,
    required Setting setting,
  }) async {
    List<int> bytes = [];
    String dateString = order.date;
    DateTime dateTime = DateTime.parse(dateString);

    PaperSize papersize = PaperSize.mm58;
    if (setting.paper == PaperSetting.mm80) {
      papersize = PaperSize.mm80;
    } else if (setting.paper == PaperSetting.mm72) {
      papersize = PaperSize.mm72;
    }

    String date = DateFormat("dd-MMM-yyyy").format(dateTime);
    String time = DateFormat("HH:mm:ss").format(dateTime);

    final profile = await CapabilityProfile.load();
    final generator = Generator(papersize, profile);

    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/images/logo_gs.png');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image image = img.decodeImage(bytesImg)!;
    img.Image resizedImg = img.copyResize(image, width: 180);
    img.Image grayscaleImg = img.grayscale(resizedImg, amount: 10);
    bytes += generator.imageRaster(grayscaleImg, align: PosAlign.center);

    bytes += generator.text(
      branch.name,
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size3,
        width: PosTextSize.size1,
        fontType: PosFontType.fontA,
      ),
    );

    bytes += generator.text(
      branch.address,
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );
    bytes += generator.text(
      'TELP/WA : ${branch.phone}',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: 'ORDER ID',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ': ${order.number}',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'TANGGAL',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ': $date',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'JAM',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ': $time',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'KASIR',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ': ${order.user?.name ?? '-'}',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'PEMESAN',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ': ${order.name}',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'PAYMENT',
        width: 4,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ': ${order.payment.toUpperCase()}',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);

    bytes += generator.hr();

    int totalDiscount = 0;
    int subTotal = 0;
    for (final item in order.orderItem) {
      totalDiscount += item.totalDiscount;
      subTotal += item.qty * item.price;
      bytes += generator.text(
          (item.branchMenu?.menu?.name ?? '-').toUpperCase(),
          styles: const PosStyles(align: PosAlign.left));
      bytes += generator.row([
        PosColumn(
          text: '',
          width: 1,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${item.qty} X ${item.price.currencyFormat}',
          width: 7,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: (item.price * item.qty).currencyFormatRp,
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      if (item.totalDiscount > 0) {
        bytes += generator.text(
          '-${item.totalDiscount.currencyFormat}',
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        );
      }
    }

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
        text: 'SUBTOTAL :',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: subTotal.currencyFormatRp,
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    if (totalDiscount > 0) {
      bytes += generator.row([
        PosColumn(
          text: 'DISKON :',
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: totalDiscount.currencyFormatRp,
          width: 7,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL :',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: order.total.currencyFormatRp,
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'BAYAR :',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: order.bill.currencyFormatRp,
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'KEMBALI :',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: order.returN.currencyFormatRp,
        width: 7,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.feed(1);
    bytes += generator.text('TERIMA KASIH',
        styles: const PosStyles(
          bold: false,
          align: PosAlign.center,
          width: PosTextSize.size1,
          height: PosTextSize.size3,
        ));
    bytes += generator.feed(1);

    bytes += generator.qrcode(order.number);
    bytes += generator.text(order.number,
        styles: const PosStyles(
          bold: false,
          align: PosAlign.center,
          width: PosTextSize.size1,
          height: PosTextSize.size2,
        ));
    bytes += generator.feed(4);

    return bytes;
  }
}
