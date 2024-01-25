enum EventState { pending, ongoing, completed }

extension EventStateExtension on EventState {
  String get value {
    switch (this) {
      case EventState.pending:
        return "Pendiente";
      case EventState.ongoing:
        return "En curso";
      case EventState.completed:
        return "Finalizado";
      default:
        return "Desconocido";
    }
  }
}
