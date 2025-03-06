import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_hooks_async_redux/flutter_hooks_async_redux.dart';

class AppState {
  final int counter;

  const AppState({this.counter = 0});
}

T useAppState<T>(T Function(AppState state) converter, {bool distinct = true}) =>
    useSelector<AppState, T>(converter, distinct: distinct);

void main() {
  runApp(
    MaterialApp(
      home: StoreProvider<AppState>(
        store: Store<AppState>(initialState: const AppState()),
        child: const Application(),
      ),
    ),
  );
}

class Application extends HookWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    int counter = useAppState((state) => state.counter);
    var isWaitingIncrement = useIsWaiting(IncrementAction);

    useEffect(() {
      dispatch(SetCounter(42));

      return;
    }, []);

    return Scaffold(
      body: Center(
        child: Text('Counter is $counter'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            disabledElevation: 0,
            onPressed: isWaitingIncrement ? null : () => dispatch(IncrementAction()),
            child: isWaitingIncrement ? const CircularProgressIndicator() : const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            child: const Icon(Icons.clear),
            onPressed: () {
              dispatch(ResetCounter());
            },
          ),
        ],
      ),
    );
  }
}

class IncrementAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AppState(counter: state.counter + 1);
  }
}

class SetCounter extends ReduxAction<AppState> {
  final int value;

  SetCounter(this.value);

  @override
  AppState reduce() => AppState(counter: value);
}

class ResetCounter extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return const AppState();
  }
}
