# Example for Notifiable Iterables

This project uses *Notifiable Iterables* as a library in a concrete example. In this app, the
fibonacci numbers are stored in a `NotifiableList<int>`, and every time a new fibonacci number is
computed, it is added to the list. The action to add an element triggers a notification to the UI
that will then update its content.

The source code is located at `lib/main.dart`.
