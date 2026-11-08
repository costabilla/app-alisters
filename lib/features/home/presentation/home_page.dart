import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../records/domain/entry.dart';
import '../../records/domain/entry_repository.dart';
import '../../records/data/local_entry_repository.dart';
import '../../records/presentation/entry_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final EntryRepository repository = const LocalEntryRepository();
  List<Entry> entries = [];
  int tab = 0;
  bool ready = false;
  String filter = 'Todos';
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      error = null;
      entries = await repository.readAll();
    } catch (_) {
      error = 'Não foi possível carregar os registros locais.';
    }
    if (mounted) setState(() => ready = true);
  }

  Future<void> add(Entry entry) async {
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível carregar os registros. Tente novamente antes de salvar.',
          ),
        ),
      );
      return;
    }
    final updated = [entry, ...entries];
    try {
      await repository.saveAll(updated);
      if (!mounted) return;
      setState(() => entries = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro salvo neste aparelho.')),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível salvar o registro. Tente novamente.',
            ),
          ),
        );
      }
    }
  }

  Future<void> openForm(String type) async {
    final entry = await Navigator.push<Entry>(
      context,
      MaterialPageRoute(builder: (_) => EntryForm(type: type)),
    );
    if (entry != null && mounted) await add(entry);
  }

  Widget pageTitle(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: muted)),
      ],
    ),
  );
  Widget primary(String text, VoidCallback action) => SizedBox(
    width: double.infinity,
    height: 48,
    child: FilledButton.icon(
      onPressed: action,
      icon: const Icon(Icons.add, size: 19),
      label: Text(text),
    ),
  );
  Widget panel(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xffdce3dd)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );
  Widget iconBox(IconData icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xffe6f0e9),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Icon(icon, color: green, size: 21),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Alisters.',
        style: TextStyle(
          color: green,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        const Text('●', style: TextStyle(color: green, fontSize: 11)),
        const Text(
          ' Demonstração  ',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        IconButton(
          onPressed: () => setState(() => tab = 4),
          icon: const CircleAvatar(
            backgroundColor: Color(0xffe5efe8),
            child: Text('JS', style: TextStyle(color: green, fontSize: 13)),
          ),
        ),
      ],
    ),
    body: !ready
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (error != null)
                MaterialBanner(
                  content: Text(error!),
                  actions: [
                    TextButton(
                      onPressed: load,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              Expanded(
                child: IndexedStack(
                  index: tab,
                  children: [
                    dashboard(),
                    activities(),
                    history(),
                    diary(),
                    profile(),
                  ],
                ),
              ),
            ],
          ),
    bottomNavigationBar: NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xffe4f0e8),
      selectedIndex: tab,
      onDestinationSelected: (i) => setState(() => tab = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Início'),
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          label: 'Atividades',
        ),
        NavigationDestination(
          icon: Icon(Icons.copy_outlined),
          label: 'Registros',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          label: 'Diário',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    ),
  );
  Widget dashboard() => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Seu dia na obra', style: TextStyle(color: muted)),
      const SizedBox(height: 8),
      const Text(
        'Olá, João Silva.',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: ink),
      ),
      const Text('Auxiliar de Engenharia', style: TextStyle(color: muted)),
      const SizedBox(height: 24),
      panel(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: double.infinity,
              color: const Color(0xffe5efe8),
              child: const Icon(
                Icons.apartment_rounded,
                size: 70,
                color: green,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SUA OBRA ATUAL',
              style: TextStyle(fontSize: 10, letterSpacing: 1.4, color: muted),
            ),
            const SizedBox(height: 6),
            const Text(
              'Residencial Aurora',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Cliente: AM Engenharia',
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rua das Acácias, 250 · São Paulo',
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progresso da obra', style: TextStyle(color: muted)),
                Text(
                  '68%',
                  style: TextStyle(color: green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(
              value: .68,
              minHeight: 5,
              color: green,
              backgroundColor: Color(0xffe5ede7),
            ),
            const SizedBox(height: 5),
            const Text(
              'Dados de demonstração',
              style: TextStyle(color: muted, fontSize: 10),
            ),
          ],
        ),
      ),
      panel(
        Row(
          children: [
            iconBox(Icons.access_time),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sua jornada',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Disponível em breve',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Ações rápidas',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: quick(
              Icons.assignment_outlined,
              'Nova atividade',
              () => openForm('Atividade'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: quick(
              Icons.menu_book_outlined,
              'Diário de obra',
              () => openForm('Diário'),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: quick(
              Icons.receipt_long_outlined,
              'Nova despesa',
              () => openForm('Despesa'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: quick(
              Icons.local_shipping_outlined,
              'Veículo',
              () => openForm('Veículo'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Últimos registros',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => setState(() => tab = 2),
            child: const Text('Ver todos'),
          ),
        ],
      ),
      if (entries.isEmpty)
        const Text(
          'Nenhum registro salvo ainda.',
          style: TextStyle(color: muted),
        )
      else
        ...entries.take(3).map(entryTile),
      const SizedBox(height: 15),
      const Center(
        child: Text(
          'Dados de demonstração',
          style: TextStyle(color: muted, fontSize: 11),
        ),
      ),
    ],
  );
  Widget quick(IconData icon, String text, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: panel(
      Column(
        children: [
          Icon(icon, color: green),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
  Widget entryTile(Entry e) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: iconBox(switch (e.type) {
      'Atividade' => Icons.assignment_outlined,
      'Despesa' => Icons.receipt_long_outlined,
      'Veículo' => Icons.directions_car_outlined,
      _ => Icons.menu_book_outlined,
    }),
    title: Text(
      e.title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),
    subtitle: Text(
      '${e.details}\nSalvo no aparelho',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: muted, fontSize: 12),
    ),
    trailing: Text(e.date, style: const TextStyle(fontSize: 10, color: muted)),
  );
  Widget activities() {
    final list = entries.where((e) => e.type == 'Atividade').toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageTitle('Atividades', 'Cada etapa, um avanço.'),
        primary('Nova atividade', () => openForm('Atividade')),
        const SizedBox(height: 26),
        const Text(
          'Suas atividades',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          panel(
            const Text(
              'Nenhuma atividade registrada ainda.',
              style: TextStyle(color: muted),
            ),
          )
        else
          ...list.map(
            (e) => panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '●  Salvo no aparelho',
                    style: TextStyle(color: green, fontSize: 11),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    e.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Residencial Aurora',
                    style: TextStyle(color: muted),
                  ),
                  const Divider(height: 28),
                  Text(e.details, style: const TextStyle(color: muted)),
                  const SizedBox(height: 8),
                  Text(
                    e.date,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget history() {
    final visible = filter == 'Todos'
        ? entries
        : entries.where((e) => e.type == filter).toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageTitle('Registros', 'Seu dia de trabalho, registrado.'),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => openForm('Despesa'),
                icon: const Icon(Icons.add),
                label: const Text('Nova despesa'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => openForm('Veículo'),
                icon: const Icon(Icons.directions_car_outlined),
                label: const Text('Veículo'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Todos', 'Atividade', 'Diário', 'Despesa', 'Veículo']
                .map(
                  (value) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(value),
                      selected: filter == value,
                      onSelected: (_) => setState(() => filter = value),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Salvos neste aparelho',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 10),
        if (visible.isEmpty)
          panel(
            const Text(
              'Nenhum registro nesta categoria.',
              style: TextStyle(color: muted),
            ),
          )
        else
          ...visible.map(
            (e) => Column(children: [entryTile(e), const Divider()]),
          ),
      ],
    );
  }

  Widget diary() {
    final list = entries.where((e) => e.type == 'Diário').toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        pageTitle('Diário', 'A história da obra, dia após dia.'),
        primary('Novo registro', () => openForm('Diário')),
        const SizedBox(height: 26),
        if (list.isEmpty)
          panel(
            const Text(
              'Os registros adicionados aparecerão aqui.',
              style: TextStyle(color: muted),
            ),
          )
        else
          ...list.map(
            (e) => panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      iconBox(Icons.menu_book_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text(
                        'Local',
                        style: TextStyle(color: green, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(e.details),
                  const Divider(height: 28),
                  Text(
                    'Residencial Aurora  ·  ${e.date}',
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget profile() => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      pageTitle('Perfil', 'Suas informações e preferências.'),
      const SizedBox(height: 10),
      const CircleAvatar(
        radius: 38,
        backgroundColor: Color(0xffe5efe8),
        child: Text('JS', style: TextStyle(color: green, fontSize: 24)),
      ),
      const SizedBox(height: 16),
      const Center(
        child: Text(
          'João Silva',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const Center(
        child: Text('Auxiliar de Engenharia', style: TextStyle(color: muted)),
      ),
      const SizedBox(height: 6),
      const Center(
        child: Text('AM Engenharia', style: TextStyle(color: green)),
      ),
      const SizedBox(height: 32),
      const Divider(),
      const ListTile(
        leading: Icon(Icons.engineering_outlined, color: green),
        title: Text('Obra atual', style: TextStyle(color: muted, fontSize: 12)),
        subtitle: Text(
          'Residencial Aurora',
          style: TextStyle(fontWeight: FontWeight.bold, color: ink),
        ),
      ),
      const Divider(),
      const ListTile(
        leading: Icon(Icons.info_outline),
        title: Text('Versão de demonstração'),
        subtitle: Text('Os dados são armazenados neste aparelho.'),
      ),
      const SizedBox(height: 24),
      const Center(
        child: Text(
          'Alisters.',
          style: TextStyle(
            color: green,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
