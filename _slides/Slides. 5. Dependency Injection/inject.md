# Inject

---
### Dependency Injection
Dependency Injection (DI) is a design pattern used to implement Inversion of Control. 


It brings a higher level of flexibility, decoupling, and easier testing.


---
### Why 
Why would you even need to use DI?

consider the following class:
```
class Car {  
   private Wheel wheel = Wheel()    
   
   drive() {    
      wheel.spin()  
   }
}
```

---
### Problems
it presents two main problems
- impossible to mock the wheel to test the Car class in isolation.
- if you had a SteelWheel and a PlasticWheel it would not be possible to interchange them without changing the consumer

---
### Solution
Provide the Wheel so the car can make use of it instead, like so
```
class Car() { 
   // database instance
   final Wheel _wheel;
   // Constructor
   Car(this._wheel);
   drive() {   
      wheel.spin() 
   }
}
```

It’s easy to see why class with many dependencies can get out of hand very fast following the first path!


---
### Dependency Injection in Flutter
Dependency Injection is a simple pattern but often times libraries are used to abstract it away from the developer.

Many DI libraries use reflection (mirrors in Dart)
In Flutter however, Mirrors are disabled for performance reasons

---
### Inject Library

Inject uses the following annotations
- @Injector: A inversion of control container constructed from a builder or a set of modules
- @Module and @Provides: define classes and methods which provide dependencies
- @Component: enable selected modules and used for performing dependency injection


---
### Installation
As there’s no package in official repository, we have to install it manually

in pubspec.yaml 
```
dependencies:
 inject:
 git:
 url: https://github.com/google/inject.dart.git
 path: package/inject
dev_dependencies:
 build_runner: ^1.3.0
inject_generator:
 git:
 url: https://github.com/google/inject.dart.git
 path: package/inject_generator
```

---
### Usage

Concrete class injection
```
import ‘package:inject/inject.dart’;
@provide
class StepService {
   // implementation
}
```
We can use it e.g. with Flutter widgets like this:
```
@provide
class SomeWidget extends StatelessWidget {
   final StepService _service;
   SomeWidget(this._service);
}
```

---
### Usage (2)
Interface injection

First of all we need to define an abstract class with some implementation class, e.g.
```
abstract class UserRepository {
  Future<List<User>> allUsers();
}
class FirestoreUserRepository implements UserRepository {
   @override
   Future<List<User>> allUsers() {
   // implementation
   }
}
```
And now we can provide dependencies in our module
```
import ‘package:inject/inject.dart’;
@module
class UsersServices {
   @provide
   UserRepository userRepository() => FirestoreUserRepository();
}
```

---
### Providers
What to do if we need not an instance of some class to be injected, but rather a provider, that will give us a new instance of this class each time? 

Or if we need to resolve the dependency lazily instead of getting concrete instance in the constructor? 

```
typedef Provider<T> = T Function();
```
and use it in our classes
```
@provide
class SomeWidget extends StatelessWidget {
   final Provider<StepService> _service;
SomeWidget(this._service);
void _someFunction() {
   final service = _service();
   // use service
   }
}
```

---
### Assisted injection
There’s no built-in functionality to inject objects that require arguments known at runtime only, so we can use the common pattern with factories in this case

- create a factory class that takes all the compile-time dependencies in constructor
- inject it
- provide a factory method with runtime argument that will create a required instance.

---
### Wiring it up
The final step in order to make everything work is to create an injector (aka component from Dagger), e.g. like this

```
import ‘main.inject.dart’ as g;
@Injector(const [UsersServices, DateResultsServices])
abstract class Main {
   @provide
   MyApp get app;
   static Future<Main> create(
     UsersServices usersModule,
     DateResultsServices dateResultsModule,
   ) async {
     return await g.Main$Injector.create(
       usersModule,
       dateResultsModule,
     );
   }
}
```

Here UserService and DateResultsServices are previously defined modules

MyApp is the root widget of our application, and main.inject.dart is an auto-generated file (more on this later).

---
### Wiring it up

Now we can define our main function like this
```
void main() async {
   var container = await Main.create(
      UsersServices(),
      DateResultsServices(),
   );
   runApp(container.app);
}
```


---
### Running
As inject works with code generation, we need to use build runner to generate the required code. We can use this command
```
flutter packages pub run build_runner build
```
or watch command in order to keep the source code synced automatically
```
flutter packages pub run build_runner watch
```

But there’s one important moment here: by default, the code will be generated into the cache folder and Flutter don’t currently support this (though there’s a work in progress in order to solve this problem). So we need to add the file inject_generator.build.yaml with the following content:
builders:
 inject_generator:
 target: “:inject_generator”
 import: “package:inject_generator/inject_generator.dart”
 builder_factories:
 — “summarizeBuilder”
 — “generateBuilder”
 build_extensions:
 “.dart”:
 — “.inject.summary”
 — “.inject.dart”
 auto_apply: dependents
 build_to: source
It’s actually the same content as in file inject.dart/package/inject_generator/build.yaml except for one line: build_to: cache has been replaced with `build_to: source`.
Now we can run the build_runner, it will generate the required code (and provide error messages if some dependencies cannot be resolved) and after that, we can run Flutter build as usual.
Useful Resources:
You should check the examples provided with the library itself, and if you have some experience with Dagger library, inject will be really very familiar to you.
You should also check the boilerplate project implemented using inject the library