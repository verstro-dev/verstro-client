// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} день назад', few: '${count} дня назад', many: '${count} дней назад', other: '${count} дня назад')}";

  static String m1(label) =>
      "Вы уверены, что хотите удалить выбранные ${label}?";

  static String m2(label) => "Вы уверены, что хотите удалить текущий ${label}?";

  static String m3(label) => "Детали {}";

  static String m4(label) => "${label} не может быть пустым";

  static String m5(label) => "Текущий ${label} уже существует";

  static String m6(count) =>
      "${Intl.plural(count, one: '${count} час назад', few: '${count} часа назад', many: '${count} часов назад', other: '${count} часа назад')}";

  static String m7(count) =>
      "${Intl.plural(count, one: '${count} минута назад', few: '${count} минуты назад', many: '${count} минут назад', other: '${count} минуты назад')}";

  static String m8(count) =>
      "${Intl.plural(count, one: '${count} месяц назад', few: '${count} месяца назад', many: '${count} месяцев назад', other: '${count} месяца назад')}";

  static String m9(label) => "${label} пока отсутствуют";

  static String m10(label) => "${label} должно быть числом";

  static String m11(label) => "${label} должен быть числом от 1024 до 49151";

  static String m12(count) => "Выбрано ${count} элементов";

  static String m13(label) => "${label} должен быть URL";

  static String m14(url) => "Не удалось открыть: ${url}";

  static String m15(days) => "Активность: ${days} дн. назад";

  static String m16(hours) => "Активность: ${hours} ч. назад";

  static String m17(minutes) => "Активность: ${minutes} мин. назад";

  static String m18(count) =>
      "Приглашайте друзей и получайте 30% комиссии · приглашено: ${count}";

  static String m19(amount) => "К выводу ${amount}";

  static String m20(amount) => "Доступный баланс: ${amount}";

  static String m21(error) => "Ошибка запуска: ${error}";

  static String m22(days) => "через ${days} дн.";

  static String m23(count, max) =>
      "Зарегистрировано устройств: ${count} / ${max}";

  static String m24(count) => "Зарегистрировано устройств: ${count}";

  static String m25(date) => "До ${date}";

  static String m26(hours) => "через ${hours} ч.";

  static String m27(name) =>
      "«${name}» будет удалено; для дальнейшего использования Verstro потребуется войти заново.";

  static String m28(error) => "Не удалось выйти: ${error}";

  static String m29(minutes) => "через ${minutes} мин.";

  static String m30(error) => "Не удалось загрузить заказы: ${error}";

  static String m31(amount) => "Осталось ${amount}";

  static String m32(email) =>
      "Код подтверждения отправлен на ${email} (проверьте также папку «Спам»). Введите 6-значный код, чтобы завершить подтверждение.";

  static String m33(amount) => "Доступно ${amount}";

  static String m34(dest) => "Адрес получения ${dest}";

  static String m35(count) => "Приглашено: ${count}";

  static String m36(price) => "Минимальная цена продажи ${price}";

  static String m37(amount) => "Выплачено ${amount}";

  static String m38(min) =>
      "Недостаточно средств. Минимальная сумма вывода — ${min}.";

  static String m39(amount, dest) =>
      "Сумма вывода: ${amount}\nАдрес получения (TRC20):\n${dest}\n\nВыплата выполняется вручную — обычно в течение 24 часов, максимум 3 рабочих дня. Комиссию сети берёт на себя платформа: вы получите ровно запрошенную сумму.\n\nВнимательно проверьте адрес: после отправки его нельзя изменить, а средства, отправленные на неверный адрес, вернуть невозможно.";

  static String m40(min, current) =>
      "Вывод доступен от ${min} (сейчас ${current})";

  static String m41(amount) => "Ожидает ${amount} (период созревания 14 дней)";

  static String m42(planId) => "План ${planId}";

  static String m43(list, floor) =>
      "Цена платформы ${list} · ваша закупочная цена ${floor}";

  static String m44(floor, list) => "Должно быть от ${floor} до ${list}";

  static String m45(floor, list) =>
      "Допустимый диапазон ${floor} ~ ${list} (только скидка)";

  static String m46(planId, price) =>
      "Цена для ${planId} установлена: ${price}";

  static String m47(list) => "Не задано (по цене платформы ${list})";

  static String m48(amount) => "В обработке ${amount} (ручная выплата)";

  static String m49(planId) => "Задать цену для ${planId}";

  static String m50(code, url) =>
      "Зарегистрируйтесь в Verstro с моим кодом приглашения ${code} — за первую покупку вы тоже получите бонус! Скачать: ${url}";

  static String m51(count, amount) =>
      "Субагентов: ${count} · доступно по override ${amount}";

  static String m52(price, earn) =>
      "Ваша цена ${price} · прибыль ${earn} с заказа";

  static String m53(detail) => "Не удалось подключиться к серверу: ${detail}";

  static String m54(status) => "Ошибка сервера (${status})";

  static String m55(detail) => "Ошибка сертификата TLS: ${detail}";

  static String m56(type) => "Неожиданный тип ответа: ${type}";

  static String m57(status) => "Неожиданный код состояния ${status}";

  static String m58(error) => "Ошибка входа: ${error}";

  static String m59(error) => "Ошибка регистрации: ${error}";

  static String m60(seconds) => "Отправить снова (${seconds} с)";

  static String m61(email) =>
      "Код подтверждения отправлен на ${email} (проверьте папку «Спам»).\nВведите 6-значный код и задайте новый пароль.";

  static String m73(amount) =>
      "Подтверждено — подписка активна. Переплата ${amount} зачислена на баланс и применится автоматически в следующий раз.";

  static String m74(amount) =>
      "Заказ истёк, но мы получили ваш перевод. ${amount} зачислена на баланс. Оформите заказ заново — баланс применится автоматически и активирует подписку сразу, если покрывает сумму.";

  static String m75(amount) =>
      "${amount} зачислена на баланс. Оформите заказ заново — баланс применится автоматически.";

  static String m76(amount, shortfall) =>
      "Полученная сумма меньше нужной. ${amount} зачислена на баланс, исходный заказ аннулирован. Оформите заказ заново — баланс применится автоматически, доплатить нужно только разницу ${shortfall}.";

  static String m77(amount, count, remaining) =>
      "Получено ${amount} в ${count} платежах; осталось ${remaining}. Переведите разницу на адрес этого заказа и отправьте следующий TXID.";

  static String m78(count) =>
      "Оплата завершена в ${count} транзакциях, подписка активирована.";

  static String m79(amount) =>
      "Излишек ${amount} зачислен на баланс и применится автоматически при следующей покупке.";

  static String m80(recipient) =>
      "Фактический получатель — ${recipient}, он не совпадает с заказом. Проверьте перевод и не платите повторно.";

  static String m81(code) => "Номер авторизации ${code}";

  static String m82(basePrice) =>
      "Базовая цена тарифа \$${basePrice} + центы для сопоставления. Отклонение даже на 0.01 не даст сопоставить платёж автоматически. Проверьте, что поле «сумма» в кошельке совпадает с точностью до 2 знаков после запятой.";

  static String m83(id) =>
      "По заказу №${id} не поступила оплата в течение 24 часов, и он был автоматически аннулирован.";

  static String m84(id) => "Заказ №${id}";

  static String m85(plan, id) => "${plan} — заказ №${id}";

  static String m86(seconds) => "Повторить через ${seconds} с";

  static String m87(error) => "Не удалось отправить: ${error}";

  static String m88(email) => "Аккаунт: ${email}";

  static String m89(error) => "Не удалось создать заказ: ${error}";

  static String m90(days) => "Действует ${days} дн.";

  static String m91(error) => "Не удалось загрузить тарифы: ${error}";

  static String m92(count) => "${count} устройств(а) онлайн одновременно";

  static String m93(price) => "≈ \$${price} / мес.";

  static String m94(amount) => "${amount} трафика";

  static String m95(amount) => "Скидка ${amount}";

  static String m96(error) => "Не удалось получить расчёт акции: ${error}";

  static String m97(trial, invite, url) =>
      "Verstro — кроссплатформенный сетевой инструмент с приоритетом приватности. Клиенты доступны для Android и настольных систем; на iOS подписку можно импортировать в поддерживаемые сторонние клиенты. ${trial}${invite}${url}";

  static String m98(trial, invite, url) =>
      "Терминал, Docker или Git обходят системный прокси? TUN на компьютере может охватить больше приложений на сетевом уровне ОС. Фактический охват зависит от ОС, приложения, правил и сети. Клиент Verstro открыт по GPLv3. ${trial}${invite}${url}";

  static String m99(trial, invite, url) =>
      "Я пользуюсь Verstro — кроссплатформенным сетевым инструментом с приоритетом приватности. Клиенты доступны для Android и настольных систем; iOS использует поддерживаемые сторонние клиенты. Работа зависит от ОС и сети. ${trial}${invite}Скачать: ${url}";

  static String m100(prefix, amount) =>
      "${prefix} — после первой покупки мы оба получим ${amount} на счёт. ";

  static String m101(prefix) => "${prefix}. ";

  static String m102(code) =>
      "При регистрации укажите мой код приглашения ${code}";

  static String m103(code) => "Регистрируйтесь с кодом ${code}";

  static String m104(prefix, amount) =>
      "${prefix} — после первой покупки вы получите ${amount} на счёт. ";

  static String m105(amount) =>
      "Код при регистрации · после первой покупки каждому по ${amount}";

  static String m106(amount) =>
      "Код при регистрации · ${amount} на счёт за первую покупку";

  static String m107(days) => "${days} дн. бесплатно";

  static String m108(trial, gb) => "Новым пользователям: ${trial}${gb}";

  static String m109(days) =>
      "Новым пользователям — бесплатный пробный период ${days} дн. ";

  static String m110(days, gb) => "${days} дн. · ${gb} ГБ трафика";

  static String m111(days) =>
      "Подтвердите почту, чтобы получить бесплатный пробный период на ${days} дн. (введите 6-значный код из письма)";

  static String m112(error) => "Ошибка загрузки: ${error}";

  static String m113(percent) => "Загрузка ${percent}%";

  static String m114(version) => "Требуется обновление до v${version}";

  static String m115(error) => "Не удалось запустить установщик: ${error}";

  static String m116(version) => "Доступна новая версия v${version}";

  static String m117(error) => "Не удалось обновить: ${error}";

  static String m118(count) =>
      "${Intl.plural(count, one: '${count} год назад', few: '${count} года назад', many: '${count} лет назад', other: '${count} года назад')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("О программе"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Контроль доступа"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить только выбранным приложениям доступ к VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Настройка доступа приложений к прокси",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Выбранные приложения будут исключены из VPN",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage(
      "Настройки контроля доступа",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Аккаунт"),
    "action": MessageLookupByLibrary.simpleMessage("Действие"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Переключить режим"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "action_start": MessageLookupByLibrary.simpleMessage("Старт/Стоп"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Показать/Скрыть"),
    "add": MessageLookupByLibrary.simpleMessage("Добавить"),
    "addProfile": MessageLookupByLibrary.simpleMessage("Добавить профиль"),
    "addRule": MessageLookupByLibrary.simpleMessage("Добавить правило"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage(
      "Добавить к оригинальным правилам",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Добавленные правила"),
    "address": MessageLookupByLibrary.simpleMessage("Адрес"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("Адрес сервера WebDAV"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите действительный адрес WebDAV",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage(
      "Автозапуск с правами администратора",
    ),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Запуск с правами администратора при загрузке системы",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Расширенная конфигурация",
    ),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Предоставляет разнообразные варианты конфигурации",
    ),
    "ago": MessageLookupByLibrary.simpleMessage(" назад"),
    "agree": MessageLookupByLibrary.simpleMessage("Согласен"),
    "allApps": MessageLookupByLibrary.simpleMessage("Все приложения"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Разрешить приложениям обходить VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Некоторые приложения могут обходить VPN при включении",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Разрешить LAN"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить доступ к прокси через локальную сеть",
    ),
    "app": MessageLookupByLibrary.simpleMessage("Приложение"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "Контроль доступа приложений",
    ),
    "appDesc": MessageLookupByLibrary.simpleMessage(
      "Обработка настроек, связанных с приложением",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Добавить системный DNS",
    ),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage(
      "Принудительно добавить системный DNS к конфигурации",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Приложение"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с приложением",
    ),
    "auto": MessageLookupByLibrary.simpleMessage("Авто"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Автопроверка обновлений",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически проверять обновления при запуске приложения",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Автоматическое закрытие соединений",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически закрывать соединения после смены узла",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Автозапуск"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Следовать автозапуску системы",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("Автозапуск"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматический запуск при открытии приложения",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Автоматическая настройка системного DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Автообновление"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления (минуты)",
    ),
    "backup": MessageLookupByLibrary.simpleMessage("Резервное копирование"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование и восстановление",
    ),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "Синхронизация данных через WebDAV или файлы",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование успешно",
    ),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Базовая конфигурация"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Глобальное изменение базовых настроек",
    ),
    "bind": MessageLookupByLibrary.simpleMessage("Привязать"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage(
      "Режим черного списка",
    ),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Обход домена"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Действует только при включенном системном прокси",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "Кэш поврежден. Хотите очистить его?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Отменить фильтрацию системных приложений",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "Отменить выбор всего",
    ),
    "checkError": MessageLookupByLibrary.simpleMessage("Ошибка проверки"),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Проверить обновления"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "Текущее приложение уже является последней версией",
    ),
    "checking": MessageLookupByLibrary.simpleMessage("Проверка..."),
    "clearData": MessageLookupByLibrary.simpleMessage("Очистить данные"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Экспорт в буфер обмена",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Импорт из буфера обмена",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Цвет"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Цветовые схемы"),
    "columns": MessageLookupByLibrary.simpleMessage("Столбцы"),
    "compatible": MessageLookupByLibrary.simpleMessage("Режим совместимости"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "Включение приведет к потере части функциональности приложения, но обеспечит полную поддержку Clash.",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите очистить все данные?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно аварийно завершить работу ядра?",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Подключено"),
    "connecting": MessageLookupByLibrary.simpleMessage("Подключение..."),
    "connection": MessageLookupByLibrary.simpleMessage("Соединение"),
    "connections": MessageLookupByLibrary.simpleMessage("Соединения"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Просмотр текущих данных о соединениях",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Связь："),
    "contactMe": MessageLookupByLibrary.simpleMessage("Свяжитесь со мной"),
    "content": MessageLookupByLibrary.simpleMessage("Содержание"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Контентная тема"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Управление глобальными добавленными правилами",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Копирование переменных окружения",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("Копировать ссылку"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Копирование успешно"),
    "core": MessageLookupByLibrary.simpleMessage("Ядро"),
    "coreConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "Обнаружено изменение конфигурации ядра",
    ),
    "coreInfo": MessageLookupByLibrary.simpleMessage("Информация о ядре"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Основной статус"),
    "country": MessageLookupByLibrary.simpleMessage("Страна"),
    "crashTest": MessageLookupByLibrary.simpleMessage("Тест на сбои"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("Анализ сбоев"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "При включении автоматически загружает журналы сбоев без конфиденциальной информации, когда приложение выходит из строя",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "creationTime": MessageLookupByLibrary.simpleMessage("Время создания"),
    "cut": MessageLookupByLibrary.simpleMessage("Вырезать"),
    "dark": MessageLookupByLibrary.simpleMessage("Темный"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Панель управления"),
    "days": MessageLookupByLibrary.simpleMessage("Дней"),
    "daysAgo": m0,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Сервер имен по умолчанию",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Для разрешения DNS-сервера",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage(
      "Сортировка по умолчанию",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("По умолчанию"),
    "delay": MessageLookupByLibrary.simpleMessage("Задержка"),
    "delaySort": MessageLookupByLibrary.simpleMessage("Сортировка по задержке"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Тест задержки"),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteMultipTip": m1,
    "deleteTip": m2,
    "desc": MessageLookupByLibrary.simpleMessage(
      "Многоплатформенный прокси-клиент на основе ClashMeta, простой и удобный в использовании, с открытым исходным кодом и без рекламы.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Назначение"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "Геолокация назначения",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("ASN назначения"),
    "details": m3,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Опирается на сторонний API, только для справки",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Режим разработчика"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Режим разработчика активирован.",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Прямой"),
    "disclaimer": MessageLookupByLibrary.simpleMessage(
      "Отказ от ответственности",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Это программное обеспечение используется только в некоммерческих целях, таких как учебные обмены и научные исследования. Запрещено использовать это программное обеспечение в коммерческих целях. Любая коммерческая деятельность, если таковая имеется, не имеет отношения к этому программному обеспечению.",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Отключено"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Обнаружена новая версия",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage(
      "Обнаружена новая версия",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Обновление настроек, связанных с DNS",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS-перехват"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("Режим DNS"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Вы хотите пропустить",
    ),
    "domain": MessageLookupByLibrary.simpleMessage("Домен"),
    "download": MessageLookupByLibrary.simpleMessage("Скачивание"),
    "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Редактировать глобальные правила",
    ),
    "editRule": MessageLookupByLibrary.simpleMessage("Редактировать правило"),
    "emptyTip": m4,
    "en": MessageLookupByLibrary.simpleMessage("Английский"),
    "enableOverride": MessageLookupByLibrary.simpleMessage(
      "Включить переопределение",
    ),
    "entries": MessageLookupByLibrary.simpleMessage(" записей"),
    "exclude": MessageLookupByLibrary.simpleMessage(
      "Скрыть из последних задач",
    ),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "Когда приложение находится в фоновом режиме, оно скрыто из последних задач",
    ),
    "existsTip": m5,
    "exit": MessageLookupByLibrary.simpleMessage("Выход"),
    "expand": MessageLookupByLibrary.simpleMessage("Стандартный"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("Время истечения"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Экспорт файла"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Экспорт логов"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Экспорт успешен"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("Экспрессивные"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "Внешний контроллер",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "При включении ядро Clash можно контролировать на порту 9090",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("Внешнее получение"),
    "externalLink": MessageLookupByLibrary.simpleMessage("Внешняя ссылка"),
    "externalResources": MessageLookupByLibrary.simpleMessage(
      "Внешние ресурсы",
    ),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Фильтр Fakeip"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Диапазон Fakeip"),
    "fallback": MessageLookupByLibrary.simpleMessage("Резервный"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Обычно используется оффшорный DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage(
      "Фильтр резервного DNS",
    ),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Точная передача"),
    "file": MessageLookupByLibrary.simpleMessage("Файл"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("Прямая загрузка профиля"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "Файл был изменен. Хотите сохранить изменения?",
    ),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Фильтровать системные приложения",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage(
      "Режим поиска процесса",
    ),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "При включении возможны небольшие потери производительности",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Семейство шрифтов"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно перезапустить ядро?",
    ),
    "fourColumns": MessageLookupByLibrary.simpleMessage("Четыре столбца"),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("Фруктовый микс"),
    "general": MessageLookupByLibrary.simpleMessage("Общие"),
    "generalDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение общих настроек",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("Геоданные"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Режим низкого потребления памяти для геоданных",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Включение будет использовать загрузчик геоданных с низким потреблением памяти",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Код Geoip"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage(
      "Получить оригинальные правила",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Глобальный"),
    "go": MessageLookupByLibrary.simpleMessage("Перейти"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Перейти к загрузке"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Перейти к настройке скрипта",
    ),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Хотите сохранить изменения в кэше?",
    ),
    "host": MessageLookupByLibrary.simpleMessage("Хост"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Добавить Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage(
      "Конфликт горячих клавиш",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Управление горячими клавишами",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Использование клавиатуры для управления приложением",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("Часов"),
    "hoursAgo": m6,
    "icon": MessageLookupByLibrary.simpleMessage("Иконка"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage(
      "Конфигурация иконки",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Стиль иконки"),
    "import": MessageLookupByLibrary.simpleMessage("Импорт"),
    "importFile": MessageLookupByLibrary.simpleMessage("Импорт из файла"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Импорт из URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Импорт по URL"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage(
      "Долгосрочное действие",
    ),
    "init": MessageLookupByLibrary.simpleMessage("Инициализация"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите правильную горячую клавишу",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Интеллектуальный выбор",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Интернет"),
    "interval": MessageLookupByLibrary.simpleMessage("Интервал"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Внутренний IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Неверный файл резервной копии",
    ),
    "ipcidr": MessageLookupByLibrary.simpleMessage("IPCIDR"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "При включении будет возможно получать IPv6 трафик",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить входящий IPv6",
    ),
    "ja": MessageLookupByLibrary.simpleMessage("Японский"),
    "just": MessageLookupByLibrary.simpleMessage("Только что"),
    "justNow": MessageLookupByLibrary.simpleMessage("Только что"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Интервал поддержания TCP-соединения",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Ключ"),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "layout": MessageLookupByLibrary.simpleMessage("Макет"),
    "light": MessageLookupByLibrary.simpleMessage("Светлый"),
    "list": MessageLookupByLibrary.simpleMessage("Список"),
    "listen": MessageLookupByLibrary.simpleMessage("Слушать"),
    "loadTest": MessageLookupByLibrary.simpleMessage("Тест загрузки"),
    "loading": MessageLookupByLibrary.simpleMessage("Загрузка..."),
    "local": MessageLookupByLibrary.simpleMessage("Локальный"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование локальных данных на локальный диск",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Журнал"),
    "logLevel": MessageLookupByLibrary.simpleMessage("Уровень логов"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Отключение скроет запись логов",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Логи"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Записи захвата логов"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Тест журналов"),
    "loopback": MessageLookupByLibrary.simpleMessage(
      "Инструмент разблокировки Loopback",
    ),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Используется для разблокировки Loopback UWP",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Свободный"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Информация о памяти"),
    "messageTest": MessageLookupByLibrary.simpleMessage(
      "Тестирование сообщения",
    ),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("Это сообщение."),
    "min": MessageLookupByLibrary.simpleMessage("Мин"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage(
      "Свернуть при выходе",
    ),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Изменить стандартное событие выхода из системы",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("Минут"),
    "minutesAgo": m7,
    "mixedPort": MessageLookupByLibrary.simpleMessage("Смешанный порт"),
    "mode": MessageLookupByLibrary.simpleMessage("Режим"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Монохром"),
    "months": MessageLookupByLibrary.simpleMessage("Месяцев"),
    "monthsAgo": m8,
    "more": MessageLookupByLibrary.simpleMessage("Еще"),
    "name": MessageLookupByLibrary.simpleMessage("Имя"),
    "nameSort": MessageLookupByLibrary.simpleMessage("Сортировка по имени"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Сервер имен"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Для разрешения домена",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Политика сервера имен",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Указать соответствующую политику сервера имен",
    ),
    "network": MessageLookupByLibrary.simpleMessage("Сеть"),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с сетью",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage(
      "Обнаружение сети",
    ),
    "networkException": MessageLookupByLibrary.simpleMessage(
      "Ошибка сети, проверьте соединение и попробуйте еще раз",
    ),
    "networkRequestException": MessageLookupByLibrary.simpleMessage(
      "Исключение сетевого запроса, пожалуйста, попробуйте позже.",
    ),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Скорость сети"),
    "networkType": MessageLookupByLibrary.simpleMessage("Тип сети"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Нейтральные"),
    "noData": MessageLookupByLibrary.simpleMessage("Нет данных"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("Нет горячей клавиши"),
    "noIcon": MessageLookupByLibrary.simpleMessage("Нет иконки"),
    "noInfo": MessageLookupByLibrary.simpleMessage("Нет информации"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Больше не напоминать",
    ),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Нет дополнительной информации",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("Нет сети"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("Приложение без сети"),
    "noProxy": MessageLookupByLibrary.simpleMessage("Нет прокси"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, создайте профиль или добавьте действительный профиль",
    ),
    "noResolve": MessageLookupByLibrary.simpleMessage("Не разрешать IP"),
    "none": MessageLookupByLibrary.simpleMessage("Нет"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "Текущая группа прокси не может быть выбрана.",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Нет профиля, пожалуйста, добавьте профиль",
    ),
    "nullTip": m9,
    "numberTip": m10,
    "oneColumn": MessageLookupByLibrary.simpleMessage("Один столбец"),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Только иконка"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage(
      "Только сторонние приложения",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Только статистика прокси",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "При включении будет учитываться только трафик прокси",
    ),
    "options": MessageLookupByLibrary.simpleMessage("Опции"),
    "other": MessageLookupByLibrary.simpleMessage("Другое"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Другие участники",
    ),
    "outboundMode": MessageLookupByLibrary.simpleMessage(
      "Режим исходящего трафика",
    ),
    "override": MessageLookupByLibrary.simpleMessage("Переопределить"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage(
      "Переопределить конфигурацию, связанную с прокси",
    ),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Переопределить DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Включение переопределит настройки DNS в профиле",
    ),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "В скриптовом режиме не действует",
    ),
    "overrideMode": MessageLookupByLibrary.simpleMessage(
      "Режим переопределения",
    ),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage(
      "Переопределить оригинальное правило",
    ),
    "overrideScript": MessageLookupByLibrary.simpleMessage(
      "Скрипт переопределения",
    ),
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage(
      "Пользовательский",
    ),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "Пользовательский режим, полная настройка групп прокси и правил",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("Палитра"),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "paste": MessageLookupByLibrary.simpleMessage("Вставить"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, привяжите WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите название скрипта",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите пароль администратора",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, загрузите файл",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, загрузите действительный QR-код",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Порт"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Введите другой порт",
    ),
    "portTip": m11,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Приоритетное использование HTTP/3 для DOH",
    ),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, нажмите клавишу.",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Предпросмотр"),
    "process": MessageLookupByLibrary.simpleMessage("процесс"),
    "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Пожалуйста, введите действительный формат интервала времени",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Пожалуйста, введите интервал времени для автообновления",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "Профиль был изменен. Хотите отключить автообновление?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите имя профиля",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "ошибка разбора профиля",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите действительный URL профиля",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите URL профиля",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Профили"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Сортировка профилей"),
    "project": MessageLookupByLibrary.simpleMessage("Проект"),
    "providers": MessageLookupByLibrary.simpleMessage("Провайдеры"),
    "proxies": MessageLookupByLibrary.simpleMessage("Прокси"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("Настройка прокси"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("Цепочки прокси"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Группа прокси"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage(
      "Прокси-сервер имен",
    ),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Домен для разрешения прокси-узлов",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("Порт прокси"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage(
      "Установить порт прослушивания Clash",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Провайдеры прокси"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Очистить кэш"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Чисто черный режим"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR-код"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Сканируйте QR-код для получения профиля",
    ),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("Радужные"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir-порт"),
    "redo": MessageLookupByLibrary.simpleMessage("Повторить"),
    "regExp": MessageLookupByLibrary.simpleMessage("Регулярное выражение"),
    "reload": MessageLookupByLibrary.simpleMessage("Перезагрузить"),
    "remote": MessageLookupByLibrary.simpleMessage("Удаленный"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование локальных данных на WebDAV",
    ),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Удалённое назначение",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Удалить"),
    "rename": MessageLookupByLibrary.simpleMessage("Переименовать"),
    "request": MessageLookupByLibrary.simpleMessage("Запрос"),
    "requests": MessageLookupByLibrary.simpleMessage("Запросы"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "Просмотр последних записей запросов",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Сброс"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "На текущей странице есть изменения. Вы уверены, что хотите сбросить?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "Убедитесь, что хотите сбросить",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Ресурсы"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "Информация, связанная с внешними ресурсами",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Соблюдение правил"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS-соединение следует правилам, необходимо настроить proxy-server-nameserver",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("Перезапустить"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите перезапустить ядро?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Восстановить"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage(
      "Восстановить все данные",
    ),
    "restoreException": MessageLookupByLibrary.simpleMessage(
      "Ошибка восстановления",
    ),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановить данные из файла",
    ),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановить данные через WebDAV",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Восстановить только файлы конфигурации",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия восстановления",
    ),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Совместимый",
    ),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Перезаписать",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Восстановление успешно",
    ),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Адрес маршрутизации"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Настройка адреса прослушивания маршрутизации",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Режим маршрутизации"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Обход частных адресов маршрутизации",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage(
      "Использовать конфигурацию",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("Русский"),
    "rule": MessageLookupByLibrary.simpleMessage("Правило"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Название правила"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Провайдеры правил"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Цель правила"),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Сохранить изменения?"),
    "saveTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите сохранить?",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Скрипт"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Режим скрипта, использование внешних расширяющих скриптов, предоставление возможности переопределения конфигурации одним кликом",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "seconds": MessageLookupByLibrary.simpleMessage("Секунд"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Выбрать все"),
    "selected": MessageLookupByLibrary.simpleMessage("Выбрано"),
    "selectedCountTitle": m12,
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "show": MessageLookupByLibrary.simpleMessage("Показать"),
    "shrink": MessageLookupByLibrary.simpleMessage("Сжать"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Тихий запуск"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Запуск в фоновом режиме",
    ),
    "size": MessageLookupByLibrary.simpleMessage("Размер"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks-порт"),
    "sort": MessageLookupByLibrary.simpleMessage("Сортировка"),
    "source": MessageLookupByLibrary.simpleMessage("Источник"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Исходный IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Специальный прокси"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Специальные правила"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage(
      "Статистика скорости",
    ),
    "stackMode": MessageLookupByLibrary.simpleMessage("Режим стека"),
    "standard": MessageLookupByLibrary.simpleMessage("Стандартный"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Стандартный режим, переопределение базовой конфигурации, предоставление возможности простого добавления правил",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Старт"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Запуск VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("Статус"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "Системный DNS будет использоваться при выключении",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Стоп"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Остановка VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("Стиль"),
    "subRule": MessageLookupByLibrary.simpleMessage("Подправило"),
    "submit": MessageLookupByLibrary.simpleMessage("Отправить"),
    "sync": MessageLookupByLibrary.simpleMessage("Синхронизация"),
    "system": MessageLookupByLibrary.simpleMessage("Система"),
    "systemApp": MessageLookupByLibrary.simpleMessage("Системное приложение"),
    "systemFont": MessageLookupByLibrary.simpleMessage("Системный шрифт"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Прикрепить HTTP-прокси к VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Вкладка"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Анимация вкладок"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Действительно только в мобильном виде",
    ),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP параллелизм"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Включение позволит использовать параллелизм TCP",
    ),
    "testUrl": MessageLookupByLibrary.simpleMessage("Тест URL"),
    "textScale": MessageLookupByLibrary.simpleMessage("Масштабирование текста"),
    "theme": MessageLookupByLibrary.simpleMessage("Тема"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Цвет темы"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Установить темный режим, настроить цвет",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Режим темы"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("Три столбца"),
    "tight": MessageLookupByLibrary.simpleMessage("Плотный"),
    "time": MessageLookupByLibrary.simpleMessage("Время"),
    "tip": MessageLookupByLibrary.simpleMessage("подсказка"),
    "toggle": MessageLookupByLibrary.simpleMessage("Переключить"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("Тональный акцент"),
    "tools": MessageLookupByLibrary.simpleMessage("Инструменты"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy-порт"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage(
      "Использование трафика",
    ),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "действительно только в режиме администратора",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Выключить"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Включить"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("Два столбца"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "невозможно обновить текущий профиль",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("Отменить"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage(
      "Унифицированная задержка",
    ),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Убрать дополнительные задержки, такие как рукопожатие",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Неизвестная сетевая ошибка",
    ),
    "unnamed": MessageLookupByLibrary.simpleMessage("Без имени"),
    "update": MessageLookupByLibrary.simpleMessage("Обновить"),
    "upload": MessageLookupByLibrary.simpleMessage("Загрузка"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage(
      "Получить профиль через URL",
    ),
    "urlTip": m13,
    "useHosts": MessageLookupByLibrary.simpleMessage("Использовать hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage(
      "Использовать системные hosts",
    ),
    "vAboutCannotOpen": m14,
    "vAboutChecking": MessageLookupByLibrary.simpleMessage("Проверка…"),
    "vAboutContactSection": MessageLookupByLibrary.simpleMessage(
      "Контакты и поддержка",
    ),
    "vAboutCreditsBody": MessageLookupByLibrary.simpleMessage(
      "Благодарим FlClash (chen08209), команду Mihomo (Clash.Meta), команду sing-box и всё сообщество открытого сетевого ПО. Сетевые возможности Verstro построены на этих проектах.",
    ),
    "vAboutCreditsSection": MessageLookupByLibrary.simpleMessage(
      "Благодарности",
    ),
    "vAboutEmail": MessageLookupByLibrary.simpleMessage("Эл. почта"),
    "vAboutOssBody": MessageLookupByLibrary.simpleMessage(
      "Клиент Verstro создан на основе открытого проекта FlClash (GPLv3); ядра — Mihomo / sing-box (оба GPLv3). В соответствии с GPLv3 полный исходный код клиента открыт.",
    ),
    "vAboutOssSection": MessageLookupByLibrary.simpleMessage(
      "Открытый код и лицензии",
    ),
    "vAboutPrivacyBody": MessageLookupByLibrary.simpleMessage(
      "• Эл. почта используется только для уведомлений об оплате и восстановления пароля — без рекламных рассылок\n• Мы не собираем ID устройства, геолокацию и контакты\n• Статистика трафика учитывает только объём, но не содержимое\n• Платежи принимаются on-chain через собственную инфраструктуру, без сторонних посредников",
    ),
    "vAboutPrivacySection": MessageLookupByLibrary.simpleMessage(
      "Обязательства по приватности",
    ),
    "vAboutSlogan": MessageLookupByLibrary.simpleMessage(
      "Глобальная сеть с приоритетом приватности",
    ),
    "vAboutSourceCode": MessageLookupByLibrary.simpleMessage(
      "Исходный код и лицензия",
    ),
    "vAboutTelegramGroup": MessageLookupByLibrary.simpleMessage(
      "Сообщество в Telegram",
    ),
    "vAboutTitle": MessageLookupByLibrary.simpleMessage("О Verstro"),
    "vAboutVisitWebsite": MessageLookupByLibrary.simpleMessage("Открыть сайт"),
    "vAboutWebsiteSection": MessageLookupByLibrary.simpleMessage(
      "Официальный сайт",
    ),
    "vAcctActiveDaysAgo": m15,
    "vAcctActiveHoursAgo": m16,
    "vAcctActiveJustNow": MessageLookupByLibrary.simpleMessage(
      "Активность: только что",
    ),
    "vAcctActiveMinutesAgo": m17,
    "vAcctAgentCenter": MessageLookupByLibrary.simpleMessage(
      "Партнёрский центр",
    ),
    "vAcctAgentEntrySubtitle": m18,
    "vAcctAgentTierAgent": MessageLookupByLibrary.simpleMessage(
      "Сертифицированный реселлер",
    ),
    "vAcctAgentTierMaster": MessageLookupByLibrary.simpleMessage(
      "Стратегический дистрибьютор",
    ),
    "vAcctAgentWithdrawable": m19,
    "vPayLocalExpiryTitle": MessageLookupByLibrary.simpleMessage("Срок оплаты истёк"),
    "vPayLocalExpiryDesc": MessageLookupByLibrary.simpleMessage("Не переводите дополнительные средства. Ожидается подтверждение сервера. Если вы уже оплатили, отправьте ID транзакции для проверки."),
    "vAcctPendingTitle": MessageLookupByLibrary.simpleMessage("Получено по заказам с доплатой"),
    "vAcctPendingSubtitle": MessageLookupByLibrary.simpleMessage("Средства закреплены за этими заказами и недоступны для других покупок."),
    "vAcctPendingReceived": MessageLookupByLibrary.simpleMessage("Получено"),
    "vAcctPendingRemaining": MessageLookupByLibrary.simpleMessage("Осталось"),
    "vAcctPendingTransfer": MessageLookupByLibrary.simpleMessage("Ожидает перевода на баланс"),
    "vAcctPendingContinue": MessageLookupByLibrary.simpleMessage("Продолжить оплату"),
    "vAcctCreditError": MessageLookupByLibrary.simpleMessage("Не удалось загрузить баланс. Повторите попытку"),
    "vAcctBalanceSubtitle": MessageLookupByLibrary.simpleMessage(
      "Списывается при покупке · средства незавершённых заказов не входят в доступный баланс",
    ),
    "vAcctBalanceTitle": m20,
    "vAcctBootFailed": MessageLookupByLibrary.simpleMessage("Ошибка запуска"),
    "vAcctBootFailedWithError": m21,
    "vAcctBuyPlan": MessageLookupByLibrary.simpleMessage("Купить тариф"),
    "vAcctCheckingSubscription": MessageLookupByLibrary.simpleMessage(
      "Проверка статуса подписки...",
    ),
    "vAcctCopySubscriptionUrl": MessageLookupByLibrary.simpleMessage(
      "Скопировать ссылку на подписку",
    ),
    "vAcctDaysLater": m22,
    "vAcctDevicesEntrySubtitle": MessageLookupByLibrary.simpleMessage(
      "Управление устройствами, где выполнен вход",
    ),
    "vAcctDevicesLimitHint": MessageLookupByLibrary.simpleMessage(
      "При превышении лимита устройств вход с нового устройства автоматически завершает сеанс на устройстве с самой давней активностью",
    ),
    "vAcctDevicesRegistered": m23,
    "vAcctDevicesRegisteredNoMax": m24,
    "vAcctDevicesUnavailable": MessageLookupByLibrary.simpleMessage(
      "Список устройств временно недоступен",
    ),
    "vAcctEmailUnverified": MessageLookupByLibrary.simpleMessage(
      "Email не подтверждён (нужен для восстановления пароля)",
    ),
    "vAcctEmailVerified": MessageLookupByLibrary.simpleMessage(
      "Email подтверждён",
    ),
    "vAcctExpired": MessageLookupByLibrary.simpleMessage("Истёк срок"),
    "vAcctExpiresOn": m25,
    "vAcctGrantActive": MessageLookupByLibrary.simpleMessage("Активен"),
    "vAcctGrantExhausted": MessageLookupByLibrary.simpleMessage("Исчерпан"),
    "vAcctHoursLater": m26,
    "vAcctLogout": MessageLookupByLibrary.simpleMessage("Выйти"),
    "vAcctLogoutDevice": MessageLookupByLibrary.simpleMessage(
      "Выйти на этом устройстве",
    ),
    "vAcctLogoutDeviceContent": m27,
    "vAcctLogoutDeviceTitle": MessageLookupByLibrary.simpleMessage(
      "Выйти на этом устройстве?",
    ),
    "vAcctLogoutFailed": m28,
    "vAcctMinutesLater": m29,
    "vAcctMultiPlanBadge": MessageLookupByLibrary.simpleMessage(
      "Неск. тарифов",
    ),
    "vAcctMyDevices": MessageLookupByLibrary.simpleMessage("Мои устройства"),
    "vAcctNoDevices": MessageLookupByLibrary.simpleMessage(
      "Нет зарегистрированных устройств",
    ),
    "vAcctNoOrders": MessageLookupByLibrary.simpleMessage("Заказов пока нет"),
    "vAcctNoSubscription": MessageLookupByLibrary.simpleMessage("Нет подписки"),
    "vAcctNoSubscriptionDesc": MessageLookupByLibrary.simpleMessage(
      "Купите тариф, чтобы начать пользоваться Verstro VPN.",
    ),
    "vAcctOrderFailed": MessageLookupByLibrary.simpleMessage("Ошибка"),
    "vAcctOrderHistory": MessageLookupByLibrary.simpleMessage(
      "История заказов",
    ),
    "vAcctOrderHistorySubtitle": MessageLookupByLibrary.simpleMessage(
      "Просмотр прошлых заказов и платежей",
    ),
    "vAcctOrderPaid": MessageLookupByLibrary.simpleMessage("Оплачен"),
    "vAcctOrderWaiting": MessageLookupByLibrary.simpleMessage("Ожидает оплаты"),
    "vAcctOrdersQueryFailed": m30,
    "vAcctPageTitle": MessageLookupByLibrary.simpleMessage("Мой аккаунт"),
    "vAcctPlanDetails": MessageLookupByLibrary.simpleMessage("Детали тарифов"),
    "vAcctPlanLabel": MessageLookupByLibrary.simpleMessage("Тариф"),
    "vAcctPlanPremiumMonthly": MessageLookupByLibrary.simpleMessage(
      "Про · месяц",
    ),
    "vAcctPlanPremiumQuarterly": MessageLookupByLibrary.simpleMessage(
      "Про · квартал",
    ),
    "vAcctPlanPremiumYearly": MessageLookupByLibrary.simpleMessage("Про · год"),
    "vAcctPlanStandardMonthly": MessageLookupByLibrary.simpleMessage(
      "Стандарт · месяц",
    ),
    "vAcctPlanStandardQuarterly": MessageLookupByLibrary.simpleMessage(
      "Стандарт · квартал",
    ),
    "vAcctPlanStandardYearly": MessageLookupByLibrary.simpleMessage(
      "Стандарт · год",
    ),
    "vAcctRefresh": MessageLookupByLibrary.simpleMessage("Обновить"),
    "vAcctRemainingBytes": m31,
    "vAcctRemainingLabel": MessageLookupByLibrary.simpleMessage("Осталось"),
    "vAcctRenewUpgrade": MessageLookupByLibrary.simpleMessage(
      "Продлить / повысить тариф",
    ),
    "vAcctRepurchase": MessageLookupByLibrary.simpleMessage("Купить снова"),
    "vAcctRetry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "vAcctSubActive": MessageLookupByLibrary.simpleMessage("Активна"),
    "vAcctSubExpired": MessageLookupByLibrary.simpleMessage("Истекла"),
    "vAcctSubQueryFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить статус подписки",
    ),
    "vAcctSubQueryFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Не удалось проверить подписку",
    ),
    "vAcctSubscriptionUrlCopied": MessageLookupByLibrary.simpleMessage(
      "Ссылка на подписку скопирована",
    ),
    "vAcctSubscriptionUrlDesc": MessageLookupByLibrary.simpleMessage(
      "Можно скопировать и импортировать в сторонние клиенты, например Shadowrocket (в частности на устройствах iOS).",
    ),
    "vAcctSubscriptionUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Ссылка на подписку",
    ),
    "vAcctTapToContinuePayment": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы продолжить оплату",
    ),
    "vAcctTapToReorder": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы оформить заказ заново",
    ),
    "vAcctThisDevice": MessageLookupByLibrary.simpleMessage("Это устройство"),
    "vAcctTotalRemainingLabel": MessageLookupByLibrary.simpleMessage(
      "Всего осталось",
    ),
    "vAcctTrafficLimitLabel": MessageLookupByLibrary.simpleMessage(
      "Лимит трафика",
    ),
    "vAcctTrafficNearLimit": MessageLookupByLibrary.simpleMessage(
      "Трафик почти исчерпан — рекомендуем повысить тариф",
    ),
    "vAcctTrafficUsage": MessageLookupByLibrary.simpleMessage(
      "Использование трафика",
    ),
    "vAcctTryLater": MessageLookupByLibrary.simpleMessage(
      "Повторите попытку позже",
    ),
    "vAcctUnknownDevice": MessageLookupByLibrary.simpleMessage(
      "Неизвестное устройство",
    ),
    "vAcctVerifyCodeSentDesc": m32,
    "vAcctVerifyEmailTitle": MessageLookupByLibrary.simpleMessage(
      "Подтвердите email",
    ),
    "vAgentAvailable": m33,
    "vAgentChangePrice": MessageLookupByLibrary.simpleMessage("Изменить цену"),
    "vAgentCopyInviteCode": MessageLookupByLibrary.simpleMessage(
      "Скопировать код приглашения",
    ),
    "vAgentCopyShareText": MessageLookupByLibrary.simpleMessage(
      "Скопировать текст",
    ),
    "vAgentCopyTxid": MessageLookupByLibrary.simpleMessage("Скопировать txid"),
    "vAgentDestLine": m34,
    "vAgentInviteCode": MessageLookupByLibrary.simpleMessage("Код приглашения"),
    "vAgentInviteCodeCopied": MessageLookupByLibrary.simpleMessage(
      "Код приглашения скопирован",
    ),
    "vAgentInvitedCount": m35,
    "vAgentLoadFailed": MessageLookupByLibrary.simpleMessage("Ошибка загрузки"),
    "vAgentMinimumSaleLine": m36,
    "vAgentNextStep": MessageLookupByLibrary.simpleMessage("Далее"),
    "vAgentOpenBrowserFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть браузер. Проверьте эту транзакцию на tronscan.org вручную.",
    ),
    "vAgentPaid": m37,
    "vAgentPanelTitle": MessageLookupByLibrary.simpleMessage(
      "Партнёрский центр",
    ),
    "vAgentPayoutAddrInvalid": MessageLookupByLibrary.simpleMessage(
      "Введите корректный адрес TRC20",
    ),
    "vAgentPayoutAddrLabel": MessageLookupByLibrary.simpleMessage(
      "Адрес TRC20 (начинается с T, 34 символа)",
    ),
    "vAgentPayoutBelowMin": m38,
    "vAgentPayoutButton": MessageLookupByLibrary.simpleMessage(
      "Вывести на TRC20",
    ),
    "vAgentPayoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Подтвердить вывод",
    ),
    "vAgentPayoutConfirmContent": m39,
    "vAgentPayoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Вывод на адрес TRC20",
    ),
    "vAgentPayoutFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось выполнить вывод. Повторите попытку.",
    ),
    "vAgentPayoutGuardProcessing": MessageLookupByLibrary.simpleMessage(
      "Выплата уже обрабатывается. Новую можно запросить после её завершения.",
    ),
    "vAgentPayoutHistory": MessageLookupByLibrary.simpleMessage(
      "История выплат",
    ),
    "vAgentPayoutInProgress": MessageLookupByLibrary.simpleMessage(
      "Выплата уже в обработке. Новую можно запросить после её завершения.",
    ),
    "vAgentPayoutInvalidDest": MessageLookupByLibrary.simpleMessage(
      "Неверный адрес получения. Проверьте адрес TRC20.",
    ),
    "vAgentPayoutRefundedDesc": MessageLookupByLibrary.simpleMessage(
      "Перевод не прошёл — сумма возвращена на доступный баланс.",
    ),
    "vAgentPayoutSubmitted": MessageLookupByLibrary.simpleMessage(
      "Заявка на вывод отправлена. Ожидайте ручную выплату (обычно в течение 24 часов).",
    ),
    "vAgentPayoutThinkAgain": MessageLookupByLibrary.simpleMessage(
      "Ещё подумаю",
    ),
    "vAgentPayoutThreshold": m40,
    "vAgentPending": m41,
    "vAgentPlanPricing": MessageLookupByLibrary.simpleMessage("Цены на планы"),
    "vAgentPlanTitle": m42,
    "vAgentPlatformFloorLine": m43,
    "vAgentPriceLabel": MessageLookupByLibrary.simpleMessage("Цена (USD)"),
    "vAgentPriceNotNumber": MessageLookupByLibrary.simpleMessage(
      "Введите число",
    ),
    "vAgentPriceOutOfRange": m44,
    "vAgentPriceRangeHint": m45,
    "vAgentPriceSetFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось установить цену. Повторите попытку.",
    ),
    "vAgentPriceSetSuccess": m46,
    "vAgentPriceUnset": m47,
    "vAgentProcessing": m48,
    "vAgentRetry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "vAgentSetPriceTitle": m49,
    "vAgentSharePoster": MessageLookupByLibrary.simpleMessage("Постер"),
    "vAgentShareText": m50,
    "vAgentShareTextCopied": MessageLookupByLibrary.simpleMessage(
      "Текст скопирован",
    ),
    "vAgentStatusProcessing": MessageLookupByLibrary.simpleMessage(
      "Выплата вручную",
    ),
    "vAgentStatusRefunded": MessageLookupByLibrary.simpleMessage("Возвращено"),
    "vAgentStatusSent": MessageLookupByLibrary.simpleMessage("Выплачено"),
    "vAgentSubAgentLine": m51,
    "vAgentTierMaster": MessageLookupByLibrary.simpleMessage(
      "Стратегический дистрибьютор",
    ),
    "vAgentTierPromoter": MessageLookupByLibrary.simpleMessage("Промоутер"),
    "vAgentTierReseller": MessageLookupByLibrary.simpleMessage(
      "Сертифицированный реселлер",
    ),
    "vAgentTxidCopied": MessageLookupByLibrary.simpleMessage("txid скопирован"),
    "vAgentViewOnTronScan": MessageLookupByLibrary.simpleMessage(
      "Открыть в TronScan",
    ),
    "vAgentWalletTitle": MessageLookupByLibrary.simpleMessage(
      "Кошелёк комиссий",
    ),
    "vAgentYourPriceLine": m52,
    "vApiBadRequest": MessageLookupByLibrary.simpleMessage(
      "Неверные параметры запроса",
    ),
    "vApiConflict": MessageLookupByLibrary.simpleMessage("Конфликт операции"),
    "vApiConnectFailed": m53,
    "vApiEmailTaken": MessageLookupByLibrary.simpleMessage(
      "Этот адрес эл. почты уже зарегистрирован",
    ),
    "vApiForbidden": MessageLookupByLibrary.simpleMessage("Нет прав доступа"),
    "vApiInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Неверный адрес эл. почты или пароль",
    ),
    "vApiNoActiveBackend": MessageLookupByLibrary.simpleMessage(
      "Не удалось подключиться ни к одному из резервных доменов. Проверьте сеть",
    ),
    "vApiNotFound": MessageLookupByLibrary.simpleMessage("Ресурс не найден"),
    "vApiNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "Вы не вошли в систему или сессия истекла",
    ),
    "vApiRequestCancelled": MessageLookupByLibrary.simpleMessage(
      "Запрос отменён",
    ),
    "vApiRequestTimeout": MessageLookupByLibrary.simpleMessage(
      "Время ожидания запроса истекло. Проверьте сеть или VPN",
    ),
    "vApiServerError": MessageLookupByLibrary.simpleMessage(
      "Ошибка сервера, попробуйте позже",
    ),
    "vApiServerErrorStatus": m54,
    "vApiTlsCertError": m55,
    "vApiTokenExpired": MessageLookupByLibrary.simpleMessage(
      "Сессия входа истекла, войдите снова",
    ),
    "vApiTokenInvalid": MessageLookupByLibrary.simpleMessage(
      "Недействительные учётные данные",
    ),
    "vApiUnauthorized": MessageLookupByLibrary.simpleMessage("Нет авторизации"),
    "vApiUnexpectedResponseType": m56,
    "vApiUnexpectedStatus": m57,
    "vAppCountryAu": MessageLookupByLibrary.simpleMessage("Австралия"),
    "vAppCountryCa": MessageLookupByLibrary.simpleMessage("Канада"),
    "vAppCountryCn": MessageLookupByLibrary.simpleMessage("Китай"),
    "vAppCountryDe": MessageLookupByLibrary.simpleMessage("Германия"),
    "vAppCountryFr": MessageLookupByLibrary.simpleMessage("Франция"),
    "vAppCountryGb": MessageLookupByLibrary.simpleMessage("Великобритания"),
    "vAppCountryHk": MessageLookupByLibrary.simpleMessage("Гонконг"),
    "vAppCountryId": MessageLookupByLibrary.simpleMessage("Индонезия"),
    "vAppCountryIn": MessageLookupByLibrary.simpleMessage("Индия"),
    "vAppCountryJp": MessageLookupByLibrary.simpleMessage("Япония"),
    "vAppCountryKr": MessageLookupByLibrary.simpleMessage("Южная Корея"),
    "vAppCountryMo": MessageLookupByLibrary.simpleMessage("Макао"),
    "vAppCountryMy": MessageLookupByLibrary.simpleMessage("Малайзия"),
    "vAppCountryNl": MessageLookupByLibrary.simpleMessage("Нидерланды"),
    "vAppCountryPh": MessageLookupByLibrary.simpleMessage("Филиппины"),
    "vAppCountryRu": MessageLookupByLibrary.simpleMessage("Россия"),
    "vAppCountrySg": MessageLookupByLibrary.simpleMessage("Сингапур"),
    "vAppCountryTh": MessageLookupByLibrary.simpleMessage("Таиланд"),
    "vAppCountryTr": MessageLookupByLibrary.simpleMessage("Турция"),
    "vAppCountryTw": MessageLookupByLibrary.simpleMessage("Тайвань"),
    "vAppCountryUs": MessageLookupByLibrary.simpleMessage("США"),
    "vAppCountryVn": MessageLookupByLibrary.simpleMessage("Вьетнам"),
    "vAppLogout": MessageLookupByLibrary.simpleMessage("Выйти"),
    "vAppLogoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Вы действительно хотите выйти из текущего аккаунта?",
    ),
    "vAppModeGlobal": MessageLookupByLibrary.simpleMessage("Глобальный"),
    "vAppModeRule": MessageLookupByLibrary.simpleMessage("Смарт"),
    "vAppProfilesSyncingTip": MessageLookupByLibrary.simpleMessage(
      "Синхронизация подписки… Если список долго остаётся пустым, потяните вниз на странице «Аккаунт», чтобы обновить, или войдите заново.",
    ),
    "vAppShareSubtitle": MessageLookupByLibrary.simpleMessage(
      "Пригласите друзей — вознаграждение получите вы оба",
    ),
    "vAppShareTitle": MessageLookupByLibrary.simpleMessage(
      "Поделиться Verstro",
    ),
    "vAuthBackToLogin": MessageLookupByLibrary.simpleMessage("Назад ко входу"),
    "vAuthCodeHint": MessageLookupByLibrary.simpleMessage("6 цифр"),
    "vAuthCodeLabel": MessageLookupByLibrary.simpleMessage("Код подтверждения"),
    "vAuthCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Введите код подтверждения",
    ),
    "vAuthCodeResent": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения отправлен повторно. Проверьте почту",
    ),
    "vAuthCodeSent": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения отправлен. Проверьте почту",
    ),
    "vAuthConfirmNewPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Подтвердите новый пароль",
    ),
    "vAuthConfirmNewPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Введите новый пароль ещё раз",
    ),
    "vAuthConfirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Подтвердите пароль",
    ),
    "vAuthConfirmPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Введите пароль ещё раз",
    ),
    "vAuthEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Неверный формат адреса эл. почты",
    ),
    "vAuthEmailLabel": MessageLookupByLibrary.simpleMessage("Эл. почта"),
    "vAuthEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Введите адрес эл. почты",
    ),
    "vAuthEmailVerified": MessageLookupByLibrary.simpleMessage(
      "Эл. почта подтверждена ✓",
    ),
    "vAuthForgotIntro": MessageLookupByLibrary.simpleMessage(
      "Введите адрес эл. почты, указанный при регистрации, — мы отправим 6-значный код подтверждения (действителен 10 минут).",
    ),
    "vAuthForgotPasswordLink": MessageLookupByLibrary.simpleMessage(
      "Забыли пароль?",
    ),
    "vAuthForgotPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Забыли пароль",
    ),
    "vAuthGoToLogin": MessageLookupByLibrary.simpleMessage(
      "Уже есть аккаунт? Войти",
    ),
    "vAuthGoToRegister": MessageLookupByLibrary.simpleMessage(
      "Нет аккаунта? Зарегистрируйтесь",
    ),
    "vAuthLoginButton": MessageLookupByLibrary.simpleMessage("Войти"),
    "vAuthLoginFailed": m58,
    "vAuthLoginTitle": MessageLookupByLibrary.simpleMessage("Вход в Verstro"),
    "vAuthNewPasswordLabelMin8": MessageLookupByLibrary.simpleMessage(
      "Новый пароль (не менее 8 символов)",
    ),
    "vAuthNewPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Введите новый пароль",
    ),
    "vAuthPasswordLabelMin6": MessageLookupByLibrary.simpleMessage(
      "Пароль (не менее 6 символов)",
    ),
    "vAuthPasswordMin6": MessageLookupByLibrary.simpleMessage(
      "Пароль должен содержать не менее 6 символов",
    ),
    "vAuthPasswordMin8": MessageLookupByLibrary.simpleMessage(
      "Пароль должен содержать не менее 8 символов",
    ),
    "vAuthPasswordMismatch": MessageLookupByLibrary.simpleMessage(
      "Пароли не совпадают",
    ),
    "vAuthPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Введите пароль",
    ),
    "vAuthPasswordResetDone": MessageLookupByLibrary.simpleMessage(
      "Пароль изменён",
    ),
    "vAuthReferralCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Реферальный код (необязательно)",
    ),
    "vAuthRegisterButton": MessageLookupByLibrary.simpleMessage(
      "Зарегистрироваться",
    ),
    "vAuthRegisterFailed": m59,
    "vAuthRegisterIntro": MessageLookupByLibrary.simpleMessage(
      "Регистрация бесплатна. Эл. почта используется только для восстановления пароля и уведомлений об оплате; подтверждение необязательно.",
    ),
    "vAuthRegisterTitle": MessageLookupByLibrary.simpleMessage(
      "Регистрация в Verstro",
    ),
    "vAuthResendCodeButton": MessageLookupByLibrary.simpleMessage(
      "Отправить код снова",
    ),
    "vAuthResendCodeLink": MessageLookupByLibrary.simpleMessage(
      "Не пришло? Отправить код снова",
    ),
    "vAuthResendCooldown": m60,
    "vAuthResetFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Не удалось сбросить пароль. Проверьте сеть и повторите попытку",
    ),
    "vAuthResetIntro": m61,
    "vAuthResetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Сброс пароля",
    ),
    "vAuthResetSuccessDesc": MessageLookupByLibrary.simpleMessage(
      "Сейчас вы вернётесь на страницу входа. Войдите с новым паролем.",
    ),
    "vAuthResetSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Пароль сброшен",
    ),
    "vAuthSendCodeButton": MessageLookupByLibrary.simpleMessage(
      "Отправить код",
    ),
    "vAuthSendFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить. Проверьте сеть или повторите попытку позже",
    ),
    "vAuthSendFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить. Повторите попытку позже",
    ),
    "vAuthVerifyButton": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "vAuthVerifyFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Не удалось подтвердить. Проверьте сеть и повторите попытку",
    ),
    "vClaimActivated": MessageLookupByLibrary.simpleMessage(
      "Подтверждено — подписка активирована.",
    ),
    "vClaimActivatedOverpay": m73,
    "vClaimAlreadyProcessed": MessageLookupByLibrary.simpleMessage(
      "Эта транзакция уже обработана и не может быть использована повторно. Для проверки отправьте номер заказа и TXID приватно на feedback@verstro.com; никогда не отправляйте пароли, коды подтверждения, приватные ключи или сид-фразы.",
    ),
    "vClaimCreditedExpired": m74,
    "vClaimCreditedNoShortfall": m75,
    "vClaimCreditedUnderpay": m76,
    "vClaimMatchedOtherOrder": MessageLookupByLibrary.simpleMessage(
      "Транзакция сопоставлена с другим заказом. Если другого заказа у вас нет, отправьте номер заказа и TXID приватно на feedback@verstro.com; никогда не отправляйте пароли, коды подтверждения, приватные ключи или сид-фразы.",
    ),
    "vClaimNotFound": MessageLookupByLibrary.simpleMessage(
      "Транзакция ещё не найдена в блокчейне. Проверьте TXID и сеть, затем повторите попытку; не платите повторно.",
    ),
    "vClaimPartiallyPaid": m77,
    "vClaimPendingConfirmation": MessageLookupByLibrary.simpleMessage(
      "Транзакция ожидает подтверждения в блокчейне. Дождитесь подтверждения и повторите попытку; не платите повторно.",
    ),
    "vClaimProviderUnavailable": MessageLookupByLibrary.simpleMessage(
      "Сервис проверки блокчейна временно недоступен. Повторите попытку позже; не платите повторно.",
    ),
    "vClaimRejectedManual": MessageLookupByLibrary.simpleMessage(
      "Транзакция требует ручной проверки. Отправьте номер заказа, адрес регистрации и TXID приватно на feedback@verstro.com; никогда не отправляйте пароли, коды подтверждения, приватные ключи или сид-фразы.",
    ),
    "vClaimSplitPaymentCompleted": m78,
    "vClaimSplitPaymentCredit": m79,
    "vClaimUnsupportedTransfer": MessageLookupByLibrary.simpleMessage(
      "Эта транзакция не является распознаваемым переводом USDT TRC20 и не может быть применена к заказу.",
    ),
    "vClaimVerifyFailed": MessageLookupByLibrary.simpleMessage(
      "Транзакцию пока не удалось проверить. Повторите попытку позже и не платите повторно. Если проблема сохраняется, в публичной группе @verstro_chat сообщите только платформу, версию, текст ошибки и время возникновения.",
    ),
    "vClaimWrongRecipient": m80,
    "vErrCodeExpired": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения истёк — запросите новый",
    ),
    "vErrCodeLocked": MessageLookupByLibrary.simpleMessage(
      "Слишком много попыток — запросите новый код",
    ),
    "vErrCouponDisabled": MessageLookupByLibrary.simpleMessage(
      "Промокод отключён",
    ),
    "vErrCouponInactive": MessageLookupByLibrary.simpleMessage(
      "Промокод ещё не начался или истёк",
    ),
    "vErrCouponInvalid": MessageLookupByLibrary.simpleMessage(
      "Неверный промокод",
    ),
    "vErrCouponLimitReached": MessageLookupByLibrary.simpleMessage(
      "Достигнут лимит использования промокода",
    ),
    "vErrCouponNewUsersOnly": MessageLookupByLibrary.simpleMessage(
      "Только для новых пользователей",
    ),
    "vErrCouponPartnerPriceConflict": MessageLookupByLibrary.simpleMessage(
      "Партнёрская цена не суммируется с промокодами платформы",
    ),
    "vErrCouponPlanMismatch": MessageLookupByLibrary.simpleMessage(
      "Промокод не действует для этого тарифа",
    ),
    "vErrCouponSoldOut": MessageLookupByLibrary.simpleMessage(
      "Промокод исчерпан",
    ),
    "vErrDuplicateCode": MessageLookupByLibrary.simpleMessage(
      "Такой промокод уже существует",
    ),
    "vErrEmailUnverified": MessageLookupByLibrary.simpleMessage(
      "Подтвердите почту перед получением пробного периода",
    ),
    "vErrHasSubscription": MessageLookupByLibrary.simpleMessage(
      "У вас уже есть подписка — пробный период не нужен",
    ),
    "vErrInvalidCode": MessageLookupByLibrary.simpleMessage(
      "Неверный или недействительный код",
    ),
    "vErrInvalidDest": MessageLookupByLibrary.simpleMessage(
      "Укажите действительный адрес TRC20",
    ),
    "vErrInvalidPlan": MessageLookupByLibrary.simpleMessage(
      "Такого тарифа нет",
    ),
    "vErrInvalidReferralCode": MessageLookupByLibrary.simpleMessage(
      "Недействительный реферальный код. Проверьте его и повторите попытку.",
    ),
    "vErrInvalidTxHash": MessageLookupByLibrary.simpleMessage(
      "Неверный формат ID транзакции",
    ),
    "vErrMissingCode": MessageLookupByLibrary.simpleMessage(
      "Введите код подтверждения",
    ),
    "vErrNoSubscription": MessageLookupByLibrary.simpleMessage("Нет подписки"),
    "vErrProvisionFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось начать пробный период — попробуйте ещё раз",
    ),
    "vErrSubExpired": MessageLookupByLibrary.simpleMessage(
      "Срок подписки истёк",
    ),
    "vErrSubProxyDisabled": MessageLookupByLibrary.simpleMessage(
      "Прокси подписки отключён — нечего сбрасывать",
    ),
    "vErrTokenUsed": MessageLookupByLibrary.simpleMessage(
      "Эта ссылка уже использована",
    ),
    "vErrTrialClaimed": MessageLookupByLibrary.simpleMessage(
      "Пробный период уже получен",
    ),
    "vErrTrialDisabled": MessageLookupByLibrary.simpleMessage(
      "Пробный период сейчас недоступен",
    ),
    "vHelpAccountBody": MessageLookupByLibrary.simpleMessage(
      "На странице аккаунта можно проверить состояние подписки, срок действия и вошедшие устройства. Входите только на собственных устройствах. При проблеме с подпиской или устройством сначала проверьте состояние аккаунта и сети.",
    ),
    "vHelpAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Аккаунт, подписка и устройства",
    ),
    "vHelpContactBody": MessageLookupByLibrary.simpleMessage(
      "Публичная группа предназначена только для общей диагностики: укажите платформу, версию приложения, текст ошибки и время возникновения. Конфиденциальные сведения о заказе отправляйте приватной почтой.",
    ),
    "vHelpContactTitle": MessageLookupByLibrary.simpleMessage(
      "Поддержка и обратная связь",
    ),
    "vHelpCoverageTitle": MessageLookupByLibrary.simpleMessage("Охват трафика"),
    "vHelpDesktopCombinations": MessageLookupByLibrary.simpleMessage(
      "Системный прокси включён / Виртуальный сетевой адаптер включён: браузеры и подобные приложения используют системный прокси, а виртуальный адаптер добавляет охват остального трафика. Это наиболее полный охват и рекомендуемый вариант на каждый день.\n\nСистемный прокси включён / Виртуальный сетевой адаптер выключен: охватываются только приложения, соблюдающие системный прокси. Используйте без прав администратора или когда нужен только браузер.\n\nСистемный прокси выключен / Виртуальный сетевой адаптер включён: виртуальный адаптер в основном охватывает трафик устройства. Это подходит опытным пользователям или для диагностики конфликта системного прокси.\n\nСистемный прокси выключен / Виртуальный сетевой адаптер выключен: Verstro активно не принимает большую часть системного трафика. Обычно это не рекомендуется и предназначено только для диагностики.",
    ),
    "vHelpDesktopRecommended": MessageLookupByLibrary.simpleMessage(
      "Рекомендуемая повседневная настройка: Умная маршрутизация + Системный прокси включён + Виртуальный сетевой адаптер включён.",
    ),
    "vHelpFaqConnectedNoEffectA": MessageLookupByLibrary.simpleMessage(
      "Сначала проверьте переключатели Системного прокси и Виртуального сетевого адаптера, текущий режим выхода, узел и другие VPN, затем отключитесь и подключитесь заново. Если проблема сохраняется, убедитесь, что приложение соблюдает системный прокси; на ПК включите Виртуальный сетевой адаптер или временно Глобальный прокси для диагностики, а затем верните Умную маршрутизацию.",
    ),
    "vHelpFaqConnectedNoEffectQ": MessageLookupByLibrary.simpleMessage(
      "Статус показывает подключение, но IP или некоторые приложения не изменились. Что делать?",
    ),
    "vHelpFaqDisableTunA": MessageLookupByLibrary.simpleMessage(
      "Временно выключите Виртуальный сетевой адаптер и оставьте Системный прокси включённым, если он конфликтует с другим VPN, прокси или защитным ПО, некорректно восстанавливается после сна или нужен прокси только для браузера. После диагностики включите виртуальный адаптер снова, чтобы вернуть широкий охват.",
    ),
    "vHelpFaqDisableTunQ": MessageLookupByLibrary.simpleMessage(
      "Когда следует временно выключить Виртуальный сетевой адаптер?",
    ),
    "vHelpFaqGlobalCoverageA": MessageLookupByLibrary.simpleMessage(
      "Нет. Глобальный прокси влияет только на трафик, уже попавший в Verstro. Системный прокси и виртуальный адаптер определяют, трафик каких приложений или системы попадёт туда. Для широкого охвата на ПК включите оба; на мобильном устройстве охват обеспечивает системный VPN-туннель.",
    ),
    "vHelpFaqGlobalCoverageQ": MessageLookupByLibrary.simpleMessage(
      "Означает ли Глобальный прокси, что прокси используется всем устройством?",
    ),
    "vHelpFaqMobileTogglesA": MessageLookupByLibrary.simpleMessage(
      "Android и iOS используют системный VPN-туннель для охвата трафика вместо этих настольных переключателей. Подтвердите разрешение VPN по запросу, затем выберите режим выхода и узел.",
    ),
    "vHelpFaqMobileTogglesQ": MessageLookupByLibrary.simpleMessage(
      "Почему на мобильном устройстве не видны Системный прокси и Виртуальный сетевой адаптер?",
    ),
    "vHelpFaqModeDifferenceA": MessageLookupByLibrary.simpleMessage(
      "Умная маршрутизация по правилам выбирает прямой доступ или узел. Глобальный прокси направляет через текущий узел интернет-трафик, уже попавший в Verstro. Сам по себе Глобальный прокси не расширяет охват трафика, поэтому для повседневного использования предпочтительна Умная маршрутизация.",
    ),
    "vHelpFaqModeDifferenceQ": MessageLookupByLibrary.simpleMessage(
      "Чем Умная маршрутизация отличается от Глобального прокси?",
    ),
    "vHelpFaqProxyAndTunA": MessageLookupByLibrary.simpleMessage(
      "Для повседневного использования включайте оба: Системный прокси охватывает приложения, которые его соблюдают, а Виртуальный сетевой адаптер дополняет остальные. Если Виртуальный сетевой адаптер конфликтует с другим VPN, прокси или защитным ПО, временно выключите Виртуальный сетевой адаптер и оставьте Системный прокси включённым. Без прав администратора или когда нужен прокси только для браузера можно использовать только Системный прокси.",
    ),
    "vHelpFaqProxyAndTunQ": MessageLookupByLibrary.simpleMessage(
      "Нужно ли включать и Системный прокси, и Виртуальный сетевой адаптер?",
    ),
    "vHelpFaqRestoreRecommendedA": MessageLookupByLibrary.simpleMessage(
      "На ПК выберите Умную маршрутизацию, включите Системный прокси и Виртуальный сетевой адаптер, затем отключитесь и подключитесь заново. На мобильном устройстве выберите Умную маршрутизацию и подходящий узел и убедитесь, что разрешение системного VPN всё ещё выдано.",
    ),
    "vHelpFaqRestoreRecommendedQ": MessageLookupByLibrary.simpleMessage(
      "Как восстановить рекомендуемую конфигурацию?",
    ),
    "vHelpFaqTitle": MessageLookupByLibrary.simpleMessage(
      "FAQ и устранение неполадок",
    ),
    "vHelpFaqTunPermissionA": MessageLookupByLibrary.simpleMessage(
      "Виртуальный сетевой адаптер создаёт или изменяет системный сетевой интерфейс, поэтому при первом запуске может потребоваться разрешение администратора. Подтверждайте только системный запрос, который вы распознаёте как Verstro. Verstro никогда не запрашивает и не получает пароль аккаунта или пароль администратора. Без прав сначала используйте Системный прокси.",
    ),
    "vHelpFaqTunPermissionQ": MessageLookupByLibrary.simpleMessage(
      "Почему Виртуальному сетевому адаптеру нужны права администратора?",
    ),
    "vHelpGlobalBody": MessageLookupByLibrary.simpleMessage(
      "Направляет интернет-трафик, уже попавший в Verstro, через текущий узел, сохраняя системные адреса, LAN-трафик и обязательные исключения. Он не берёт автоматически под контроль всё устройство и не обязательно быстрее. Используйте его для недоступного сервиса, единого выходного IP, тестов разработки или временной диагностики, затем вернитесь к Умной маршрутизации.",
    ),
    "vHelpGlobalTitle": MessageLookupByLibrary.simpleMessage(
      "Глобальный прокси",
    ),
    "vHelpIntro": MessageLookupByLibrary.simpleMessage(
      "Режим выхода определяет, как трафик, уже попавший в Verstro, покидает устройство; системный прокси и виртуальный сетевой адаптер определяют, какой трафик попадает в Verstro. Эта справка доступна офлайн.",
    ),
    "vHelpMobileVpnBody": MessageLookupByLibrary.simpleMessage(
      "На Android и iOS системный VPN-туннель обеспечивает охват трафика. При первом подключении подтвердите системный запрос. На мобильном устройстве выберите режим выхода и узел; настольные переключатели системного прокси и виртуального адаптера не показываются.",
    ),
    "vHelpMobileVpnTitle": MessageLookupByLibrary.simpleMessage(
      "Системный VPN-туннель",
    ),
    "vHelpNodesBody": MessageLookupByLibrary.simpleMessage(
      "Для баланса задержки и доступности сначала используйте автоматический выбор. Если сервис работает неожиданно, вручную выберите другой узел и подключитесь заново. Доступность узлов меняется в зависимости от сети.",
    ),
    "vHelpNodesTitle": MessageLookupByLibrary.simpleMessage("Узлы и маршруты"),
    "vHelpOpenLinkFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть ссылку. Повторите попытку позже.",
    ),
    "vHelpOutboundIntro": MessageLookupByLibrary.simpleMessage(
      "Режимы выхода определяют только то, как трафик, уже попавший в Verstro, покидает устройство; они не определяют, какие приложения или системный трафик попадут в Verstro.",
    ),
    "vHelpOutboundTitle": MessageLookupByLibrary.simpleMessage("Режимы выхода"),
    "vHelpPaymentBody": MessageLookupByLibrary.simpleMessage(
      "Перед заказом проверьте план, сумму и сеть. Платите только через сеть и точную сумму, указанную на странице, затем дождитесь подтверждения в блокчейне. По необычному заказу обратитесь в поддержку и приложите его сведения.",
    ),
    "vHelpPaymentTitle": MessageLookupByLibrary.simpleMessage(
      "Покупка и оплата",
    ),
    "vHelpQuickBody": MessageLookupByLibrary.simpleMessage(
      "Войдите в аккаунт, убедитесь, что подписка активна, выберите узел, оставьте Умную маршрутизацию и нажмите «Подключить». Для остановки нажмите «Отключить». При первом использовании виртуального сетевого адаптера или системного VPN подтвердите системный запрос.",
    ),
    "vHelpQuickTitle": MessageLookupByLibrary.simpleMessage("Быстрый старт"),
    "vHelpReplaySubtitle": MessageLookupByLibrary.simpleMessage(
      "Ещё раз просмотрите подключение, режимы и подсказки по платформе, не меняя текущие сетевые настройки.",
    ),
    "vHelpReplayTitle": MessageLookupByLibrary.simpleMessage(
      "Повторить знакомство",
    ),
    "vHelpSmartBody": MessageLookupByLibrary.simpleMessage(
      "По правилам локальные сети, LAN-ресурсы и сервисы, подходящие для прямого доступа, остаются прямыми, а трафик, которому нужен прокси, идёт через узел. Обычно это снижает задержку и расход трафика и упрощает доступ к принтерам и NAS, поэтому режим рекомендуется на каждый день.",
    ),
    "vHelpSmartTitle": MessageLookupByLibrary.simpleMessage(
      "Умная маршрутизация",
    ),
    "vHelpSystemProxyBody": MessageLookupByLibrary.simpleMessage(
      "При включении Verstro записывает системные настройки прокси, поэтому браузеры и другие приложения, соблюдающие системный прокси, попадают в Verstro. При выключении этот путь больше не используется. Не требуется виртуальный адаптер и нужно меньше разрешений, но терминалы, Git, Docker, игры и некоторые настольные приложения могут его игнорировать.",
    ),
    "vHelpSystemProxyTitle": MessageLookupByLibrary.simpleMessage(
      "Системный прокси",
    ),
    "vHelpTitle": MessageLookupByLibrary.simpleMessage("Справочный центр"),
    "vHelpTunBody": MessageLookupByLibrary.simpleMessage(
      "При включении создаётся виртуальный сетевой интерфейс, который принимает трафик на системном сетевом уровне, включая приложения, не читающие системный прокси. При выключении системный охват прекращается и остаются только системный прокси или пути, настроенные вручную в приложениях. Это подходит для терминалов, Git, brew, Docker, Electron и подобных приложений. При первом запуске может понадобиться разрешение администратора; возможны конфликты с другими VPN, прокси или защитным ПО. Виртуальный адаптер можно использовать с Умной маршрутизацией; это не Глобальный прокси.",
    ),
    "vHelpTunTitle": MessageLookupByLibrary.simpleMessage(
      "Виртуальный сетевой адаптер (TUN)",
    ),
    "vHelpUpdateBody": MessageLookupByLibrary.simpleMessage(
      "Загружайте обновления из официальных источников. Если установка или обновление не удаётся, проверьте свободное место, системные разрешения и источник пакета. Не используйте изменённые пакеты из неизвестных источников.",
    ),
    "vHelpUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "Обновления и установка",
    ),
    "vHelpWebSubtitle": MessageLookupByLibrary.simpleMessage(
      "Открыть справочный центр сайта в системном браузере.",
    ),
    "vHelpWebTitle": MessageLookupByLibrary.simpleMessage(
      "Открыть полную веб-справку",
    ),
    "vOnboardingBack": MessageLookupByLibrary.simpleMessage("Назад"),
    "vOnboardingConnectDesktopBody": MessageLookupByLibrary.simpleMessage(
      "Нажмите кнопку подключения на главном экране, чтобы подключиться или отключиться. При первом запуске может потребоваться системное разрешение.",
    ),
    "vOnboardingConnectMobileBody": MessageLookupByLibrary.simpleMessage(
      "Нажмите кнопку подключения на главном экране, чтобы подключиться или отключиться. При первом подключении может потребоваться разрешение системного VPN.",
    ),
    "vOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Подключение",
    ),
    "vOnboardingFinish": MessageLookupByLibrary.simpleMessage("Готово"),
    "vOnboardingHelpBody": MessageLookupByLibrary.simpleMessage(
      "Позже знакомство можно повторить через значок вопроса на панели или «Настройки → Справочный центр».",
    ),
    "vOnboardingHelpTitle": MessageLookupByLibrary.simpleMessage("Справка"),
    "vOnboardingNext": MessageLookupByLibrary.simpleMessage("Далее"),
    "vOnboardingOpenHelp": MessageLookupByLibrary.simpleMessage(
      "Открыть справочный центр",
    ),
    "vOnboardingOutboundBody": MessageLookupByLibrary.simpleMessage(
      "Для повседневного использования рекомендуется Умная маршрутизация. Включайте Глобальный прокси временно только для единого выхода или диагностики.",
    ),
    "vOnboardingSkip": MessageLookupByLibrary.simpleMessage("Пропустить"),
    "vPartnerAuthorizationCode": m81,
    "vPartnerCertifiedAffiliate": MessageLookupByLibrary.simpleMessage(
      "Сертифицированный партнёр",
    ),
    "vPartnerCertifiedReseller": MessageLookupByLibrary.simpleMessage(
      "Сертифицированный реселлер",
    ),
    "vPartnerNonExclusive": MessageLookupByLibrary.simpleMessage(
      "Стандартное партнёрство не является эксклюзивным",
    ),
    "vPartnerStrategicDistributor": MessageLookupByLibrary.simpleMessage(
      "Стратегический дистрибьютор",
    ),
    "vPartnerVerified": MessageLookupByLibrary.simpleMessage(
      "Сертифицировано Verstro",
    ),
    "vPayAddressCopied": MessageLookupByLibrary.simpleMessage(
      "Адрес для оплаты скопирован",
    ),
    "vPayAmountCopied": MessageLookupByLibrary.simpleMessage(
      "Сумма скопирована (сохраните все знаки после запятой)",
    ),
    "vPayAmountMismatchNote": MessageLookupByLibrary.simpleMessage(
      "Отклонение даже на 0.01 в любую сторону не даст сопоставить платёж автоматически. Проверьте, что поле «сумма» в кошельке совпадает с точностью до 2 знаков после запятой.",
    ),
    "vPayAmountMismatchNoteWithBase": m82,
    "vPayAntiCollisionSuffixLabel": MessageLookupByLibrary.simpleMessage(
      "Сверочные центы",
    ),
    "vPayBackToHome": MessageLookupByLibrary.simpleMessage("На главную"),
    "vPayBackToReorder": MessageLookupByLibrary.simpleMessage(
      "Вернуться и заказать заново",
    ),
    "vPayBasePriceLabel": MessageLookupByLibrary.simpleMessage("Обычная цена"),
    "vPayClaimInstruction": MessageLookupByLibrary.simpleMessage(
      "Скопируйте tx hash перевода из кошелька (imToken / TronLink и др.) и вставьте его ниже:",
    ),
    "vPayClaimNote": MessageLookupByLibrary.simpleMessage(
      "После отправки приложение следует структурированному результату блокчейна: ждёт указанное время подтверждения, позволяет отправить следующий TXID после частичной оплаты и обновляет заказ и подписку после завершения.",
    ),
    "vPayContactSupport": MessageLookupByLibrary.simpleMessage(
      "Группа пользователей (публичная)",
    ),
    "vPayContinuePaymentWithHash": MessageLookupByLibrary.simpleMessage(
      "Отправить следующий TXID доплаты",
    ),
    "vPayCopyAddress": MessageLookupByLibrary.simpleMessage(
      "Скопировать адрес",
    ),
    "vPayCopyAmount": MessageLookupByLibrary.simpleMessage("Скопировать сумму"),
    "vPayCountdownExpired": MessageLookupByLibrary.simpleMessage("Истёк"),
    "vPayCouponDiscountLabel": MessageLookupByLibrary.simpleMessage("Промокод"),
    "vPayCreditAppliedLabel": MessageLookupByLibrary.simpleMessage(
      "Зачтено с баланса",
    ),
    "vPayExactAmountWarning": MessageLookupByLibrary.simpleMessage(
      "Переведите точно указанную сумму",
    ),
    "vPayExpiredClaimHint": MessageLookupByLibrary.simpleMessage(
      "Перевели, но оплата не засчиталась? Отправьте хеш транзакции — поступившая сумма будет автоматически зачислена на баланс аккаунта.",
    ),
    "vPayFeeWarningBody": MessageLookupByLibrary.simpleMessage(
      "При выводе с биржи сетевая комиссия (на TRC20 обычно ~1 USDT) удерживается из суммы вывода, поэтому поступит меньше, чем вы указали, и платёж не сопоставится автоматически. Рекомендуем переводить напрямую из собственного кошелька (imToken / TronLink). Если без биржи не обойтись, укажите сумму вывода = сумма к оплате + комиссия, чтобы поступившая сумма точно равнялась сумме к оплате. Если сумма неверна, отправьте TXID: при переплате подписка активируется, а излишек зачисляется на баланс; при недоплате вся поступившая сумма зачисляется на баланс и учитывается при новом заказе.",
    ),
    "vPayFeeWarningTitle": MessageLookupByLibrary.simpleMessage(
      "Платите выводом с биржи? Учтите комиссию",
    ),
    "vPayIHavePaid": MessageLookupByLibrary.simpleMessage("Я оплатил"),
    "vPayIHavePaidSubmitTx": MessageLookupByLibrary.simpleMessage(
      "Я оплатил (отправить хеш транзакции)",
    ),
    "vPayIHavePaidWithHash": MessageLookupByLibrary.simpleMessage(
      "Я оплатил (ввести tx hash для мгновенной проверки)",
    ),
    "vPayOrderExpiredDesc": m83,
    "vPayOrderExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Заказ истёк",
    ),
    "vPayOrderFooterNote": MessageLookupByLibrary.simpleMessage(
      "Неоплаченный заказ автоматически аннулируется через 24 ч. После оплаты в течение 24 ч платёж сопоставляется за 30 с; нажмите «Я оплатил», чтобы запустить проверку сразу.",
    ),
    "vPayOrderNumber": m84,
    "vPayOrderTitle": m85,
    "vPayPaymentConfirmed": MessageLookupByLibrary.simpleMessage(
      "Платёж подтверждён",
    ),
    "vPayPlanMonthly": MessageLookupByLibrary.simpleMessage("Месячный"),
    "vPayPlanQuarterly": MessageLookupByLibrary.simpleMessage("Квартальный"),
    "vPayPlanYearly": MessageLookupByLibrary.simpleMessage("Годовой"),
    "vPayPromotionDiscountLabel": MessageLookupByLibrary.simpleMessage(
      "Промо-скидка",
    ),
    "vPayReorderWithCredit": MessageLookupByLibrary.simpleMessage(
      "Оформить новый заказ (баланс зачтётся автоматически)",
    ),
    "vPayRetryInSeconds": m86,
    "vPayStatusChecking": MessageLookupByLibrary.simpleMessage(
      "Проверка статуса заказа...",
    ),
    "vPayStatusQueryFailed": MessageLookupByLibrary.simpleMessage(
      "Ошибка запроса, повторяем...",
    ),
    "vPayStatusWaiting": MessageLookupByLibrary.simpleMessage(
      "⏳ Ожидание оплаты... (автообновление каждые 5 с)",
    ),
    "vPaySubmitFailed": m87,
    "vPaySubmitVerify": MessageLookupByLibrary.simpleMessage(
      "Отправить на проверку",
    ),
    "vPaySubscriptionActivated": MessageLookupByLibrary.simpleMessage(
      "Подписка активирована",
    ),
    "vPayTelegramNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть Telegram. Группа пользователей: @verstro_chat",
    ),
    "vPayTronAddressTitle": MessageLookupByLibrary.simpleMessage(
      "Адрес Tron USDT",
    ),
    "vPayTxHashHint": MessageLookupByLibrary.simpleMessage(
      "hex из 64 символов, напр. abc1234...",
    ),
    "vPayTxHashLengthError": MessageLookupByLibrary.simpleMessage(
      "Неверная длина tx hash (должно быть 64 символа)",
    ),
    "vPlanAccountEmail": m88,
    "vPlanBadgeBestValue": MessageLookupByLibrary.simpleMessage(
      "Самый выгодный",
    ),
    "vPlanBadgeRecommended": MessageLookupByLibrary.simpleMessage(
      "Рекомендуем",
    ),
    "vPlanCouponLabel": MessageLookupByLibrary.simpleMessage(
      "Промокод (необязательно)",
    ),
    "vPlanCreateOrderFailed": m89,
    "vPlanDurationDays": m90,
    "vPlanFeatureAutoNode": MessageLookupByLibrary.simpleMessage(
      "Автовыбор самого быстрого узла",
    ),
    "vPlanFeaturePremiumNodes": MessageLookupByLibrary.simpleMessage(
      "Ручной выбор страны / узла · включая ускоренные узлы",
    ),
    "vPlanLoadFailed": m91,
    "vPlanLogout": MessageLookupByLibrary.simpleMessage("Выйти"),
    "vPlanMaxDevices": m92,
    "vPlanMultiDevices": MessageLookupByLibrary.simpleMessage(
      "Одновременно на нескольких устройствах",
    ),
    "vPlanNameTrial": MessageLookupByLibrary.simpleMessage("Пробный период"),
    "vPlanPartnerPriceLabel": MessageLookupByLibrary.simpleMessage(
      "Цена партнёра",
    ),
    "vPlanPartnerSalesPaused": MessageLookupByLibrary.simpleMessage(
      "Новые покупки этого плана через данного партнёра временно недоступны. Существующие заказы и преимущества не затронуты.",
    ),
    "vPlanPaymentMethodNote": MessageLookupByLibrary.simpleMessage(
      "Способ оплаты: USDT-TRC20\nПлатёж поступает напрямую на собственный ончейн-адрес Verstro, без сторонних посредников",
    ),
    "vPlanPerMonthHint": m93,
    "vPlanPickThis": MessageLookupByLibrary.simpleMessage("Выбрать этот тариф"),
    "vPlanPickTitle": MessageLookupByLibrary.simpleMessage("Выбор тарифа"),
    "vPlanPriceChanged": MessageLookupByLibrary.simpleMessage(
      "Цена тарифа изменилась. Проверьте новую цену и подтвердите ещё раз.",
    ),
    "vPlanRetry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "vPlanTelegramSupport": MessageLookupByLibrary.simpleMessage(
      "Поддержка в сообществе Telegram",
    ),
    "vPlanTierPremium": MessageLookupByLibrary.simpleMessage(
      "Профессиональные тарифы",
    ),
    "vPlanTierPremiumDesc": MessageLookupByLibrary.simpleMessage(
      "Ручной выбор страны / узла · ускоренные узлы с низкой задержкой · больше устройств",
    ),
    "vPlanTierStandard": MessageLookupByLibrary.simpleMessage(
      "Стандартные тарифы",
    ),
    "vPlanTierStandardDesc": MessageLookupByLibrary.simpleMessage(
      "Автовыбор самого быстрого узла · быстро и достаточно",
    ),
    "vPlanTraffic": m94,
    "vPlanUnavailable": MessageLookupByLibrary.simpleMessage("Недоступно"),
    "vPromotionApply": MessageLookupByLibrary.simpleMessage("Применить код"),
    "vPromotionApplying": MessageLookupByLibrary.simpleMessage(
      "Получение расчёта…",
    ),
    "vPromotionAutomaticBest": MessageLookupByLibrary.simpleMessage(
      "При оформлении сервер автоматически применит лучшее доступное предложение.",
    ),
    "vPromotionAvailable": MessageLookupByLibrary.simpleMessage("Доступно"),
    "vPromotionBadge": MessageLookupByLibrary.simpleMessage("Доступна скидка"),
    "vPromotionCodeHint": MessageLookupByLibrary.simpleMessage(
      "Промокод (необязательно)",
    ),
    "vPromotionDiscountRecord": m95,
    "vPromotionEmpty": MessageLookupByLibrary.simpleMessage(
      "Нет доступных акций или истории использования.",
    ),
    "vPromotionHeld": MessageLookupByLibrary.simpleMessage("Обработка"),
    "vPromotionMyEntrySubtitle": MessageLookupByLibrary.simpleMessage(
      "Доступные, использованные и истёкшие предложения",
    ),
    "vPromotionMyEntryTitle": MessageLookupByLibrary.simpleMessage("Мои акции"),
    "vPromotionNoDiscount": MessageLookupByLibrary.simpleMessage(
      "Для этого тарифа нет дополнительной скидки.",
    ),
    "vPromotionPublicTitle": MessageLookupByLibrary.simpleMessage(
      "Текущие предложения",
    ),
    "vPromotionQuoteAfter": MessageLookupByLibrary.simpleMessage(
      "После скидки",
    ),
    "vPromotionQuoteBase": MessageLookupByLibrary.simpleMessage(
      "Исходная цена",
    ),
    "vPromotionQuoteDiscount": MessageLookupByLibrary.simpleMessage("Скидка"),
    "vPromotionQuoteExpired": MessageLookupByLibrary.simpleMessage(
      "Срок расчёта истёк. Обновляем один раз…",
    ),
    "vPromotionQuoteFailed": m96,
    "vPromotionReleased": MessageLookupByLibrary.simpleMessage("Освобождено"),
    "vPromotionTitle": MessageLookupByLibrary.simpleMessage("Акции"),
    "vPromotionUnavailable": MessageLookupByLibrary.simpleMessage("Недоступно"),
    "vPromotionUnsupported": MessageLookupByLibrary.simpleMessage(
      "Эта версия сервера не поддерживает акции.",
    ),
    "vPromotionUsed": MessageLookupByLibrary.simpleMessage("Использовано"),
    "vShareCodeLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось загрузить код приглашения",
    ),
    "vShareCopyBrief": m97,
    "vShareCopyButton": MessageLookupByLibrary.simpleMessage(
      "Скопировать текст",
    ),
    "vShareCopyDev": m98,
    "vShareCopyGeneral": m99,
    "vShareCopyTitle": MessageLookupByLibrary.simpleMessage(
      "Текст для отправки",
    ),
    "vShareGenerating": MessageLookupByLibrary.simpleMessage("Создание…"),
    "vShareInviteBoth": m100,
    "vShareInvitePlain": m101,
    "vShareInvitePrefix": m102,
    "vShareInvitePrefixBrief": m103,
    "vShareInviteReferee": m104,
    "vSharePageTitle": MessageLookupByLibrary.simpleMessage(
      "Поделиться Verstro",
    ),
    "vSharePosterFeat1Desc": MessageLookupByLibrary.simpleMessage(
      "Больше приложений за пределами системного прокси",
    ),
    "vSharePosterFeat1Label": MessageLookupByLibrary.simpleMessage(
      "Системный TUN",
    ),
    "vSharePosterFeat2Desc": MessageLookupByLibrary.simpleMessage(
      "Автовыбор; зависит от сети",
    ),
    "vSharePosterFeat2Label": MessageLookupByLibrary.simpleMessage(
      "Узлы по всему миру",
    ),
    "vSharePosterFeat3Desc": MessageLookupByLibrary.simpleMessage(
      "Не записывает содержимое и адреса соединений",
    ),
    "vSharePosterFeat3Label": MessageLookupByLibrary.simpleMessage(
      "Приватность",
    ),
    "vSharePosterFeat4Label": MessageLookupByLibrary.simpleMessage(
      "Несколько платформ",
    ),
    "vSharePosterFileName": MessageLookupByLibrary.simpleMessage(
      "Verstro-invite-poster.png",
    ),
    "vSharePosterFooter": MessageLookupByLibrary.simpleMessage(
      "Клиент с открытым кодом (GPLv3) · поведение можно проверить",
    ),
    "vSharePosterGenFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось создать изображение. Повторите попытку.",
    ),
    "vSharePosterGetVerstro": MessageLookupByLibrary.simpleMessage(
      "Скачать Verstro",
    ),
    "vSharePosterHeadline": MessageLookupByLibrary.simpleMessage(
      "Сеть не только для браузера",
    ),
    "vSharePosterNotReady": MessageLookupByLibrary.simpleMessage(
      "Постер ещё не готов. Попробуйте чуть позже.",
    ),
    "vSharePosterRewardBoth": m105,
    "vSharePosterRewardNone": MessageLookupByLibrary.simpleMessage(
      "Укажите этот код при регистрации",
    ),
    "vSharePosterRewardReferee": m106,
    "vSharePosterSaved": MessageLookupByLibrary.simpleMessage(
      "Постер сохранён",
    ),
    "vSharePosterScanHint": MessageLookupByLibrary.simpleMessage(
      "Скачать по QR-коду",
    ),
    "vSharePosterScanSite": MessageLookupByLibrary.simpleMessage(
      "Отсканируйте, чтобы открыть сайт и скачать клиент",
    ),
    "vSharePosterSubline": MessageLookupByLibrary.simpleMessage(
      "Системный TUN · охват зависит от среды",
    ),
    "vSharePosterTagline": MessageLookupByLibrary.simpleMessage(
      "Глобальная сеть с приоритетом приватности",
    ),
    "vSharePosterTrialDays": m107,
    "vSharePosterTrialGeneric": MessageLookupByLibrary.simpleMessage(
      "бесплатный пробный период",
    ),
    "vSharePosterTrialLine": m108,
    "vShareSaveCanceled": MessageLookupByLibrary.simpleMessage(
      "Сохранение отменено",
    ),
    "vShareSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось сохранить. Повторите попытку.",
    ),
    "vShareSaveImage": MessageLookupByLibrary.simpleMessage(
      "Сохранить изображение",
    ),
    "vShareStyleBrief": MessageLookupByLibrary.simpleMessage("Краткий"),
    "vShareStyleDeveloper": MessageLookupByLibrary.simpleMessage(
      "Для разработчиков",
    ),
    "vShareStyleGeneral": MessageLookupByLibrary.simpleMessage("Обычный"),
    "vShareTrialGeneral": MessageLookupByLibrary.simpleMessage(
      "Новые пользователи могут попробовать бесплатно. ",
    ),
    "vShareTrialGeneralDays": m109,
    "vShareTrialShort": MessageLookupByLibrary.simpleMessage(
      "Есть бесплатный пробный период. ",
    ),
    "vSupportCommunityTitle": MessageLookupByLibrary.simpleMessage(
      "Группа пользователей Telegram",
    ),
    "vSupportFeedbackPrivacy": MessageLookupByLibrary.simpleMessage(
      "Конфиденциальные сведения можно отправить приватно на feedback@verstro.com, но никогда не отправляйте пароли, коды подтверждения, приватные ключи или сид-фразы.",
    ),
    "vSupportPublicGroupPrivacy": MessageLookupByLibrary.simpleMessage(
      "Напоминание о конфиденциальности в публичной группе: не отправляйте адрес электронной почты, номер заказа, TXID, снимки кошелька, коды карт, ссылки подписки, пароли, коды подтверждения, приватные ключи или сид-фразы. Можно указать платформу, версию, текст ошибки и время возникновения.",
    ),
    "vTrialActivated": MessageLookupByLibrary.simpleMessage(
      "Пробный период активирован!",
    ),
    "vTrialClaimFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить, попробуйте ещё раз",
    ),
    "vTrialClaimNow": MessageLookupByLibrary.simpleMessage("Получить сейчас"),
    "vTrialSpec": m110,
    "vTrialTitle": MessageLookupByLibrary.simpleMessage(
      "Бесплатный пробный период",
    ),
    "vTrialVerifyEmailHint": m111,
    "vUpdAlreadyLatest": MessageLookupByLibrary.simpleMessage(
      "У вас последняя версия",
    ),
    "vUpdChecksumFailed": MessageLookupByLibrary.simpleMessage(
      "Проверка целостности не пройдена (sha256 не совпадает); загрузка удалена",
    ),
    "vUpdDownloadFailed": m112,
    "vUpdDownloadingProgress": m113,
    "vUpdExitApp": MessageLookupByLibrary.simpleMessage("Выйти"),
    "vUpdForceDesc": MessageLookupByLibrary.simpleMessage(
      "Эта версия больше не поддерживается. Обновите приложение, чтобы продолжить.",
    ),
    "vUpdForceTitle": m114,
    "vUpdIgnoreThisVersion": MessageLookupByLibrary.simpleMessage(
      "Пропустить версию",
    ),
    "vUpdInstallLaunchFailed": m115,
    "vUpdLater": MessageLookupByLibrary.simpleMessage("Позже"),
    "vUpdNewVersionTitle": m116,
    "vUpdNoMatchingPackage": MessageLookupByLibrary.simpleMessage(
      "Не найден установочный пакет для этого устройства",
    ),
    "vUpdUpdateFailed": m117,
    "vUpdUpdateNow": MessageLookupByLibrary.simpleMessage("Обновить сейчас"),
    "value": MessageLookupByLibrary.simpleMessage("Значение"),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Яркие"),
    "view": MessageLookupByLibrary.simpleMessage("Просмотр"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "Обнаружено изменение конфигурации VPN",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с VPN",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически направляет весь системный трафик через VpnService",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Прикрепить HTTP-прокси к VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Изменения вступят в силу после перезапуска VPN",
    ),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "Конфигурация WebDAV",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage(
      "Режим белого списка",
    ),
    "years": MessageLookupByLibrary.simpleMessage("Лет"),
    "yearsAgo": m118,
    "zh_CN": MessageLookupByLibrary.simpleMessage("Упрощенный китайский"),
  };
}
