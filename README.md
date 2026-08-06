# UniBus

Organizando sua rota até a faculdade. App para organizar quem vai utilizar o
transporte universitário: confirmação de presença, viagens, passageiros,
avisos e contrapartidas (horas de trabalho comunitário).

## Stack

- **Flutter** — um único código-fonte gera o app para **mobile (Android/iOS)
  e desktop (Windows/macOS/Linux)**.
- **Firebase** — autenticação, banco de dados (Firestore) e notificações
  push. *Ainda não configurado neste projeto* (ver seção "Próximos passos").
- **provider** para gerenciamento de estado e **go_router** para navegação
  (bottom navigation no mobile, navigation rail no desktop, mesmo código).
- **fl_chart** para os gráficos do Painel Administrativo (donuts e linha).

## Contas de teste

O login é mock (sem backend ainda) e identifica o papel pelo e-mail:

| Papel  | E-mail            | Senha    | Vai para |
|--------|-------------------|----------|----------|
| Aluno  | qualquer e-mail/telefone não vazio | qualquer senha não vazia | Painel do Usuário (`/`) |
| Admin  | `adm@email.com`   | `adm123` | Painel Administrativo (`/admin`) |

A verificação do e-mail do admin não diferencia maiúsculas/minúsculas. Qualquer
outra combinação de e-mail/senha (não vazios) loga como aluno.

## Status atual

Todas as telas do mockup do Painel do Usuário (`Planejamento/Imgs/PainelUsuario.png`)
e o Dashboard do Painel Administrativo (`Planejamento/Imgs/PainelAdm.png`) foram
implementados com **dados de exemplo em memória** (sem backend ainda).

### Painel do Usuário (aluno)

Navegação em 5 abas — Início, Viagens, Contrapartidas, Avisos, Perfil:

- Login / Cadastro
- Início (próxima viagem, ações rápidas, resumo de contrapartidas, avisos não lidos)
- Confirmar presença (calendário, status, cancelar/confirmar)
- Minhas viagens (Próximas com cancelar/detalhes, Histórico)
- Passageiros (busca, filtro Todos/Confirmados, exportar lista) — acessível
  pelos atalhos da Início
- Contrapartidas (resumo de horas, vagas disponíveis com inscrição, histórico)
- Avisos (filtro por categoria: Transporte/Contrapartidas/Eventos/Urgente)
- Perfil (informações pessoais, documentos, editar perfil, notificações,
  alterar senha, ajuda, sobre, sair)

### Painel Administrativo (admin)

Sidebar fixa no desktop / drawer no mobile, com login separado do aluno
(ver "Contas de teste" acima):

- **Dashboard** — totalmente funcional com dados mock: cards de estatística
  (alunos, viagens, ônibus, contrapartidas, pendências), gráficos de
  Presenças/Ocupação/Horas de contrapartida, ações rápidas, tabela de
  próximas viagens, contrapartidas recentes, avisos não lidos, ocupação dos
  ônibus e alunos por situação.
- Demais seções do menu (Alunos, Viagens, Contrapartidas, Passageiros,
  Ônibus, Motoristas, Avisos, Notificações, Relatórios, Exportações,
  Configurações, Parâmetros do sistema, Usuários) têm rota e tela
  "em construção" — ainda sem CRUD real.

Estrutura do código:

```
lib/
  main.dart              # entry point
  app.dart                # MaterialApp.router + providers
  theme/                  # cores e tema (Material 3)
  models/                 # AppUser, Trip, Passenger, Notice, CounterpartActivity,
                           # admin_models (AdminTripRow, BusOccupancy, ...)
  state/                  # AuthProvider, AppDataProvider e AdminDataProvider
                           # (mock em memória)
  routing/                # GoRouter (rotas + shell de navegação + redirect por papel)
  widgets/                # MainScaffold (bottom nav / nav rail), AdminScaffold
                           # (sidebar / drawer), StatusBadge
  screens/                # uma pasta por tela (inclui counterparts/ e admin/)
  utils/                  # formatação de datas em pt-BR
```

## Ambiente de desenvolvimento

O toolchain completo (Flutter, JDK, Android SDK, Visual Studio Build Tools)
já está instalado e configurado nesta máquina, em `B:\dev`, com as variáveis
de ambiente (`JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT`, `PATH`)
definidas no usuário. `flutter doctor` roda limpo tanto para Windows desktop
quanto para Android (SDK de linha de comando, sem emulador).

Para rodar o app:

```
flutter pub get
flutter run -d windows   # app Windows nativo
flutter run               # escolhe device Android conectado via USB / Chrome
```

### Configurando em uma máquina nova

1. Instale o Flutter SDK: https://docs.flutter.dev/get-started/install
2. Rode `flutter doctor` e resolva o que ele pedir:
   - Windows desktop: Visual Studio Build Tools com o workload
     `Microsoft.VisualStudio.Workload.VCTools` ("Desktop development with
     C++"), e habilitar o Modo de Desenvolvedor do Windows
     (`ms-settings:developers`, necessário para symlinks de plugins).
   - Android: JDK 17, Android SDK (`platform-tools`, `platforms;android-36`,
     `build-tools`) e `ANDROID_HOME`/`ANDROID_SDK_ROOT` apontando para ele.
3. `flutter config --enable-windows-desktop` (se for usar desktop).
4. `flutter pub get`.

## Próximos passos

1. **Configurar Firebase**:
   - Criar projeto no [Firebase Console](https://console.firebase.google.com).
   - Instalar a FlutterFire CLI e rodar `flutterfire configure` (gera
     `lib/firebase_options.dart` e os arquivos de config nativos).
   - Descomentar a inicialização do Firebase em `lib/main.dart`.
   - Trocar o `AuthProvider` (login/cadastro) para usar `firebase_auth`.
   - Trocar o `AppDataProvider` (viagens/passageiros/avisos/contrapartidas)
     para ler e escrever no Firestore em vez dos dados mock em `_seed()`.
2. Ícone do app e nome de exibição por plataforma.
3. Notificações push reais (Firebase Cloud Messaging) para os avisos.
4. CRUD real nas seções do Painel Administrativo hoje "em construção"
   (Alunos, Viagens, Ônibus, Motoristas, Relatórios etc.), conforme
   `Planejamento/UniBus_Planejamento.md`.
