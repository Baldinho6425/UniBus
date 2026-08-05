# UniBus - Documento de Planejamento

## Visão Geral

O **UniBus** é uma plataforma para gerenciamento do transporte
universitário, composta por:

-   Aplicativo do Aluno
-   Painel Administrativo (Web)
-   API + Banco de Dados

------------------------------------------------------------------------

# Aplicativo do Aluno

## Login

-   Login
-   Cadastro
-   Recuperação de senha

## Página Inicial

-   Próxima viagem
-   Horário
-   Local de saída
-   Status da confirmação
-   Botões rápidos
-   Card de Contrapartidas:
    -   Horas feitas
    -   Horas pendentes
    -   Próxima atividade

## Viagens

### Próximas

-   Confirmar presença
-   Cancelar presença

### Histórico

-   Presenças
-   Faltas
-   Estatísticas

## Passageiros

-   Confirmados
-   Não confirmados
-   Faltaram
-   Pesquisa e filtros

## Contrapartidas

### Resumo

-   Horas obrigatórias
-   Horas concluídas
-   Horas pendentes
-   Prazo

### Vagas

Cada vaga possui: - Título - Descrição - Local - Data - Horário -
Responsável - Quantidade de horas - Número de vagas - Botão "Participar"

### Histórico

Lista de todas as atividades realizadas.

## Avisos

Categorias: - Transporte - Contrapartidas - Eventos - Urgente

Sempre que uma nova contrapartida for publicada: - Notificação Push -
Novo aviso no aplicativo

## Perfil

-   Dados pessoais
-   Curso
-   Semestre
-   Município
-   Ponto de embarque
-   Documentos
-   Configurações

------------------------------------------------------------------------

# Painel Administrativo

## Dashboard

-   Total de alunos
-   Viagens da semana
-   Ônibus ativos
-   Pendências
-   Contrapartidas abertas
-   Gráficos

## Gestão de Alunos

-   Cadastro
-   Edição
-   Exclusão
-   Pesquisa
-   Importação/Exportação
-   Histórico
-   Horas
-   Documentos

## Gestão de Viagens

-   Criar
-   Editar
-   Cancelar
-   Duplicar
-   Definir ônibus, motorista, horário e capacidade

## Gestão de Ônibus

-   Cadastro
-   Capacidade
-   Placa
-   Situação
-   Motorista

## Gestão de Motoristas

-   Cadastro
-   CNH
-   Contato

## Confirmações

-   Lista de confirmados
-   Lista de ausentes
-   Exportar PDF/Excel

## Gestão de Contrapartidas

Criar atividade contendo: - Título - Descrição - Local - Data -
Responsável - Quantidade de vagas - Horas válidas - Prazo de inscrição

Após a atividade: - Confirmar presença dos participantes - Atualizar
automaticamente as horas

## Gestão de Avisos

Enviar para: - Todos - Curso - Município - Turma

Gera: - Push Notification - Aviso interno

## Relatórios

-   Presenças
-   Faltas
-   Passageiros
-   Horas comunitárias
-   Pendências
-   Utilização do transporte

## Configurações

-   Ano letivo
-   Cursos
-   Municípios
-   Pontos de embarque
-   Ônibus
-   Motoristas
-   Horas obrigatórias

------------------------------------------------------------------------

# Banco de Dados

-   Usuários
-   Administradores
-   Alunos
-   Motoristas
-   Ônibus
-   Viagens
-   Presenças
-   Contrapartidas
-   Inscrições
-   Horas
-   Avisos
-   Notificações
-   Cursos
-   Municípios
-   Pontos de embarque

------------------------------------------------------------------------

# Fluxo das Contrapartidas

1.  Administrador cria atividade.
2.  Sistema envia notificação.
3.  Aluno recebe aviso.
4.  Aluno realiza inscrição.
5.  Administrador confirma presença.
6.  Sistema soma automaticamente as horas.
7.  Aluno acompanha seu saldo atualizado.

------------------------------------------------------------------------

# Funcionalidades Futuras

-   QR Code para embarque
-   Lista de espera
-   Status/localização do ônibus
-   Calendário acadêmico
-   Avaliação da viagem
-   Sistema de penalidades
-   Justificativa de ausência
-   Comunicados específicos por viagem

------------------------------------------------------------------------

# Ordem Recomendada de Desenvolvimento

1.  Login
2.  Gestão de Viagens
3.  Confirmação de Presença
4.  Painel Administrativo
5.  Notificações
6.  Contrapartidas
7.  Relatórios
8.  Funcionalidades extras

------------------------------------------------------------------------

# Objetivo

Transformar o UniBus em uma plataforma completa para gestão do
transporte universitário, integrando alunos, prefeitura e universidade
em um único sistema. O grande diferencial será o módulo de
**Contrapartidas**, automatizando o controle das horas comunitárias
exigidas pelos municípios.
