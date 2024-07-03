import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pvtb/domain/usecase/delete_record.dart';
import 'package:pvtb/domain/usecase/get_records.dart';

class Data extends StatefulWidget {
  final GetRecords _getRecords;
  final DeleteRecord _deleteRecord;
  const Data(this._getRecords, this._deleteRecord, {super.key});
  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  late final _future = widget._getRecords().runFuture();
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      child: FutureBuilder(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<IMap<DateTime, IList<int>>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data!;
                  return DataTable(columns: const <DataColumn>[
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Score')),
                    DataColumn(label: Text('RT(ms)')),
                    DataColumn(label: Text(''))
                  ], rows: <DataRow>[
                    for (final element in data.entries)
                      DataRow(cells: <DataCell>[
                        DataCell(Text(element.key.toString())),
                        DataCell(Text('${element.value.first}%')),
                        DataCell(Text(element.value.last.toString())),
                        DataCell(IconButton(
                            onPressed: () {
                              widget._deleteRecord(element.key).runFuture();
                              setState(() => data.remove(element.key));
                            },
                            icon: const Icon(Icons.delete)))
                      ])
                  ]);
                }
            }
          }));
}
