# Cubit

---
### What is Cubit

A Flutter library built to expose widgets that integrate with cubits

- built to work with the cubit and bloc state management packages

---
### Usage

Let's take a look at how to use CubitBuilder to hook up a CounterPage widget to a CounterCubit.
```
// counter_cubit.dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```
```
// main.dart
void main() => runApp(CubitCounter());

class CubitCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CubitProvider(
        create: (_) => CounterCubit(),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cubit Counter')),
      body: CubitBuilder<CounterCubit, int>(
        builder: (_, count) {
          return Center(
            child: Text('$count'),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: context.cubit<CounterCubit>().increment,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: context.cubit<CounterCubit>().decrement,
            ),
          ),
        ],
      ),
    );
  }
}
```

---
### Cubit Widgets
CubitBuilder is a Flutter widget which requires a Cubit and a builder function
- handles building the widget in response to new states
- very similar to StreamBuilder but has a more simple API to reduce the amount of boilerplate code needed

The builder function will potentially be called many times and should be a pure function that returns a widget in response to the state.


If the cubit parameter is omitted, CubitBuilder will automatically perform a lookup using CubitProvider and the current BuildContext.

CubitBuilder<CubitA, CubitAState>(
  builder: (context, state) {
    // return widget here based on CubitA's state
  }
)
Only specify the cubit if you wish to provide a cubit that will be scoped to a single widget and isn't accessible via a parent CubitProvider and the current BuildContext.

CubitBuilder<CubitA, CubitAState>(
  cubit: cubitA, // provide the local cubit instance
  builder: (context, state) {
    // return widget here based on CubitA's state
  }
)
For fine-grained control over when the builder function is called an optional buildWhen can be provided. buildWhen takes the previous cubit state and current cubit state and returns a boolean. If buildWhen returns true, builder will be called with state and the widget will rebuild. If buildWhen returns false, builder will not be called with state and no rebuild will occur.

CubitBuilder<CubitA, CubitAState>(
  buildWhen: (previousState, state) {
    // return true/false to determine whether or not
    // to rebuild the widget with state
  },
  builder: (context, state) {
    // return widget here based on CubitA's state
  }
)
CubitProvider is a Flutter widget which provides a cubit to its children via CubitProvider.of<T>(context). It is used as a dependency injection (DI) widget so that a single instance of a cubit can be provided to multiple widgets within a subtree.

In most cases, CubitProvider should be used to create new cubits which will be made available to the rest of the subtree. In this case, since CubitProvider is responsible for creating the cubit, it will automatically handle closing the cubit.

CubitProvider(
  create: (BuildContext context) => CubitA(),
  child: ChildA(),
);
In some cases, CubitProvider can be used to provide an existing cubit to a new portion of the widget tree. This will be most commonly used when an existing cubit needs to be made available to a new route. In this case, CubitProvider will not automatically close the cubit since it did not create it.

CubitProvider.value(
  value: CubitProvider.of<CubitA>(context),
  child: ScreenA(),
);
then from either ChildA, or ScreenA we can retrieve CubitA with:

// with extensions
context.cubit<CubitA>();

// without extensions
CubitProvider.of<CubitA>(context)
MultiCubitProvider is a Flutter widget that merges multiple CubitProvider widgets into one. MultiCubitProvider improves the readability and eliminates the need to nest multiple CubitProviders. By using MultiCubitProvider we can go from:

CubitProvider<CubitA>(
  create: (BuildContext context) => CubitA(),
  child: CubitProvider<CubitB>(
    create: (BuildContext context) => CubitB(),
    child: CubitProvider<CubitC>(
      create: (BuildContext context) => CubitC(),
      child: ChildA(),
    )
  )
)
to:

MultiCubitProvider(
  providers: [
    CubitProvider<CubitA>(
      create: (BuildContext context) => CubitA(),
    ),
    CubitProvider<CubitB>(
      create: (BuildContext context) => CubitB(),
    ),
    CubitProvider<CubitC>(
      create: (BuildContext context) => CubitC(),
    ),
  ],
  child: ChildA(),
)
CubitListener is a Flutter widget which takes a CubitWidgetListener and an optional Cubit and invokes the listener in response to state changes in the cubit. It should be used for functionality that needs to occur once per state change such as navigation, showing a SnackBar, showing a Dialog, etc...

listener is only called once for each state change (NOT including initialState) unlike builder in CubitBuilder and is a void function.

If the cubit parameter is omitted, CubitListener will automatically perform a lookup using CubitProvider and the current BuildContext.

CubitListener<CubitA, CubitAState>(
  listener: (context, state) {
    // do stuff here based on CubitA's state
  },
  child: const SizedBox(),
)
Only specify the cubit if you wish to provide a cubit that is otherwise not accessible via CubitProvider and the current BuildContext.

CubitListener<CubitA, CubitAState>(
  cubit: cubitA,
  listener: (context, state) {
    // do stuff here based on CubitA's state
  }
)
For fine-grained control over when the listener function is called an optional listenWhen can be provided. listenWhen takes the previous cubit state and current cubit state and returns a boolean. If listenWhen returns true, listener will be called with state. If listenWhen returns false, listener will not be called with state.

CubitListener<CubitA, CubitAState>(
  listenWhen: (previousState, state) {
    // return true/false to determine whether or not
    // to call listener with state
  },
  listener: (context, state) {
    // do stuff here based on CubitA's state
  },
  child: const SizedBox(),
)
MultiCubitListener is a Flutter widget that merges multiple CubitListener widgets into one. MultiCubitListener improves the readability and eliminates the need to nest multiple CubitListeners. By using MultiCubitListener we can go from:

CubitListener<CubitA, CubitAState>(
  listener: (context, state) {},
  child: CubitListener<CubitB, CubitBState>(
    listener: (context, state) {},
    child: CubitListener<CubitC, CubitCState>(
      listener: (context, state) {},
      child: ChildA(),
    ),
  ),
)
to:

MultiCubitListener(
  listeners: [
    CubitListener<CubitA, CubitAState>(
      listener: (context, state) {},
    ),
    CubitListener<CubitB, CubitBState>(
      listener: (context, state) {},
    ),
    CubitListener<CubitC, CubitCState>(
      listener: (context, state) {},
    ),
  ],
  child: ChildA(),
)
CubitConsumer exposes a builder and listener in order react to new states. CubitConsumer is analogous to a nested CubitListener and CubitBuilder but reduces the amount of boilerplate needed. CubitConsumer should only be used when it is necessary to both rebuild UI and execute other reactions to state changes in the cubit. CubitConsumer takes a required CubitWidgetBuilder and CubitWidgetListener and an optional cubit, CubitBuilderCondition, and CubitListenerCondition.

If the cubit parameter is omitted, CubitConsumer will automatically perform a lookup using CubitProvider and the current BuildContext.

CubitConsumer<CubitA, CubitAState>(
  listener: (context, state) {
    // do stuff here based on CubitA's state
  },
  builder: (context, state) {
    // return widget here based on CubitA's state
  }
)
An optional listenWhen and buildWhen can be implemented for more granular control over when listener and builder are called. The listenWhen and buildWhen will be invoked on each cubit state change. They each take the previous state and current state and must return a bool which determines whether or not the builder and/or listener function will be invoked. The previous state will be initialized to the state of the cubit when the CubitConsumer is initialized. listenWhen and buildWhen are optional and if they aren't implemented, they will default to true.

CubitConsumer<CubitA, CubitAState>(
  listenWhen: (previous, current) {
    // return true/false to determine whether or not
    // to invoke listener with state
  },
  listener: (context, state) {
    // do stuff here based on CubitA's state
  },
  buildWhen: (previous, current) {
    // return true/false to determine whether or not
    // to rebuild the widget with state
  },
  builder: (context, state) {
    // return widget here based on CubitA's state
  }
)