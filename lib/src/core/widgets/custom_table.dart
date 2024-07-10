import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/configs/column_config.dart';
import 'package:fluttertest/src/core/services/shared_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomDataTable extends StatefulWidget {
  final Function(Map<String, dynamic>) onRowSelect;
  final List<Map<String, dynamic>> data;
  final List<ColumnConfig> columns;
  final bool isLoading;
  final Function onLoadMore;
  final int currentPage;
  final int totalCount;

  const CustomDataTable({
    Key? key,
    required this.onRowSelect,
    required this.data,
    required this.columns,
    required this.isLoading,
    required this.onLoadMore,
    required this.currentPage,
    required this.totalCount,
  }) : super(key: key);

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  late final SharedService _sharedService = SharedService();
  bool _isLoadMoreTriggered = false;

  void _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 200) {
      if (!_isLoadMoreTriggered &&
          !widget.isLoading &&
          widget.data.length < widget.totalCount) {
        _isLoadMoreTriggered = true;
        widget.onLoadMore();
      }
    } else {
      _isLoadMoreTriggered = false;
    }
  }

  String _getCellValue(dynamic data, String code) {
    return _sharedService.getValue(data, code);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        _onScrollNotification(notification);
        return false;
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              DataTable(
                columnSpacing: 20,
                // dividerThickness: 2,
                border: TableBorder.all(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                showCheckboxColumn: false,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                  color: Color(0xff42474E),
                ),
                headingRowColor: WidgetStateColor.resolveWith(
                  (states) => const Color(0xffE6E8EE),
                ),
                columns: widget.columns
                    .map((column) => DataColumn(label: column.label))
                    .toList(),
                rows: [
                  for (var entry in widget.data.asMap().entries)
                    DataRow(
                      key: ValueKey(entry.key),
                      color: WidgetStateColor.resolveWith(
                        // (states) => const Color(0xffF9FAFC),
                        (states) {
                          if (entry.key % 2 == 0) {
                            return const Color(0xffFFFFFF);
                          } else {
                            return const Color(0xffF1F4F9);
                          }
                        },
                      ),
                      onSelectChanged: (_) {
                        widget.onRowSelect(entry.value);
                      },
                      cells: widget.columns
                          .map(
                            (column) => DataCell(
                              column.code == 'status'
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: _sharedService
                                            .getBackgroundStatusColor(
                                                entry.value[column.code]),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Text(
                                        _getCellValue(entry.value[column.code],
                                            column.code),
                                        style: TextStyle(
                                          color: _sharedService.getStatusColor(
                                              entry.value[column.code]),
                                        ),
                                      ),
                                    )
                                  : Text(_getCellValue(
                                      entry.value[column.code], column.code)),
                            ),
                          )
                          .toList(),
                    ),
                  if (widget.isLoading &&
                      widget.data.length < widget.totalCount)
                    DataRow(
                      onSelectChanged: null,
                      cells: List.generate(
                        widget.columns.length,
                        (index) => DataCell(
                          Skeletonizer(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
