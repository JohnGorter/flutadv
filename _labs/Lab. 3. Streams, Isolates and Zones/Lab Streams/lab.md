# Lab Streams

---
### Listen to keystrokes
Time: 30 minutes

--
### Setup
You do not have to create a new flutter project for this lab. Just copy the starter.dart and use this file as your workspace in your favorite IDE.

---
### Excercise 1. Implement the keystroke stream
Complete the code so that the stream for keys works. After running this dart code, the user should be able to 
press keys and they should be echo-ed (twice actually) to the console.

---
### Excercise 2. Complement the stream
Implement a pipeline where all keystrokes are printed distinct. So when pressing the letter 'e' twice, it should be echo-ed only once.

---
### Excercise 3. Transform the stream
Use a StreamTransformer to transform each item in the stream. Each item should be uppercased before the next in line processes the item.
Use 'StreamTransformer.fromHandlers(handleData: )' to create the streamtransformer.

The solution file has an example of working code. 