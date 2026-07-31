/// Formatação de datas em pt-BR sem depender de inicialização de locale do
/// pacote intl (evita LocaleDataException em telas simples como esta).
class AppDateFormat {
  AppDateFormat._();

  static const _weekdaysShort = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB'];
  static const _weekdaysLong = [
    'Domingo',
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
  ];
  static const _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  static String weekdayShort(DateTime date) => _weekdaysShort[date.weekday % 7];

  static String weekdayLong(DateTime date) => _weekdaysLong[date.weekday % 7];

  static String monthName(DateTime date) => _months[date.month - 1];

  static String dayMonth(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

  static String monthYear(DateTime date) => '${monthName(date)}/${date.year}';

  static String weekdayAbbrevCapitalized(DateTime date) {
    final short = weekdayShort(date);
    return short[0] + short.substring(1).toLowerCase();
  }

  /// Ex.: "Amanhã", "Hoje" ou "Qui, 31/07".
  static String relativeOrWeekday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Amanhã';
    return '${weekdayAbbrevCapitalized(date)}, ${dayMonth(date)}';
  }
}
