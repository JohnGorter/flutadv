# Lab JavaScript Interop

---
### Page LifeCycle and LocalStorage
Time: 45 minutes

--
### Setup
Create a brand new flutter application and use the main.dart in your IDE.

---
### Exercise 1. Integrate Page LifeCyle
HTML5 now (actually some time now) supports Page lifecycle events. More on that topic is found here:
https://developers.google.com/web/updates/2018/07/page-lifecycle-api

Integrate this page lifecycle in you flutter for web application. Use the package:js package to 
call dart functions from these events and print the events to the console whenever one of these events occur.  

You can use these events to stop polling for data for instance or stop calculating stuf thats needed on the UI. 

---
### Exercise 2. Integrate LocalStorage
Use the local storage options of Chrome to store data from your flutter app. Use an input field in Flutter for web to ask the users name. Store this name in local storate. 

More information about localstorage can be found here:
https://developer.chrome.com/docs/devtools/storage/localstorage/

---
### Excercise 3. Interate more LocalStorage
Upon startup of your Flutter web application, use JavaScript to inspect the localstorage and see if there is a username for this application instance (identified with its path). Feed this username to your Flutter web application and adjust the Flutter web application so it displays the given username. 

