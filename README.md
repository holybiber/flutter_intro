# Workshop: introduction to flutter

## Description
Building beautiful applications for Android, iOS, web, desktop... with just a single code base? Sounds impressive and cost-efficient. Flutter is still young but already stable on all platforms. A new framework with a learning curve but well-designed and without all that baggage of older frameworks and programming languages.

In this workshop I'll give you an introduction and will show you: How does it feel like to develop with it?
Based on my own experience with developing the 4training.net app in last months I'll show you how to get started with dart and flutter and how to effectively develop with it: development environment, debugging, testing... Along the way I'll answer all the questions you have as good as I can.

Spoiler: I'm happy with my choice to use flutter for app development.

## Workshop outline
* Dart and flutter: the overview
* Quickstart: Getting a new project running
* Adding some widgets
* Formatting and linting
* Debugging
* Testing
* Strategic decisions: State management
* The 4training.net app
* Conclusions

## Dart and flutter: the overview
[Why flutter uses dart](https://www.youtube.com/watch?v=5F-6n_2XWR8)

## Quickstart: Getting a new project running
Prerequisites: Install Flutter SDK (including Dart SDK), Android Studio and IDE (in my example: VS Code).

Once that's done we can quickly get a first project running:
1. `flutter create flutter_intro`
2. `cd flutter_intro`
3. `flutter run`

Multi-platform made easy - let's try it out!
1. Linux
2. Chrome
3. Emulator (via VS Code)
4. Connect to smartphone

## Adding some widgets
The [flutter widget of the week](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG) is a great resource to learn about widgets.
Let's integrate a drawer: [Drawer - widget of the week](https://www.youtube.com/watch?v=WRj86iHihgY)

And let's add some widgets into the drawer to get a feeling for "everything is a widget in flutter". Or, more specifically: "everything drawn on a screen is a widget":
* add a `ListView` to the drawer
* add a `DrawerHeader` and format it in various ways: center it, put a box around the text, change font properties, add a subtitle, add more text...
  * oops: *"A RenderFlex overflowed by 4.0 pixels on the bottom."*

And you get a feeling of how you nest many widgets into each other in flutter - the "widget tree". The styling feels similar to styling HTML with CSS. Including various details like that the `Column` widget by default takes all vertical space...

However we have no seperation between UI model, styling and code - with flutter everything is code (that needs be structured in a smart way of course)

## Formatting and linting
No need to worry about indentations or discuss about coding styles: dart comes with a default formatter. It should be enabled in your IDE but you can also run it from the command line:

`dart format .`

Also dart has a helpful linter and it's a wise decision to use it and only accept code that has no linter issues. Again you should have it enabled it in your IDE but you can also run it from the command line:

`dart analyze`

Let's fix the issues and add `const` to constructors wherever possible. This improves performance as flutter never needs to re-build these widgets in the widget tree.

## Debugging
Let's add two `ListTiles` to our `ListView` and add some action when we click on them: modify our counter. But: this doesn't work as expected - the counter isn't updated.

Thankfully flutter apps can be built in debug mode which allows fairly easy debugging in all kind of different ways - let's add a breakpoint and see whether our variable actually changes.

Result: The variable changes as expected but apparently the widget doesn't get redrawn...

Fix: We need to call `setState()` in order for the main view to get redrawn!

## Testing
When flutter created the project with simple example code it also added a test - let's look at it: [test/widget_test.dart](test/widget_test.dart)
This is pretty amazing: With just some lines of code we can test a lot of our application and make sure the UI behaves as expected.

Note that we need to use `await` so that the next frame gets drawn and the changes are visible.

Let's now add some more lines to test the functionality we added in the previous steps.
Important: `tester.pump()` forwards just one frame. It case of animations, many new frames are generated and in order
to wait for the completion of the animation, we need to use `tester.pumpAndSettle()`!

## Strategic decisions: State management
Let's do some refactoring and put the Drawer code into it's own class. That's good practice because it reduces complexity and makes it easier to test individual pieces of the UI.
However we run into problems and increasing / decreasing the counter in our drawer isn't easily possible...

As soon as you want to develop more than a very simple testing application, you need to decide for a state management solution that takes care of saving and modifying "global" data and notifying the relevant widgets when something changes so that the UI gets updated as well. Here we'll use [Riverpod](https://riverpod.dev). So let's add the [Riverpod](https://pub.dev/packages/riverpod) package:

`flutter pub add flutter_riverpod`

To get this running, we need to do a couple of things:
* create a `CounterNotifier` class to encapsulate all functionality of the counter
* create the `counterProvider` that holds our integer
* Change widgets from StatelessWidget to `ConsumerWidget`
* use `ref.watch(counterProvider)` to show the value of the counter and get redrawn whenever something changes
* use `ref.read(counterProvider.notifier).increase()` to make changes to the counter
* introduce a `ProviderScope` widget at the root of our widget tree

I like Riverpod because it's a smart approach that scales well and you can test your application well with it by mocking different providers. However it took me a while to understand the concepts behind it and there has been a lot of development on it recently which means that documentation is often outdated.

## The 4training.net app
The app is available for Android in the [Google play store](
https://play.google.com/store/apps/details?id=net.app4training). It's open source and you find the code at [https://github.com/4training/app4training](https://github.com/4training/app4training) - let's have a tour around it!