import 'package:flutter/material.dart';

class GenericStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncWidgetBuilder<T> builder;
  final String errorMessage;
  final String emptyMessage;

  const GenericStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
    this.errorMessage = 'Error al cargar los datos.',
    this.emptyMessage = 'No hay datos disponibles.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(errorMessage);
        } else if (snapshot.hasData) {
          return builder(context, snapshot);
        } else {
          return Text(emptyMessage);
        }
      },
    );
  }
}
