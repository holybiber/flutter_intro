import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class CounterNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void increase() {
    state = state + 1;
  }

  void decrease() {
    state = state - 1;
  }

  void fastForward() {
    state = state + 100;
  }
}

final counterProvider =
    NotifierProvider<CounterNotifier, int>(() => CounterNotifier());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Intro'),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    debugPrint('Building main view');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      drawer: const OurDrawer(),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$counter', style: Theme.of(context).textTheme.headlineMedium),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).increase();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class OurDrawer extends ConsumerWidget {
  const OurDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
            child: Center(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.orange,
                    child: const Column(
                      children: [
                        Text('ICCM Europe',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        Divider(),
                        //                    Text('2024 Mosbach'),
                        //                    Text('Thursday')
                      ],
                    )))),
        ListTile(
            title: const Text('Fast forward'),
            onTap: () {
              Navigator.of(context).pop();
              ref.read(counterProvider.notifier).fastForward();
            }),
        ListTile(
            title: const Text('Go backwards'),
            onTap: () {
              Navigator.of(context).pop();
              ref.read(counterProvider.notifier).decrease();
            }),
        ListTile(
            title: Center(child: Text(ref.watch(counterProvider).toString())))
      ]),
    );
  }
}
