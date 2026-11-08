import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../domain/entry.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key, required this.type});
  final String type;
  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final form = GlobalKey<FormState>();
  final title = TextEditingController();
  final details = TextEditingController();
  final quantity = TextEditingController();
  final extra = TextEditingController();
  String stage = 'Alvenaria';
  String unit = 'm²';
  String category = 'Materiais';
  DateTime date = DateTime.now();
  TimeOfDay? start, end;
  @override
  void dispose() {
    title.dispose();
    details.dispose();
    quantity.dispose();
    extra.dispose();
    super.dispose();
  }

  String get dateText =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  String? requiredText(String? value) =>
      value == null || value.trim().isEmpty ? 'Preencha este campo' : null;
  Widget field(
    TextEditingController controller,
    String label, {
    String? hint,
    bool required = false,
    int lines = 1,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      maxLines: lines,
      keyboardType: keyboard,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
      ),
      validator: required ? requiredText : null,
    ),
  );
  Widget dropdown(
    String label,
    String value,
    List<String> values,
    ValueChanged<String> change,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
      ),
      items: values
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => change(v));
      },
    ),
  );
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) setState(() => date = picked);
  }

  Future<void> pickTime(bool beginning) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: beginning
          ? (start ?? TimeOfDay.now())
          : (end ?? TimeOfDay.now()),
    );
    if (picked != null && mounted) {
      setState(() {
        if (beginning) {
          start = picked;
        } else {
          end = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.type == 'Atividade';
    final diary = widget.type == 'Diário';
    final expense = widget.type == 'Despesa';
    final name = activity
        ? 'Nova atividade'
        : diary
        ? 'Diário de obra'
        : expense
        ? 'Nova despesa'
        : 'Registrar veículo';
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SafeArea(
        child: Form(
          key: form,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                activity
                    ? 'Registre o trabalho realizado na obra.'
                    : diary
                    ? 'Conte o que aconteceu na obra.'
                    : expense
                    ? 'Informe os dados da despesa.'
                    : 'Registre a utilização do veículo.',
                style: const TextStyle(color: muted),
              ),
              const SizedBox(height: 20),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.domain, color: green),
                  title: Text('Residencial Aurora'),
                  subtitle: Text('Obra de demonstração'),
                ),
              ),
              const SizedBox(height: 20),
              if (activity) ...[
                dropdown('Etapa', stage, [
                  'Alvenaria',
                  'Estrutura',
                  'Instalações',
                  'Acabamento',
                ], (v) => stage = v),
                field(
                  title,
                  'Tarefa *',
                  hint: 'Ex.: Execução de alvenaria',
                  required: true,
                ),
                field(
                  extra,
                  'Função executada',
                  hint: 'Ex.: Auxiliar de Engenharia',
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => pickTime(true),
                        icon: const Icon(Icons.schedule),
                        label: Text(start?.format(context) ?? 'Início'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => pickTime(false),
                        icon: const Icon(Icons.schedule),
                        label: Text(end?.format(context) ?? 'Término'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                field(
                  quantity,
                  'Quantidade produzida',
                  hint: 'Ex.: 24',
                  keyboard: TextInputType.number,
                ),
                dropdown('Unidade de medida', unit, [
                  'm²',
                  'm³',
                  'm',
                  'Unidade',
                ], (v) => unit = v),
              ] else if (diary) ...[
                field(
                  title,
                  'Título do registro *',
                  hint: 'Ex.: Avanço da alvenaria',
                  required: true,
                ),
              ] else if (expense) ...[
                dropdown('Categoria', category, [
                  'Materiais',
                  'Combustível',
                  'Alimentação',
                  'Transporte',
                  'Outros',
                ], (v) => category = v),
                field(
                  title,
                  'Descrição *',
                  hint: 'Ex.: Compra de materiais',
                  required: true,
                ),
                field(
                  quantity,
                  'Valor em reais *',
                  hint: 'Ex.: 185,50',
                  required: true,
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                field(extra, 'Forma de pagamento', hint: 'Ex.: Cartão pessoal'),
              ] else ...[
                field(
                  title,
                  'Veículo *',
                  hint: 'Ex.: Caminhonete ABC-1234',
                  required: true,
                ),
                field(
                  quantity,
                  'Quilometragem inicial',
                  keyboard: TextInputType.number,
                ),
                field(
                  extra,
                  'Quilometragem final',
                  keyboard: TextInputType.number,
                ),
              ],
              OutlinedButton.icon(
                onPressed: pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text('Data: $dateText'),
              ),
              const SizedBox(height: 16),
              field(
                details,
                diary
                    ? 'Andamento, materiais ou impedimentos *'
                    : 'Observações',
                required: diary,
                lines: 4,
              ),
              if (diary || expense)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Anexos de fotos e comprovantes serão adicionados em uma próxima etapa.',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ),
              FilledButton(
                onPressed: () {
                  if (!form.currentState!.validate()) return;
                  final info = [
                    if (activity) 'Etapa: $stage',
                    if (expense) 'Categoria: $category',
                    if (quantity.text.trim().isNotEmpty)
                      activity
                          ? 'Produção: ${quantity.text.trim()} $unit'
                          : expense
                          ? 'R\$ ${quantity.text.trim()}'
                          : 'Km inicial: ${quantity.text.trim()}',
                    if (extra.text.trim().isNotEmpty)
                      activity
                          ? 'Função: ${extra.text.trim()}'
                          : expense
                          ? 'Pagamento: ${extra.text.trim()}'
                          : 'Km final: ${extra.text.trim()}',
                    if (activity && start != null)
                      'Início: ${start!.format(context)}',
                    if (activity && end != null)
                      'Término: ${end!.format(context)}',
                    if (details.text.trim().isNotEmpty) details.text.trim(),
                  ].join(' • ');
                  Navigator.pop(
                    context,
                    Entry(
                      type: widget.type,
                      title: title.text.trim(),
                      details: info.isEmpty ? 'Sem observações' : info,
                      date: dateText,
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Salvar registro'),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Salvo somente neste aparelho',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
