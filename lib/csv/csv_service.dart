import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:universal_html/html.dart';
import 'package:universal_platform/universal_platform.dart';

import '../coherent_combine/coherent_combine_viewModel.dart';

final csvServiceProvider = Provider((ref) => const CSVService());

class CSVService {
  const CSVService();

  void csvDownload({
    required List<String> header,
    required List<ChartData> chartData,
    //required List<List<String>> rows,
    bool utf8BOM = false,
  }) {
    final isWeb = UniversalPlatform.isWeb;
    if (isWeb) {
      AnchorElement anchorElement;
      final rows = chartData.map((d) => d.toCsvFormat()).toList();

      if (utf8BOM) {
        //　Excelで開く用に日本語を含む場合はUTF-8 BOMにする措置
        // ref. https://github.com/close2/csv/issues/41#issuecomment-899038353
        final csv = const ListToCsvConverter(fieldDelimiter: ';').convert(
          [header, ...rows],
        );
        final bomUtf8Csv = [0xEF, 0xBB, 0xBF, ...utf8.encode(csv)];
        final base64CsvBytes = base64Encode(bomUtf8Csv);
        anchorElement = AnchorElement(
          href: 'data:text/plain;charset=utf-8;base64,$base64CsvBytes',
        );
      } else {
        final csv = const ListToCsvConverter().convert(
          [header, ...rows],
        );
        anchorElement = AnchorElement(
          href: 'data:text/plain;charset=utf-8,$csv',
        );
      }
      anchorElement
        ..setAttribute('download', '${header.first}.csv')
        ..click();
    }
  }
}
