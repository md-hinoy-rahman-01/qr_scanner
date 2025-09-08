import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 Needed for Clipboard
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const QRScanner());
}

class QRScanner extends StatelessWidget {
  const QRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      theme: ThemeData.dark(),
      home: const QRScannerHome(),
    );
  }
}

class QRScannerHome extends StatefulWidget {
  const QRScannerHome({super.key});

  @override
  State<QRScannerHome> createState() => _QRScannerHomeState();
}

class _QRScannerHomeState extends State<QRScannerHome> {
  String scannedText = 'Scan a QR code';

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: scannedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rapid QR Scanner')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() {
                    scannedText = barcode.rawValue ?? 'No data found';
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  scannedText,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}