﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостей.
//
////////////////////////////////////////////////////////////////////////////////

// Процедура устанавливает одинаковые состояния для новостей в текущей области данных.
// Это полезно, например, при первом старте программы (при создании из cf),
//  когда необходимо отключить оповещения и поставить признак прочтенности у всех новостей для предыдущих версий программы.
// Так как справочник Пользователи разделенный, то в модели сервиса процедуру можно запускать только в разделенном сеансе.
//
// Параметры:
//  МассивПользователей - Массив - Массив пользователей, для которых необходимо установить состояния новостей;
//  СтруктураОтборов    - Структура - структура со значениями отборов. Возможные ключи:
//    * СписокНовостей - СписокЗначений - список новостей. Если параметр установлен, то остальные параметры отбора игнорируются;
//    * СписокЛентНовостей - СписокЗначений - список лент новостей. Если не указан, то по всем.;
//    * ИнтервалВерсийПродукта - Структура - отбор по версиям продукта. Содержит ключи:
//       * Продукт  - Строка - наименование продукта;
//       * ВерсияОТ - Строка - начальная версия в формате 99.99.999.9999;
//       * ВерсияДО - Строка - конечная версия в формате 99.99.999.9999;
//    * ИнтервалВерсийПлатформы - Структура - отбор по версиям платформы. Содержит ключи:
//       * ВерсияОТ - Строка - начальная версия в формате 99.99.999.9999;
//       * ВерсияДО - Строка - конечная версия в формате 99.99.999.9999;
//  ЗначенияСостояний   - Структура - структура значений для заполнения реквизитов регистра сведений СостоянияНовостей. Возможны ключи:
//    * Прочтена                - Булево - Признак прочтенности. Если не указано, то не будет изменено;
//    * Пометка                 - Число  - Признак пометки флажком. Если не указано, то не будет изменено;
//    * ОповещениеВключено      - Булево - Признак снятия оповещения. Если не указано, то не будет изменено;
//    * ДатаНачалаОповещения    - Дата   - Дата начала оповещения. Если не указано, то не будет изменено;
//    * УдаленаИзСпискаНовостей - Булево - Признак помещения в корзину. Если не указано, то не будет изменено.
//
#Если ВебКлиент Тогда

Процедура ИмяПроцедуры1(
	Перем1 = Неопределено,
	Перем2 = Неопределено,
	Перем3 = Неопределено) Экспорт

#Область ОписаниеПеременных

	Перем А1;
	Перем А2, А3;
	Перем А4 Экспорт;
	Перем А5, А6 Экспорт;

#КонецОбласти

#Область ПростыеПримеры

	// Привет
	Если (А=Истина) Тогда
	КонецЕсли;

#Область ПростыеПримеры_УИН

	// Все УИНы
	// //! СДЕЛАТЬ Что-то сделать 1...
	УИН1 = "EA19DFE3-AE91-4703-B553-5F916773A7B8";
	УИН2 = "1EE4044F-A3FA-4093-A124-9688D9ED429E";
	УИН3 = "F47C83EE-762B-4673-BCAC-49E3E7B4FFF8";

#КонецОбласти

#Область ПростыеПримеры_Строки

	// Все строки
	// //! СДЕЛАТЬ Что-то сделать 2...
	Код1 = "1234"; // Это НЕ число, а строка.
	Код2 = "123456"; // Это НЕ число, а строка.
	Код3 = "345678"; // Это НЕ число, а строка.
	Код4 = "567890"; // Это НЕ число, а строка.
	Код5 = "01234567"; // Это НЕ число, а строка.
	А = "Строка";
	Б = "Многострочная строка, Строка 1
		|Строка 2
		|Строка 3
		|Строка 4
		|Символ
		|Символы";
	В = "Многострочная строка, Строка 1" + Символы.ПС + "Строка 2" + Символы.ПС + "Строка 3" + Символы.ПС + "Строка 4";

	// Результат Б и В - одно и то же.

#КонецОбласти

#Область ПростыеПримеры_Даты

	// Все даты
	// //! СДЕЛАТЬ Что-то сделать 3...
	Дата1 = 'выдаотдловат'; // Ошибочная дата.
	Дата2 = '2017'; // Ошибочная дата.
	Дата3 = '170309'; // Ошибочная дата.
	Дата4 = '20170309'; // Дата + 00:00:00.
	Дата5 = '201703090102'; // Ошибочная дата.
	Дата6 = '20170309010203'; // Дата.

#КонецОбласти

#Область ПростыеПримеры_Числа

	// Все числа
	// //! СДЕЛАТЬ Что-то сделать 4...
	Число01 = NULL; // Число.
	Число02 = Истина; // Число.
	Число03 = Ложь; // Число.
	Число04 = True; // Число.
	Число05 = False; // Число.
	Число06 = 1; // Число.
	Число07 = 12; // Число.
	Число08 = 123; // Число.
	Число09 = 1234.; // Число.
	Число10 = 1234.5; // Число.
	Число11 = 1234.56; // Число.
	Число12 = 12345.67 + 89012.34; // Число.
	Число13 = Цел(Число12); // Число.
	Число14 = Окр(Число12); // Число.

#КонецОбласти

#Область ПростыеПримеры_Комментарии

	// БлокДляУдаления

	// Процедуры и функции
	// //! СДЕЛАТЬ Что-то сделать 5...
	Значение1 = ПустаяСтрока("123");
	Значение2 = Pow(123.2);
	Значение3 = СтрНайти("Строка 123 поиска", "123");

	// Конец БлокДляУдаления

	// ПодробностиБИП
	// Это какая-то информация, которая будет вырезана в продакшене.
	// Конец ПодробностиБИП

#КонецОбласти

#КонецОбласти

	Если (А=Истина) Тогда
	Иначе
	КонецЕсли;

#Область Имя1

#Область Имя1_1

	Если (А=Истина) Тогда
		// Бла1
	ИначеЕсли (Б=Истина) Тогда
		// Бла2
	Иначе
		// Бла3
	КонецЕсли;

#КонецОбласти

#Область Имя1_2

	Попытка
		А = А / 0;
	Исключение
		А = 2;
	КонецПопытки

#КонецОбласти

#Область Имя1_3

	// Константы
	А1 = Константа.А1;
	А2 = Константа.А2;
	А3 = Константы.А3;
	А4 = Константы.А4;

#КонецОбласти

#КонецОбласти

КонецПроцедуры

#КонецЕсли

#Область Экспортные

Процедура ИмяПроцедуры2(
	Перем1 = Неопределено,
	Перем2 = Неопределено,
	Перем3 = Неопределено) Экспорт

	// Привет
	Если А=Истина Тогда
	КонецЕсли;

	Если (А=Истина) Тогда
	Иначе
	КонецЕсли;

#Область Имя1

#Область Имя1_1

	Если (А=Истина) Тогда
		// Бла1
	ИначеЕсли (Б=Истина) Тогда
		// Бла2
	Иначе
		// Бла3
	КонецЕсли;

#КонецОбласти

#Область Имя1_2

#Область Имя1_2_1
#КонецОбласти

#Область Имя1_2_2
#КонецОбласти

#Область Имя1_2_3
#КонецОбласти

#КонецОбласти

#Область Имя1_3
#КонецОбласти

#КонецОбласти

КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область НеформатированныеПроцедуры

Процедура ИмяПроцедуры3()
Если (А=1) Тогда
Для С=1 по 10 Цикл Б=А КонецЦикла; А=1;
КонецЕсли;
Возврат;
КонецПроцедуры

Процедура ИмяПроцедуры4() Экспорт
Если (А=1) Тогда Б=2 КонецЕсли;
КонецПроцедуры

Функция ИмяФункции1()
Для С=1 по 10 Цикл Б=А КонецЦикла; А=1;
Возврат 1;
КонецФункции

Функция ИмяФункции2() Экспорт
Если (а=1) Тогда Б=2 КонецЕсли;
Возврат 2;
КонецФункции

#КонецОбласти
