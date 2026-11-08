# Alisters Campo

Aplicativo Flutter de demonstração para registros em campo. Nesta etapa, os dados ficam no aparelho e não há autenticação ou sincronização com servidor.

## Organização

A estrutura é organizada por funcionalidades e separa responsabilidades em camadas, sem exigir uma camada para cada tela simples:

- `lib/main.dart`: ponto de entrada.
- `lib/app.dart`: configuração do aplicativo e tema global.
- `lib/core`: elementos visuais compartilhados.
- `lib/features/auth/presentation`: tela de entrada demonstrativa.
- `lib/features/home/presentation`: navegação e telas principais.
- `lib/features/records/domain`: modelo de registro e contrato de acesso aos dados.
- `lib/features/records/data`: implementação local do contrato.
- `lib/features/records/presentation`: formulário de registros.

As telas usam o contrato `EntryRepository`; a implementação atual usa um canal nativo para gravar dados locais no Android e no iOS. Ao introduzir uma API, crie uma implementação própria do contrato e defina como lidar com sincronização, falhas e conflitos. Não marque registros como enviados até receber confirmação do servidor.

Para novas funcionalidades, prefira criar uma pasta em `features` e separar apresentação, regras/modelos e acesso a dados conforme a complexidade. Evite acessar canais nativos ou API diretamente das telas. À medida que as telas crescerem, divida-as em páginas e componentes menores, mantendo o estado e a navegação explícitos.

## Execução

Com o Flutter configurado, use `flutter pub get` e `flutter run` para executar em um dispositivo ou emulador. A compilação para iOS requer macOS e as ferramentas da Apple.
