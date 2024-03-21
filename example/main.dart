import 'package:flutter_hooks_async_redux/flutter_hooks_async_redux.dart';

class AppState {
  final String username;

  const AppState({this.username = ''});
}

T useAppState<T>(T Function(AppState state) converter, {bool distinct = true}) =>
    useSelector<AppState, T>(converter, distinct: distinct);

void main() {
  var state = useAppState((state) => state);
}
