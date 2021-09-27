# Platform Channels


---
### Platform Channels
Used to invoke native code

<div style="display:flex">
Using platform channels allows for receiving method calls and sending back results
<img style="height:80vh" src="/images/platform.png">
</div>

---
### Example: Battery Level
```
class MainActivity() : FlutterActivity() {
  private val CHANNEL = "samples.flutter.io/battery"  // <--

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      // TODO
    } // <--
  }
}
```

* Example written in Kotlin for Android


---
### Example: Battery Level
Working with the response argument*
```
MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
  if (call.method == "getBatteryLevel") {
    val batteryLevel = getBatteryLevel()
      if (batteryLevel != -1) {
        result.success(batteryLevel)
      } else {
        result.error("UNAVAILABLE", "Battery level not available.", null)
      }
  } else {
    result.notImplemented()
  }
}

```

---
### Example: Battery Level
Flutter-side invocation of platform methods
```
String _batteryLevel = 'Unknown battery level.';
Future<Null> _getBatteryLevel() async {
  String batteryLevel;
  try {
    final int result = await platform.invokeMethod('getBatteryLevel');
    batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    batteryLevel = "Failed to get battery level: '${e.message}'.";
  }
  setState(() {
    _batteryLevel = batteryLevel;
  });
}

```


---
### Examle summary

- one way message 
- request/response pattern

What about events? BatteryCharging event?
*Android Example explained next*

---
### EventChannels
1. Register an EventChannel

```
final EventChannel eventChannel =
        new EventChannel(registrar.messenger(), "plugins.flutter.io/charging");
eventChannel.setStreamHandler(instance);
```

---
### Listen for event
2. Register eventlistener (Android)
```
@Override
  public void onListen(Object arguments, EventSink events) {
    chargingStateChangeReceiver = createBroadcastReceiver(events);
    registrar
        .context()
        .registerReceiver(
            chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
  }
  ```

---
### React upon events
Use the events stream to call back to flutter..

```
private BroadcastReceiver createBroadCastReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

        switch (status) {
          case BatteryManager.BATTERY_STATUS_CHARGING:
            events.success("charging");
            break;
          default:
            events.error("UNAVAILABLE", "Charging status unavailable", null);
            break;
        }
      }
    };
  }
```

---
### From the Flutter side

1. Create an EventChannel
```
class Battery {
  factory Battery() {
    if (_instance == null) {
      final EventChannel eventChannel =
          const EventChannel('plugins.flutter.io/charging');
      _instance = new Battery.private(..., eventChannel);
    }
    return _instance;
  }
```

---
### From the Flutter side
2. Register for eventhandling
```
/// Fires whenever the battery state changes.
  Stream<BatteryState> get onBatteryStateChanged {
    if (_onBatteryStateChanged == null) {
      _onBatteryStateChanged = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _parseBatteryState(event));
    }
    return _onBatteryStateChanged;
  }
```

Full and other examples here:
https://github.com/flutter/plugins/tree/master/packages/


---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 7.1 Creating Native code


---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
Create and use GeneralSettings