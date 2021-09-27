import 'dart:ffi' as ffi;
import 'dart:io' show Directory;
import 'package:path/path.dart' as path;

typedef Main = ffi.Int32 Function(ffi.Int32 a, ffi.Int32 b);
typedef MainFunc = int Function(int a, int b);
var libraryPath = path.join(Directory.current.path, '', 'a.out');

final dylib = ffi.DynamicLibrary.open(libraryPath);
final MainFunc f_main =
    dylib.lookup<ffi.NativeFunction<Main>>('add').asFunction();

main() {
  int result = f_main(10, 1000);
  print("result ${result}");
}
