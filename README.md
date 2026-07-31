# UniBus

Organizando sua rota até a faculdade. App para organizar quem vai utilizar o
transporte universitário: confirmação de presença, lista de viagens,
passageiros confirmados e avisos.

## Stack

- **Flutter** — um único código-fonte gera o app para **mobile (Android/iOS)
  e desktop (Windows/macOS/Linux)**.
- **Firebase** — autenticação, banco de dados (Firestore) e notificações
  push. *Ainda não configurado neste projeto* (ver seção "Próximos passos").
- **provider** para gerenciamento de estado e **go_router** para navegação
  (bottom navigation no mobile, navigation rail no desktop, mesmo código).

## Status atual

Todas as telas do mockup foram implementadas com **dados de exemplo em
memória** (sem backend ainda), para já dar pra navegar pelo fluxo completo:

- Login / Cadastro
- Início (próxima viagem, ações rápidas, próximas viagens)
- Confirmar presença (calendário, status, cancelar/confirmar)
- Minhas viagens (Próximas / Histórico)
- Passageiros (busca, filtro Todos/Confirmados, exportar lista)
- Avisos
- Perfil (editar perfil, notificações, alterar senha, ajuda, sobre, sair)

Estrutura do código:

```
lib/
  main.dart              # entry point
  app.dart                # MaterialApp.router + providers
  theme/                  # cores e tema (Material 3)
  models/                 # AppUser, Trip, Passenger, Notice
  state/                  # AuthProvider e AppDataProvider (mock em memória)
  routing/                # GoRouter (rotas + shell de navegação)
  widgets/                # MainScaffold (bottom nav / nav rail), StatusBadge
  screens/                # uma pasta por tela
  utils/                  # formatação de datas em pt-BR
```

## ⚠️ Antes de rodar: instalar o Flutter

Este ambiente **não tem o Flutter/Dart SDK instalado**, então o código foi
escrito mas ainda não foi compilado/testado. Para continuar:

1. Instale o Flutter SDK: https://docs.flutter.dev/get-started/install
   (Windows: pode usar `winget install -e --id Flutter.Flutter` ou baixar o
   zip oficial e adicionar ao PATH).
2. Rode `flutter doctor` e resolva o que ele pedir (Android Studio/SDK para
   mobile, "Desktop development with C++" do Visual Studio para Windows
   desktop).
3. Dentro da pasta do projeto:
   ```
   flutter create .
   ```
   Isso gera as pastas de plataforma (`android/`, `ios/`, `windows/`,
   `macos/`, `linux/`) sem sobrescrever o código já escrito em `lib/`.
4. Instale as dependências:
   ```
   flutter pub get
   ```
5. Habilite o desktop (se necessário) e rode:
   ```
   flutter config --enable-windows-desktop
   flutter run -d windows   # ou: flutter run  (escolhe o dispositivo mobile conectado/emulador)
   ```

## Próximos passos

1. **Instalar Flutter e validar o app** (passos acima) — primeira coisa a
   fazer na próxima sessão.
2. **Configurar Firebase**:
   - Criar projeto no [Firebase Console](https://console.firebase.google.com).
   - Instalar a FlutterFire CLI e rodar `flutterfire configure` (gera
     `lib/firebase_options.dart` e os arquivos de config nativos).
   - Descomentar a inicialização do Firebase em `lib/main.dart`.
   - Trocar o `AuthProvider` (login/cadastro) para usar `firebase_auth`.
   - Trocar o `AppDataProvider` (viagens/passageiros/avisos) para ler e
     escrever no Firestore em vez dos dados mock em `_seed()`.
3. Ícone do app e nome de exibição por plataforma.
4. Notificações push reais (Firebase Cloud Messaging) para os avisos.
