# Dependency Injection

---
### Dependency Injection in Flutter
The default way to provide object/services to widgets is through InheritedWidgets
- the consumer widget has to be a child of the inherited widget, which causes unnecessary nesting


---
### get_it

> An IoC that allows you to register your class types and request it from anywhere you have access to the container

---
### get_it Implementation
In your pubspec add the dependency for get_it
```
  # dependency injection
  get_it: ^1.0.3
```

---
### get_it Implementation
In your lib folder create a new file called service_locator.dart
Create a new function called setupLocator where we will register our services and models.
```
import 'package:get_it/get_it.dart';
GetIt locator = GetIt();
void setupLocator() {
}
```
In the main.dart file 
```
import 'service_locator.dart';
void main() {
  setupLocator();
  runApp(MyApp());
}
```
---
### Setup
In the lib folder create a new folder called services with for example
- login_service.dart 
- user_service.dart

```
// Login_Service.dart
class LoginService {
    String loginToken = "my_login_token";
}
```
```
// User_Service.dart
class UserService {
    String userName = "john";
}
```

---
### Setup
Register class types in either
- Factory
  - you’ll get a new instance everytime
- Singleton
  - the Locator keeps a single instance of your registered type and will always return you that instance

---
### Setup Registering types
In this example we will register the UserServiceas a singleton, and the LoginService as a Factory.
```
import './services/user_service.dart';
import './services/login_service.dart';

void setupLocator() {
  locator.registerSingleton(UserService());
  locator.registerFactory<LoginService>(() => LoginService());
}
```

---
### Use Registered types
Now wherever you need the service you’ll import the service_locator.dart file and request the type like below
```
import 'package:my_project/service_locator.dart';

var userService = locator<UserService>();
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo get_it

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
