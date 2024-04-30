import 'package:anki_visualizer/models/export_options.dart';
import 'package:flutter/material.dart';

import '../../core/functions.dart';
import '../basic/padded_column.dart';

class ExportOptionsForm extends StatefulWidget {
  final void Function(ExportOptions) onPressExport;
  final ExportOptions? initialExportOptions;
  final bool isExportReady;

  const ExportOptionsForm({
    super.key,
    required this.onPressExport,
    this.initialExportOptions,
    required this.isExportReady,
  });

  @override
  State<ExportOptionsForm> createState() => _ExportOptionsFormState();
}

class _ExportOptionsFormState extends State<ExportOptionsForm> {
  final _formKey = GlobalKey<FormState>();

  late ExportFormat exportFormat;
  late TextEditingController framerateController;

  @override
  void initState() {
    super.initState();
    exportFormat = widget.initialExportOptions?.format ?? ExportFormat.gif;
    framerateController = TextEditingController(text: widget.initialExportOptions?.framerate.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: PaddedColumn(
        padding: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Frame rate"),
              SizedBox(
                width: 400,
                child: TextFormField(
                  controller: framerateController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    suffixText: "fps",
                    suffixStyle: Theme.of(context).textTheme.displaySmall,
                  ),
                  validator: validatePositiveInteger,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Output format"),
              DropdownButton<ExportFormat>(
                value: exportFormat,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      exportFormat = value;
                    });
                  }
                },
                items: ExportFormat.values
                    .map(
                      (e) => DropdownMenuItem<ExportFormat>(
                        value: e,
                        child: Text(
                          e.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.displayLarge),
              onPressed: widget.isExportReady ? _submitForm : null,
              child: const Text("Export"),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final options = ExportOptions(format: exportFormat, framerate: int.parse(framerateController.text));
      widget.onPressExport(options);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the information again')),
      );
    }
  }
}
