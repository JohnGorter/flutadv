# Dependency Injection

---
### Dependency Injection in Flutter
The default way to provide object/services to widgets is through InheritedWidgets
- the consumer widget has to be a child of the inherited widget, which causes unnecessary nesting


---
### get_it

> An IoC that allows you to register your class types and request it from anywhere you have access to the container

---
### get_it 
Typical usage:
- Accessing service objects like REST API clients or databases so that they easily can be mocked.
- Accessing View/AppModels/Managers/BLoCs from Flutter Views

---
### Why GetIt 
As your App grows, at some point your app's logic goes into classes that are separated from your Widgets.
Keeping your widgets from having direct dependencies makes your code better organized and easier to test and maintain.

But now you need a way to access these objects from your UI code!

---
### Why not a singleton
With a Singleton 
- you can't easily switch the implementation out for a mock version in tests

---
### get_it
GetIt
- is extremely fast (O(1))
- is easy to learn/use
- doesn't clutter your UI tree with special Widgets to access your data like provider or Redux does

- isn't a state management solution! It's just a locator for your objects

---
### Getting Started 
At your start-up you register all the objects you want to access later like this:
```
final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AppModel>(AppModel());

// Alternatively you could write it if you don't like global variables
  GetIt.I.registerSingleton<AppModel>(AppModel());
}
```
After that you can access your AppModel class from anywhere like this:
```
MaterialButton(
  child: Text("Update"),
  onPressed: getIt<AppModel>().update   // given that your AppModel has a method update
),
```
---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo get_it

---
### GetIt in Detail 

GetIt itself is a singleton and the default way to access an instance of GetIt is to call:
```
GetIt getIt = GetIt.instance;

//There is also a shortcut (if you don't like it just ignore it):
GetIt getIt = GetIt.I;
```

---
### GetIt in Detail 

Before you can access your objects you have to register them within GetIt typically direct in your start-up code.
```
getIt.registerSingleton<AppModel>(AppModelImplementation());
getIt.registerLazySingleton<RESTAPI>(() =>RestAPIImplementation());

// if you want to work just with the singleton:
GetIt.instance.registerSingleton<AppModel>(AppModelImplementation());
GetIt.I.registerLazySingleton<RESTAPI>(() =>RestAPIImplementation());

/// `AppModel` and `RESTAPI` are both abstract base classes in this example
```

---
### GetIt in Detail 

To access the registered objects call get<Type>() on your GetIt instance
```
var myAppModel = getIt.get<AppModel>();
```
Alternatively as GetIt is a callable class depending on the name you choose for your GetIt instance you can use the shorter version:
```
var myAppModel = getIt<AppModel>();
// as Singleton:
var myAppModel = GetIt.instance<AppModel>();
var myAppModel = GetIt.I<AppModel>();
```

---
### Different ways of registration 
GetIt offers different ways how objects are registered that effect the lifetime of this objects.

- Factory
  - pass a factory function func that returns an NEW instance of an implementation of T
- Singleton & LazySingleton
  - pass an instance of T or a derived class of T that you will always get returned on a call to get<T>()

As creating this instance can be time consuming at app start-up you can shift the creation to the time the object is the first time requested with:
```
void registerLazySingleton<T>(FactoryFunc<T> func)
```
You have to pass a factory function func that returns an instance of an implementation of T

---
### Overwriting registrations 
If you try to register a type more than once 
- an assertion in debug mode (probably a bug). 

If you really have to overwrite a registration -> allowReassignment==true

---
### Testing if a Singleton is already registered 
You can check if a certain Type or instance is already registered in GetIt with:
```
 /// Tests if an [instance] of an object or aType [T] or a name [instanceName]
 /// is registered inside GetIt
 bool isRegistered<T>({Object instance, String instanceName});
```

---
### Unregistering Singletons or Factories 
If you need to you can also unregister your registered singletons and factories and pass a optional disposingFunction for clean-up.
```
/// Unregister an [instance] of an object or a factory/singleton by Type [T] or by name [instanceName]
/// if you need to dispose some resources before the reset, you can
/// provide a [disposingFunction]. This function overrides the disposing
/// you might have provided when registering.
void unregister<T>({Object instance,String instanceName, void Function(T) disposingFunction})
```

---
### Resetting LazySingletons 
In some cases you might not want to unregister a LazySingleton but instead to reset its instance so that it gets newly created on the next access to it.
```
  /// Clears the instance of a lazy singleton,
  /// being able to call the factory function on the next call
  /// of [get] on that type again.
  /// you select the lazy Singleton you want to reset by either providing
  /// an [instance], its registered type [T] or its registration name.
  /// if you need to dispose some resources before the reset, you can
  /// provide a [disposingFunction]. This function overrides the disposing
  /// you might have provided when registering.
void resetLazySingleton<T>({Object instance,
                            String instanceName,
                            void Function(T) disposingFunction})
```

---
### Resetting GetIt completely 
```
/// Clears all registered types. Handy when writing unit tests
/// If you provided dispose function when registering they will be called
/// [dispose] if `false` it only resets without calling any dispose
/// functions
/// As dispose funcions can be async, you should await this function.
Future<void> reset({bool dispose = true});
```

---
### Scopes 
Hierarchical scoping of registration
 - push a new registration scope -> any registration after that will be registered in this new scope
 - when accessing an object with get GetIt first checks the topmost scope for an registration and then the ones below
 
This means you can register the same type that was already registered in a lower scope again in a scope above and you will always get the latest registered object.

---
### Scopes, an example

Imagine an app that can be used with or without a login. On App start-up a DefaultUser object is registered with the abstract type User as singleton. As soon as the user logs in, a new scope is pushed and a new LoggedInUser object again with the User type is registered that allows more functions. For the rest of the App nothing has changed as it still accesses User objects through GetIt. As soon as the user Logs off all you have to do is pop the Scope and automatically the DefaultUser is used again

Another example could be a shopping basket where you want to ensure that not a cart from a previous session is used again. So at the beginning of a new session you push a new scope and register a new cart object. At the end of the session you pop this scope again.

---
### Scope functions 
```
  /// Creates a new registration scope. If you register types after creating
  /// a new scope they will hide any previous registration of the same type.
  /// Scopes allow you to manage different live times of your Objects.
  /// [scopeName] if you name a scope you can pop all scopes above the named one
  /// by using the name.
  /// [dispose] function that will be called when you pop this scope. The scope
  /// is still valied while it is executed
  /// [init] optional function to register Objects immediately after the new scope is
  /// pushed. This ensures that [onScopeChanged] will be called after their registration
  void pushNewScope({void Function(GetIt getIt)? init,String scopeName, ScopeDisposeFunc dispose});

  /// Disposes all factories/Singletons that have ben registered in this scope
  /// and pops (destroys) the scope so that the previous scope gets active again.
  /// if you provided  dispose functions on registration, they will be called.
  /// if you passed a dispose function when you pushed this scope it will be
  /// calles before the scope is popped.
  /// As dispose funcions can be async, you should await this function.
  Future<void> popScope();

  /// if you have a lot of scopes with names you can pop (see [popScope]) all
  /// scopes above the scope with [name] including that scope
  /// Scopes are poped in order from the top
  /// As dispose funcions can be async, you should await this function.
  /// it no scope with [name] exists, nothing is popped and `false` is returned
  Future<bool> popScopesTill(String name);

  /// Clears all registered types for the current scope
  /// If you provided dispose function when registering they will be called
  /// [dispose] if `false` it only resets without calling any dispose
  /// functions
  /// As dispose funcions can be async, you should await this function.
  Future<void> resetScope({bool dispose = true});
```

---
### Getting notified about the shadowing state of an object
In some cases it might be helpful to know if an Object gets shadowed by another one 
- clean up or cancel listener just before shadow
- restart listening when activated

For this a class had to implement the ShadowChangeHandlers interface:
```
abstract class ShadowChangeHandlers {
  void onGetShadowed(Object shadowing);
  void onLeaveShadow(Object shadowing);
}
```
- when the Object is shadowed its onGetShadowed() method is called with the object that is shadowing it. 
- when this object is removed from GetIt onLeaveShadow() will be called.

---
### Getting notified when a scope change happens
When using scopes with objects that shadow other objects its important to give the UI a chance to rebuild and acquire references to the now active objects. For this you can register an call-back function in GetIt The getit_mixin has a matching rebuiltOnScopeChange method.
```
  /// Optional call-back that will get call whenever a change in the current scope happens
  /// This can be very helpful to update the UI in such a case to make sure it uses
  /// the correct Objects after a scope change
  void Function(bool pushed)? onScopeChanged;
```

---
### Disposing Singletons and Scopes 
You can pass a dispose function when registering any Singletons
```
DisposingFunc<T> dispose
```
where DisposingFunc is defined as
```
typedef DisposingFunc<T> = FutureOr Function(T param);
```

So you can pass simple or async functions as this parameter. 

This function is called when you pop or reset the scope or when you reset GetIt completely.


---
### Implementing the Disposable interface
Instead of passing a disposing function on registration or when pushing a Scope your objects onDispose() method will be called if the object that you register implements the Disposable´interface:

```
abstract class Disposable {
  FutureOr ondDispose();
}
```

---
### Asynchronous Factories 
If a factory needs to call an async function you can use registerFactoryAsync()
```
/// [T] type to register
/// [func] factory function for this type
/// [instanceName] if you provide a value here your factory gets registered with that
/// name instead of a type. This should only be necessary if you need to register more
/// than one instance of one type. Its highly not recommended
void registerFactoryAsync<T>(FactoryFuncAsync<T> func, {String instanceName});
```

To access instances created by such a factory you have to use getAsync() 
```
/// Returns an Future of an instance that is created by an async factory or a Singleton that is
/// not ready with its initialization.
Future<T> getAsync<T>([String instanceName]);
```

---
### Asynchronous Singletons 
Additionally you can register asynchronous Singletons 

```
  void registerSingletonAsync<T>(FactoryFuncAsync<T> factoryfunc,
      {String instanceName,
      Iterable<Type> dependsOn,
      bool signalsReady = false});
```
The difference to a normal Singleton is that you don't pass an existing instance but provide an factory function that returns a Future that completes at the end of factoryFunc and signals that the Singleton is ready to use unless true is passed for signalsReady

To synchronize with other "async Singletons" you can pass a list of Types in dependsOn that have to be ready before the passed factory is executed

---
### Using async Singletons 
If you register any async Singletons allReady will complete only after all of them have completed their factory functions. Like:
```
  class RestService {
    Future<RestService> init() async {
      Future.delayed(Duration(seconds: 1));
      return this;
    }
  }

  final getIt = GetIt.instance;

  /// in your setup function:
  getIt.registerSingletonAsync<ConfigService>(() async {
    final configService = ConfigService();
    await configService.init();
    return configService;
  });

  getIt.registerSingletonAsync<RestService>(() async => RestService().init());
  // here we asume an async factory function `createDbServiceAsync`
  getIt.registerSingletonAsync<DbService>(createDbServiceAsync);


  /// ... in your startup page:
  return FutureBuilder(
      future: getIt.allReady(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text('The first real Page of your App'),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      });
```
The above example shows you different ways to register async Singletons. The start-up page will display a CircularProgressIndicator until all services have been created.

---
### Solving dependencies 
- Automatic using dependsOn 
```
  getIt.registerSingletonAsync<ConfigService>(() async {
    final configService = ConfigService();
    await configService.init();
    return configService;
  });

  getIt.registerSingletonAsync<RestService>(() async => RestService().init());

  getIt.registerSingletonAsync<DbService>(createDbServiceAsync,
      dependsOn: [ConfigService]);

  getIt.registerSingletonWithDependencies<AppModel>(
      () => AppModelImplmentation(),
      dependsOn: [ConfigService, DbService, RestService]);
```
When using dependsOn you ensure that the registration waits with creating its singleton on the completion of the type defined in dependsOn.

---
### Solving dependencies 
The dependsOn field also accepts InitDependency classes that allow specifying the dependency by type and instanceName.
```
  getIt.registerSingletonAsync<RestService>(() async => RestService().init(), instanceName:"rest1");

  getIt.registerSingletonWithDependencies<AppModel>(
      () => AppModelImplmentation(),
      dependsOn: [InitDependency(RestService, instanceName:"rest1")]);
```

---
### Manually signalling the ready state of a Singleton 
Sometimes the mechanism of dependsOn might not give you enough control. For this case you can use isReady to wait for a certain singleton:
```
  /// Returns a Future that completes if the instance of an Singleton, defined by Type [T] or
  /// by name [instanceName] or by passing the an existing [instance], is ready
  /// If you pass a [timeout], an [WaitingTimeOutException] will be thrown if the instance
  /// is not ready in the given time. The Exception contains details on which Singletons are
  /// not ready at that time.
  /// [callee] optional parameter which makes debugging easier. Pass `this` in here.
  Future<void> isReady<T>({
    Object instance,
    String instanceName,
    Duration timeout,
    Object callee,
  });
```
To signal that a singleton is ready it can use signalReady, provided you have set the optional signalsReady parameter when registering it OR make your registration type implement the empty abstract class WillSignalReady. Otherwise, allReady will wait on a call to signalsReady. No automatic signaling will happen in that case.
```
/// Typically this is used in this way inside the registered objects init
/// method `GetIt.instance.signalReady(this);`
void signalReady(Object instance);
```
You can use this to initialize your Singletons without async registration by using a fire and forget async function from your constructors like so:
```
class ConfigService {
  ConfigService()
  {
    init();
  }
  Future init() async {
    // do your async initialisation...

    GetIt.instance.signalReady(this);
  }
}
```

Using allReady repeatedly 
Even if you already have awaited allReady, the moment you register new async singletons or singletons with dependencies you can use allReady again. This makes especially sense if you uses scopes where every scope needs to get initialized.

Manual triggering allReady (almost deprecated) 
By calling signalReady(null) on your GetIt instance the Future you can get from allReady will be completed. This is the most basic way to synchronize your start-up. If you want to do that don't use signalsReady or async Singletons!!! I recommend using one of the other ways because they are more flexible and express your intention more clear.

You can find here a detailed blog post on async factories and startup synchronization

Passing Parameters to factories 
In some cases its handy if you could pass changing values to factories when calling get(). For that there are two variants for registering factories:

/// registers a type so that a new instance will be created on each call of [get] on that type based on
/// up to two parameters provided to [get()]
/// [T] type to register
/// [P1] type of  param1
/// [P2] type of  param2
/// if you use only one parameter pass void here
/// [factoryfunc] factory function for this type that accepts two parameters
/// [instanceName] if you provide a value here your factory gets registered with that
/// name instead of a type. This should only be necessary if you need to register more
/// than one instance of one type. Its highly not recommended
///
/// example:
///    getIt.registerFactoryParam<TestClassParam,String,int>((s,i)
///        => TestClassParam(param1:s, param2: i));
///
/// if you only use one parameter:
///
///    getIt.registerFactoryParam<TestClassParam,String,void>((s,_)
///        => TestClassParam(param1:s);
void registerFactoryParam<T,P1,P2>(FactoryFuncParam<T,P1,P2> factoryfunc, {String instanceName});

and

  void registerFactoryParamAsync<T,P1,P2>(FactoryFuncParamAsync<T,P1,P2> factoryfunc, {String instanceName});
The reason why I settled to use two parameters is that I can imagine some scenarios where you might want to register a builder function for Flutter Widgets that need to get passed a BuildContext and some data object.

When accessing these factories you pass the parameters a optional arguments to get():

  var instance = getIt<TestClassParam>(param1: 'abc',param2:3);
These parameters are passed as dynamics (otherwise I would have had add more generic parameters to get()), but they are checked at runtime to be the correct types.

Testing with GetIt 
Unit Tests 
When you are writing unit tests with GetIt in your App you have two possibilities:

Register all the Objects you need inside your unit Tests so that GetIt can provide its objects to the objects that you are testing.
Pass your dependent objects into the constructor of your test objects like:
GetIt getIt = GetIt.instance;

class UserManager {
  AppModel appModel;
  DbService dbService;

  UserManager({AppModel appModel, DbService dbService}) {
    this.appModel = appModel ?? getIt.get<AppModel>();
    this.dbService = dbService ?? getIt.get<DbService>();
  }
}
This way you don't need to pass them in the AppModel and dbService inside your App but you can pass them(or a mocked version) in your Unit tests.

Integration Tests 
If you have a mocked version of a Service, you can easily switch between that and the real one based on a flag:

  if (testing) {
    getIt.registerSingleton<AppModel>(AppModelMock());
  } else {
    getIt.registerSingleton<AppModel>(AppModelImplementation());
  }
Experts region 
Named registration 
Ok you have been warned! All registration functions have an optional named parameter instanceName. Providing a name with factory/singleton here registers that instance with that name and a type. Consequently get() has also an optional parameter instanceName to access factories/singletons that were registered by name.

IMPORTANT: Each name must be unique per type.

  abstract class RestService {}
  class RestService1 implements RestService{
    Future<RestService1> init() async {
      Future.delayed(Duration(seconds: 1));
      return this;
    }
  }
  class RestService2 implements RestService{
    Future<RestService2> init() async {
      Future.delayed(Duration(seconds: 1));
      return this;
    }
  }

  getIt.registerSingletonAsync<RestService>(() async => RestService1().init(), instanceName : "restService1");
  getIt.registerSingletonAsync<RestService>(() async => RestService2().init(), instanceName : "restService2");

  getIt.registerSingletonWithDependencies<AppModel>(
      () {
          RestService restService1 = GetIt.I.get<RestService>(instanceName: "restService1");
          return AppModelImplmentation(restService1);
      },
      dependsOn: [InitDependency(RestService, instanceName:"restService1")],
  );
More than one instance of GetIt 
While not recommended, you can create your own independent instance of GetItif you don't want to share your locator with some other package or because the physics of your planet demands it :-)

/// To make sure you really know what you are doing
/// you have to first enable this feature:
GetIt myOwnInstance = GetIt.asNewInstance();
This new instance does not share any registrations with the singleton instance.