# Adds Redux to Flutter Hooks

This package uses
[flutter_hooks](https://pub.dev/packages/flutter_hooks)
and [async_redux](https://pub.dev/packages/async_redux) packages
to add Redux to flutter_hooks.

You have to add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_hooks: ^0.20.5 # or newer
  async_redux: ^22.4.0 # or newer
  flutter_hooks_async_redux: ^1.0.0 # or newer 
```

And then, all features of Flutter Hooks and Async Redux are available for you,
including the ones provided by this package, as described below.

## useSelector

`useSelector` lets you select a part of the state and subscribe to updates.

You should give it a function that gets the sate and returns only the part of the state that the
widget needs.

Example:

```
String username 
   = useSelector<AppState, String>((state) => state.username);
```

Note: If your state is called `AppState`, you can define your own `useAppState` hook,
like this:

```dart
T useAppState<T>(T Function(AppState state) converter, {bool distinct = true}) =>
    useSelector<T, AppState>(converter, distinct: distinct);
```

This will simplify the use of the hook, like this:

```
String username = useAppState((state) => state.username);
```

## useDispatch

`useDispatch` dispatches the action, applying its reducer, and possibly changing the store state.
The action may be sync or async.

```
var dispatch = useDispatch()
dispatch(new MyAction());
```

## useDispatchAndWait

`useDispatchAndWait` dispatches the action, applying its reducer, and possibly changing the store
state. The action may be sync or async. In both cases, it returns a `Future` that resolves when
the action finishes.

```
var dispatchAndWait = useDispatchAndWait();
var dispatch = useDispatch();
await dispatchAndWait(DoThisFirstAction());
store.dispatch(DoThisSecondAction());
```

Note: While the state change from the action's reducer will have been applied when the
Future resolves, other independent processes that the action may have started may still
be in progress.

Note `useDispatchAndWait` returns `Future<ActionStatus>`,
which means you can also get the final status of the action after you `await` it:

```
var status = await dispatchAndWait(MyAction());
```

## useDispatchSync

Dispatches the action, applying its reducer, and possibly changing the store state.
However, if the action is ASYNC, it will throw a `StoreException`.

```
var dispatch = useDispatchSync();
useDispatchSync(MyAction());
```

## useIsWaiting

You can use `isWaiting` and pass it `actionOrActionTypeOrList` to check if:

* A specific async ACTION is currently being processed.
* An async action of a specific TYPE is currently being processed.
* If any of a few given async actions or action types is currently being processed.

If you wait for an action TYPE, then it returns false when:

- The ASYNC action of the type is NOT currently being processed.
- If the type is not really a type that extends `ReduxAction`.
- The action of the type is a SYNC action (since those finish immediately).

If you wait for an ACTION, then it returns false when:

- The ASYNC action is NOT currently being processed.
- If the action is a SYNC action (since those finish immediately).

Trying to wait for any other type of object will return null and throw
a `StoreException` after the async gap.

Examples:

```
var dispatch = useDispatch();
var isWaiting = useIsWaiting();

// Waiting for an action TYPE:
dispatch(MyAction());
if (isWaiting(MyAction)) { // Show a spinner }

// Waiting for an ACTION:
var action = MyAction();
dispatch(action);
if (isWaiting(action)) { // Show a spinner }

// Waiting for any of the given action TYPES:
dispatch(BuyAction());
if (isWaiting([BuyAction, SellAction])) { // Show a spinner }
```

## useFailed

Usage:

```
var (isFailed, exceptionFor, clearExceptionFor) = useFailed();
```

You use it like this:

```
// Returns true if the action failed with an UserException:
if (isFailed(MyAction)) { // Show an error message. }

// Returns the `UserException` of the action that failed.
if (isFailed(MyAction)) Text(exceptionFor(MyAction)!.reason ?? '');

// Removes the given action from the list of action types that failed.
clearExceptionFor(MyAction);
```

Note these functions accept a `ReduxAction`, an action `Type`, or
an `Iterable` of action types. Any other type of object won't work.

You can also use `useIsFailed`, `useExceptionFor` and `useClearExceptionFor`
separately, if you prefer:

```
var isFailed = useIsFailed();
var exceptionFor = useExceptionFor();
var clearExceptionFor = useClearExceptionFor();
```
