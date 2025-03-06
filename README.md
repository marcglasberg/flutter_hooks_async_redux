[![](./example/SponsoredByMyTextAi.png)](https://mytext.ai)

# Adds Redux to Flutter Hooks

This package uses
[flutter_hooks](https://pub.dev/packages/flutter_hooks)
and [async_redux](https://pub.dev/packages/async_redux) packages
to add Redux to flutter_hooks.

You have to add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_hooks: ^0.21.2 # or newer
  async_redux: ^24.2.2 # or newer
  flutter_hooks_async_redux: ^3.1.0 # or newer 
```

And then, all features of Flutter Hooks and Async Redux are available for you.

The hooks provided by this package are described below.

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
    useSelector<AppState, T>(converter, distinct: distinct);
```

By doing so, you simplify accessing state values. For example:

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

With `useIsWaiting` you can check if:

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

// Waiting for an action TYPE:
dispatch(MyAction());
var isWaiting = useIsWaiting(MyAction);
if (isWaiting) { // Show a spinner }

// Waiting for an ACTION:
var action = MyAction();
dispatch(action);
var isWaiting = useIsWaiting(action);
if (isWaiting) { // Show a spinner }

// Waiting for any of the given action TYPES:
dispatch(BuyAction());
var isWaiting = useIsWaiting([BuyAction, SellAction]);
if (isWaiting) { // Show a spinner }
```

## useIsFailed, useExceptionFor, useClearExceptionFor

Usage:

```
// Returns true if the action failed with an UserException:
var isFailed = useIsFailed(MyAction);
if (isFailed) { // Show an error message. }

// Returns the `UserException` of the action that failed.
var exception = useExceptionFor(MyAction);
Text(exception!.reason ?? '');

// Removes the given action from the list of action types that failed.
var clearExceptionFor = useClearExceptionFor(); 
clearExceptionFor(MyAction);
```

Note these functions accept a `ReduxAction`, an action `Type`, or
an `Iterable` of action types. Any other type of object won't work.

***

## By Marcelo Glasberg

<a href="https://glasberg.dev">_glasberg.dev_</a>
<br>
<a href="https://github.com/marcglasberg">_github.com/marcglasberg_</a>
<br>
<a href="https://www.linkedin.com/in/marcglasberg/">_linkedin.com/in/marcglasberg/_</a>
<br>
<a href="https://twitter.com/glasbergmarcelo">_twitter.com/glasbergmarcelo_</a>
<br>
<a href="https://stackoverflow.com/users/3411681/marcg">
_stackoverflow.com/users/3411681/marcg_</a>
<br>
<a href="https://medium.com/@marcglasberg">_medium.com/@marcglasberg_</a>
<br>

*My article in the official Flutter documentation*:

* <a href="https://flutter.dev/docs/development/ui/layout/constraints">Understanding
  constraints</a>

*The Flutter packages I've authored:*

* <a href="https://pub.dev/packages/async_redux">async_redux</a>
* <a href="https://pub.dev/packages/provider_for_redux">provider_for_redux</a>
* <a href="https://pub.dev/packages/i18n_extension">i18n_extension</a>
* <a href="https://pub.dev/packages/align_positioned">align_positioned</a>
* <a href="https://pub.dev/packages/network_to_file_image">network_to_file_image</a>
* <a href="https://pub.dev/packages/image_pixels">image_pixels</a>
* <a href="https://pub.dev/packages/matrix4_transform">matrix4_transform</a>
* <a href="https://pub.dev/packages/back_button_interceptor">back_button_interceptor</a>
* <a href="https://pub.dev/packages/indexed_list_view">indexed_list_view</a>
* <a href="https://pub.dev/packages/animated_size_and_fade">animated_size_and_fade</a>
* <a href="https://pub.dev/packages/assorted_layout_widgets">assorted_layout_widgets</a>
* <a href="https://pub.dev/packages/weak_map">weak_map</a>
* <a href="https://pub.dev/packages/themed">themed</a>
* <a href="https://pub.dev/packages/bdd_framework">bdd_framework</a>
* <a href="https://pub.dev/packages/tiktoken_tokenizer_gpt4o_o1">
  tiktoken_tokenizer_gpt4o_o1</a>

*My Medium Articles:*

* <a href="https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6">
  Async Redux: Flutter’s non-boilerplate version of Redux</a> 
  (versions: <a href="https://medium.com/flutterando/async-redux-pt-brasil-e783ceb13c43">
  Português</a>)
* <a href="https://medium.com/flutter-community/i18n-extension-flutter-b966f4c65df9">
  i18n_extension</a> 
  (versions: <a href="https://medium.com/flutterando/qual-a-forma-f%C3%A1cil-de-traduzir-seu-app-flutter-para-outros-idiomas-ab5178cf0336">
  Português</a>)
* <a href="https://medium.com/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2">
  Flutter: The Advanced Layout Rule Even Beginners Must Know</a> 
  (versions: <a href="https://habr.com/ru/post/500210/">русский</a>)
* <a href="https://medium.com/flutter-community/the-new-way-to-create-themes-in-your-flutter-app-7fdfc4f3df5f">
  The New Way to create Themes in your Flutter App</a> 
