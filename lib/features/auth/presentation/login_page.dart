import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../home/presentation/home_page.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 35, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alisters.',
                  style: TextStyle(
                    fontSize: 38,
                    color: green,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'GESTÃO DE ENGENHARIA',
                  style: TextStyle(
                    color: green,
                    letterSpacing: 3,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(width: 30, child: Divider(color: green, thickness: 3)),
              ],
            ),
          ),
          Container(
            height: 150,
            color: const Color(0xffdce9df),
            child: const Center(
              child: Icon(Icons.apartment_rounded, size: 80, color: green),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SEU DIA NA OBRA, ORGANIZADO.',
                  style: TextStyle(
                    color: green,
                    letterSpacing: 1.4,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Bem-vindo',
                  style: TextStyle(
                    fontSize: 28,
                    color: ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Acesse a demonstração para começar a jornada.',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 28),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'seu.email@empresa.com.br',
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Home()),
                    ),
                    child: const Text('Entrar na demonstração  →'),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Seu trabalho. Seus registros. Em um só lugar.',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Acesso demonstrativo, sem autenticação.',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
