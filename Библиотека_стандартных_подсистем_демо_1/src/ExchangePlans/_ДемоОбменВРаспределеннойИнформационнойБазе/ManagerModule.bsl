#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	
	// Для целей автоматического тестирования обновления в рамках РИБ в разных режимах
	// определяем назначение плана обмена по наличию фильтров по организациям.
	ПараметрЗапускаПриложения = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
	Если СтрНайти(ПараметрЗапускаПриложения, "РежимОтладки") > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОрганизацииИзУзла.Организация КАК Организация
		|ИЗ
		|	ПланОбмена._ДемоОбменВРаспределеннойИнформационнойБазе.Организации КАК ОрганизацииИзУзла
		|ГДЕ
		|	НЕ ОрганизацииИзУзла.Ссылка.ЭтотУзел
		|	И НЕ ОрганизацииИзУзла.Ссылка.ПометкаУдаления";
		Если Запрос.Выполнить().Пустой() Тогда
			Настройки.НазначениеПланаОбмена = "РИББезФильтра";
		КонецЕсли;
	КонецЕсли;
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных     = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, 
	|состоящую из отдельных информационных баз системы «1С:Предприятие» - узлов распределенной информационной базы, между 
	|которыми организована синхронизация конфигурации и данных. Главной особенностью распределенных информационных баз 
	|является передача изменений конфигурации в подчиненные узлы. 
	|Имеется возможность настраивать ограничения миграции данных, например по организациям.'");
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	
	ПодробнаяИнформацияПоОбмену = "https://its.1c.ru/db/bsp243doc#content:9807:1:issogl1_синхронизация_данных_в_распределенной_информационной_базе";
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену;
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки синхронизации распределенной информационной базы'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Распределенная информационная база'");
	
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = "ДатаНачалаВыгрузкиДокументов, ИспользоватьОтборПоОрганизациям, Организации";
	
	// Отборы
	ОписаниеВарианта.Отборы = НастройкаОтборовНаУзле();	
	
КонецПроцедуры

// Возвращает строку описания ограничений миграции данных для пользователя.
// Прикладной разработчик на основе установленных отборов на узле должен сформировать 
// строку описания ограничений удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена.
//  ВерсияКорреспондента   - Строка    - версия корреспондента.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//
// Возвращаемое значение:
//  Строка - описание ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	ОграничениеДатаНачалаВыгрузкиДокументов = "";
	ОграничениеОтборПоОрганизациям = "";
	ОграничениеОтборПоСкладам = "";
	ОграничениеОтборПоПодразделениям = "";
	
	// Дата начала выгрузки документов.
	Если ЗначениеЗаполнено(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов) Тогда
		ОграничениеДатаНачалаВыгрузкиДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Начиная с %1'"),
			Формат(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));
	Иначе
		ОграничениеДатаНачалаВыгрузкиДокументов = НСтр("ru = 'За весь период ведения учета в программе'");
	КонецЕсли;
	
	// Отбор по организациям.
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям Тогда
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Организации.Организация, "; ");
		ОграничениеОтборПоОрганизациям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Только по организациям: %1'"), СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'По всем организациям'");
	КонецЕсли;
	
	// Отбор по подразделениям.
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоПодразделениям Тогда
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Подразделения.Подразделение, "; ");
		ОграничениеОтборПоПодразделениям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Только по подразделениям: %1'"), СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоПодразделениям = НСтр("ru = 'По всем подразделениям'");
	КонецЕсли;
	
	// Отбор по складам.
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоСкладам Тогда
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Склады.СкладОтправитель, "; ");
		ОграничениеОтборПоСкладам = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Только по складам (отправитель): %1'"),
			СтрокаПредставленияОтбора);
		
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Склады.СкладПолучатель, "; ");
		ОграничениеОтборПоСкладам = ОграничениеОтборПоСкладам
			+ Символы.ПС
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Только по складам (получатель): %1'"),
				СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоСкладам = НСтр("ru = 'По всем складам'");
	КонецЕсли;
	
	Возврат (
		НСтр("ru = 'Выгружать документы и справочную информацию:'")
		+ Символы.ПС
		+ ОграничениеДатаНачалаВыгрузкиДокументов
		+ Символы.ПС
		+ ОграничениеОтборПоОрганизациям
		+ Символы.ПС
		+ ОграничениеОтборПоПодразделениям
		+ Символы.ПС
		+ ОграничениеОтборПоСкладам);
КонецФункции

// Конец СтандартныеПодсистемы.ОбменДанными

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкаОтборовНаУзле()
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураТабличнойЧастиПодразделения = Новый Структура;
	СтруктураТабличнойЧастиПодразделения.Вставить("Подразделение", Новый Массив);
	
	СтруктураТабличнойЧастиСклады = Новый Структура;
	СтруктураТабличнойЧастиСклады.Вставить("СкладОтправитель", Новый Массив);
	СтруктураТабличнойЧастиСклады.Вставить("СкладПолучатель",  Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",      НачалоГода(ТекущаяДатаСеанса()));
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",   Ложь);
	СтруктураНастроек.Вставить("ИспользоватьОтборПоПодразделениям", Ложь);
	СтруктураНастроек.Вставить("ИспользоватьОтборПоСкладам",        Ложь);
	ГлавныйУзел = ПланыОбмена.ГлавныйУзел();
	// Это подчиненный узел РИБ с отбором.
	Если ГлавныйУзел <> Неопределено И ТипЗнч(ГлавныйУзел) = Тип("ПланОбменаСсылка._ДемоОбменВРаспределеннойИнформационнойБазе") Тогда
		НастройкиЦентральногоУзлаРИБ = ЭтотУзел();
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, НастройкиЦентральногоУзлаРИБ);
		СтруктураТабличнойЧастиОрганизации = Новый Структура;
		СтруктураТабличнойЧастиОрганизации.Вставить("Организация", НастройкиЦентральногоУзлаРИБ.Организации.ВыгрузитьКолонку("Организация"));
	КонецЕсли;
	СтруктураНастроек.Вставить("Организации",   СтруктураТабличнойЧастиОрганизации);
	СтруктураНастроек.Вставить("Склады",        СтруктураТабличнойЧастиСклады);
	СтруктураНастроек.Вставить("Подразделения", СтруктураТабличнойЧастиПодразделения);
	
	Возврат СтруктураНастроек;
	
КонецФункции

#КонецОбласти

#КонецЕсли
