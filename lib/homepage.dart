import 'package:flutter/material.dart';

// TÄMÄ ON PÄÄSIVU, JOSSA ON TAPAHTUMAT JA KALENTERIN AVAUSNAPPI

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

// Dark/light mode -tilan vaihtaminen

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Vaalea teema
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      // Tumma teema
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      // Vaihdetaan teeman mukaan
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: HomePage(
        isDarkMode: isDarkMode,
        onThemeChanged: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oma kalenteri'),

        // Dark mode -nappi oikeaan yläkulmaan
        actions: [
          IconButton(
            onPressed: onThemeChanged,
            tooltip: isDarkMode
                ? 'Vaihda vaaleaan tilaan'
                : 'Vaihda tummaan tilaan',
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Hei! 👋',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${today.day}.${today.month}.${today.year}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Tänään',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // Kortit, päivän tapahtumat
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.school,
                  color: Colors.blue,
                ),
                title: const Text('Koulu'),
                subtitle: const Text('09:00 - 15:00'),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.sports,
                  color: Colors.green,
                ),
                title: const Text('Treenit'),
                subtitle: const Text('17:00 - 18:30'),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalendarPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Avaa kalenteri'),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// TÄMÄ ON KALENTERISIVU, JOSSA NÄYTETÄÄN KALENTERI

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  // Tallennetaan näytettävä kuukausi
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {

    // Nykyinen vuosi ja kuukausi
    final year = selectedMonth.year;
    final month = selectedMonth.month;

    // Kuukausien nimet
    const monthNames = [
      'Tammikuu',
      'Helmikuu',
      'Maaliskuu',
      'Huhtikuu',
      'Toukokuu',
      'Kesäkuu',
      'Heinäkuu',
      'Elokuu',
      'Syyskuu',
      'Lokakuu',
      'Marraskuu',
      'Joulukuu',
    ];

    // Kuukauden päivien määrä
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Kuukauden ensimmäinen päivä
    final firstDay = DateTime(year, month, 1);

    // Maanantai = 0, sunnuntai = 6
    final firstWeekday = firstDay.weekday - 1;

    // Tämän päivän päivämäärä
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalenteri'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Kuukauden vaihtaminen nuolilla
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Edellinen kuukausi
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        year,
                        month - 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),

                // Kuukausi ja vuosi
                Text(
                  '${monthNames[month - 1]} $year',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Seuraava kuukausi
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        year,
                        month + 1,
                      );
                    });
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Viikonpäivät
            Row(
              children: const [
                Expanded(child: Center(child: Text('Ma'))),
                Expanded(child: Center(child: Text('Ti'))),
                Expanded(child: Center(child: Text('Ke'))),
                Expanded(child: Center(child: Text('To'))),
                Expanded(child: Center(child: Text('Pe'))),
                Expanded(child: Center(child: Text('La'))),
                Expanded(child: Center(child: Text('Su'))),
              ],
            ),

            const SizedBox(height: 10),

            // Kalenterin päivät
            Expanded(
              child: GridView.builder(

                itemCount: firstWeekday + daysInMonth,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),

                itemBuilder: (context, index) {

                  // Tyhjät ruudut kuukauden alussa
                  if (index < firstWeekday) {
                    return const SizedBox();
                  }

                  final day = index - firstWeekday + 1;

                  // Tarkistetaan, onko päivä tänään
                  final isToday =
                      day == today.day &&
                      month == today.month &&
                      year == today.year;

                  return Container(
                    decoration: BoxDecoration(
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Center(
                      child: Text(
                        '$day',

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,

                          color: isToday
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}