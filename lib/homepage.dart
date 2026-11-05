import 'package:flutter/material.dart';

// TÄMÄ ON PÄÄSIVU, JOSSA ON TAPAHTUMAT JA KALENTERIN AVAUSNAPPI

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

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

            // Ensimmäinen tapahtuma
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

            // Toinen tapahtuma
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

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Nykyinen vuosi ja kuukausi
    final year = now.year;
    final month = now.month;

    // Kuukauden nimi
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

    // Kuinka monta päivää tässä kuukaudessa on?
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Kuukauden ensimmäinen päivä
    final firstDay = DateTime(year, month, 1);

    // DateTime: maanantai = 1, sunnuntai = 7
    // Muutetaan tämä GridView'ta varten nollapohjaiseksi.
    final firstWeekday = firstDay.weekday - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalenteri'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kuukausi ja vuosi
            Text(
              '${monthNames[month - 1]} $year',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
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
                  // Tyhjät ruudut ennen kuukauden ensimmäistä päivää
                  if (index < firstWeekday) {
                    return const SizedBox();
                  }

                  final day = index - firstWeekday + 1;

                  final isToday =
                      day == now.day &&
                      month == now.month &&
                      year == now.year;

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
                              ? Theme.of(context).colorScheme.onPrimary
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