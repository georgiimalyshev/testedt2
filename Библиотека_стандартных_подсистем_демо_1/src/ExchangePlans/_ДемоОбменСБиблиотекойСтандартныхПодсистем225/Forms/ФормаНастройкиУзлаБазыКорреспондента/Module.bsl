
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Данные = Новый Соответствие;
	Данные.Вставить("Справочник.Организации");
	Данные.Вставить("Справочник._ДемоМестаХранения");
	Данные.Вставить("Справочник._ДемоПодразделения");
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаБазыКорреспондентаПриСозданииНаСервере(
		ЭтотОбъект,
		Метаданные.ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.Имя,
		Данные);
	
	ВспомогательныйРеквизитРежимСинхронизацииОрганизаций =
		?(ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
	
	ВспомогательныйРеквизитРежимСинхронизацииПодразделений =
		?(ИспользоватьОтборПоПодразделениям, "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям", "СинхронизироватьДанныеПоВсемПодразделениям");
	
	ВспомогательныйРеквизитРежимСинхронизацииСкладов =
		?(ИспользоватьОтборПоСкладам, "СинхронизироватьДанныеТолькоПоВыбраннымСкладам", "СинхронизироватьДанныеПоВсемСкладам");
	
	ЗагрузитьДанныеВТаблицуФормы(Данные["Справочник.Организации"], ВспомогательныйРеквизитОрганизации, "Организация");
	ЗагрузитьДанныеВТаблицуФормы(Данные["Справочник._ДемоПодразделения"], ВспомогательныйРеквизитПодразделения, "Подразделение");
	ЗагрузитьДанныеВТаблицуФормы(Данные["Справочник._ДемоМестаХранения"], ВспомогательныйРеквизитСклады, "Склад");
	
	ОтметитьВыбранныеЭлементыТаблицы("Организации", "ВспомогательныйРеквизитОрганизации", "Организация_Ключ");
	ОтметитьВыбранныеЭлементыТаблицы("Подразделения", "ВспомогательныйРеквизитПодразделения", "Подразделение_Ключ");
	ОтметитьВыбранныеЭлементыТаблицы("Склады", "ВспомогательныйРеквизитСклады", "Склад_Ключ");
	
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьВариантСинхронизацииДокументов(ВариантСинхронизацииДокументов, ЭтотОбъект);
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьВариантСинхронизацииСправочников(ВариантСинхронизацииСправочников, ЭтотОбъект);
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	РежимСинхронизацииПодразделенийПриИзмененииЗначения();
	РежимСинхронизацииСкладовПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВспомогательныйРеквизитРежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВспомогательныйРеквизитРежимСинхронизацииСкладовПриИзменении(Элемент)
	
	РежимСинхронизацииСкладовПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВспомогательныйРеквизитРежимСинхронизацииПодразделенийПриИзменении(Элемент)
	
	РежимСинхронизацииПодразделенийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВспомогательныйРеквизитОрганизацииИспользоватьПриИзменении(Элемент)
	
	СформироватьЗаголовокТаблицыОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ВспомогательныйРеквизитСкладыИспользоватьПриИзменении(Элемент)
	
	СформироватьЗаголовокТаблицыСклады();
	
КонецПроцедуры

&НаКлиенте
Процедура ВспомогательныйРеквизитПодразделенияИспользоватьПриИзменении(Элемент)
	
	СформироватьЗаголовокТаблицыПодразделения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовОтправлятьПолучатьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовПолучатьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииДокументовВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииСправочниковАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииСправочниковТолькоИспользуемуюВДокументахПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВариантСинхронизацииСправочниковВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьНаСервере();
	
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "ВспомогательныйРеквизитОрганизации");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеПодразделения(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "ВспомогательныйРеквизитПодразделения");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеСклады(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "ВспомогательныйРеквизитСклады");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "ВспомогательныйРеквизитОрганизации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеПодразделения(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "ВспомогательныйРеквизитПодразделения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеСклады(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "ВспомогательныйРеквизитСклады");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	ИспользоватьОтборПоОрганизациям =
		(ВспомогательныйРеквизитРежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
	ИспользоватьОтборПоПодразделениям =
		(ВспомогательныйРеквизитРежимСинхронизацииПодразделений = "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям");
	
	ИспользоватьОтборПоСкладам =
		(ВспомогательныйРеквизитРежимСинхронизацииСкладов = "СинхронизироватьДанныеТолькоПоВыбраннымСкладам");
	
	Если ИспользоватьОтборПоОрганизациям Тогда
		
		Организации.Загрузить(ВспомогательныйРеквизитОрганизации.Выгрузить(Новый Структура("Использовать", Истина), "Организация, Организация_Ключ"));
		
	Иначе
		
		Организации.Очистить();
		
	КонецЕсли;
	
	Если ИспользоватьОтборПоПодразделениям Тогда
		
		Подразделения.Загрузить(ВспомогательныйРеквизитПодразделения.Выгрузить(Новый Структура("Использовать", Истина), "Подразделение, Подразделение_Ключ"));
		
	Иначе
		
		Подразделения.Очистить();
		
	КонецЕсли;
	
	Если ИспользоватьОтборПоСкладам Тогда
		
		Склады.Загрузить(ВспомогательныйРеквизитСклады.Выгрузить(Новый Структура("Использовать", Истина), "Склад, Склад_Ключ"));
		
	Иначе
		
		Склады.Очистить();
		
	КонецЕсли;
	
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьРежимыВыгрузкиДокументов(ВариантСинхронизацииДокументов, ЭтотОбъект);
	ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225.ОпределитьРежимыВыгрузкиСправочников(ВариантСинхронизацииСправочников, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтотОбъект[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
	СформироватьЗаголовокТаблицыОрганизации();
	СформироватьЗаголовокТаблицыПодразделения();
	СформироватьЗаголовокТаблицыСклады();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзмененииЗначения()
	
	Элементы.ВспомогательныйРеквизитОрганизации.Доступность =
		(ВспомогательныйРеквизитРежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
	СформироватьЗаголовокТаблицыОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииПодразделенийПриИзмененииЗначения()
	
	Элементы.ВспомогательныйРеквизитПодразделения.Доступность =
		(ВспомогательныйРеквизитРежимСинхронизацииПодразделений = "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям");
	
	СформироватьЗаголовокТаблицыПодразделения();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииСкладовПриИзмененииЗначения()
	
	Элементы.ВспомогательныйРеквизитСклады.Доступность =
		(ВспомогательныйРеквизитРежимСинхронизацииСкладов = "СинхронизироватьДанныеТолькоПоВыбраннымСкладам");
	
	СформироватьЗаголовокТаблицыСклады();
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьВыбранныеЭлементыТаблицы(ИмяТаблицы, ИмяВспомогательнойТаблицы, ИмяРеквизита)
	
	Для Каждого СтрокаТаблицы Из ЭтотОбъект[ИмяТаблицы] Цикл
		
		Строки = ЭтотОбъект[ИмяВспомогательнойТаблицы].НайтиСтроки(Новый Структура(ИмяРеквизита, СтрокаТаблицы[ИмяРеквизита]));
		
		Если Строки.Количество() > 0 Тогда
			
			Строки[0].Использовать = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовокТаблицыОрганизации()
	
	Если ВспомогательныйРеквизитРежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям" Тогда
		
		ЗаголовокСтраницы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По организациям (%1)'"), 
			КоличествоВыбранныхСтрок("ВспомогательныйРеквизитОрганизации"));
	Иначе
		
		ЗаголовокСтраницы = НСтр("ru = 'По всем организациям'");
	КонецЕсли;
	
	Элементы.СтраницаОрганизации.Заголовок = ЗаголовокСтраницы;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовокТаблицыПодразделения()
	
	Если ВспомогательныйРеквизитРежимСинхронизацииПодразделений = "СинхронизироватьДанныеТолькоПоВыбраннымПодразделениям" Тогда
		
		ЗаголовокСтраницы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По подразделениям (%1)'"),
			КоличествоВыбранныхСтрок("ВспомогательныйРеквизитПодразделения"));
	Иначе
		
		ЗаголовокСтраницы = НСтр("ru = 'По всем подразделениям'");
	КонецЕсли;
	
	Элементы.СтраницаПодразделения.Заголовок = ЗаголовокСтраницы;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаголовокТаблицыСклады()
	
	Если ВспомогательныйРеквизитРежимСинхронизацииСкладов = "СинхронизироватьДанныеТолькоПоВыбраннымСкладам" Тогда
		
		ЗаголовокСтраницы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По складам (%1)'"),
			КоличествоВыбранныхСтрок("ВспомогательныйРеквизитСклады"));
	Иначе
		
		ЗаголовокСтраницы = НСтр("ru = 'По всем складам'");
	КонецЕсли;
	
	Элементы.СтраницаСклады.Заголовок = ЗаголовокСтраницы;
	
КонецПроцедуры

&НаКлиенте
Функция КоличествоВыбранныхСтрок(ИмяТаблицы)
	
	Результат = 0;
	
	Для Каждого ЭлементКоллекции Из ЭтотОбъект[ИмяТаблицы] Цикл
		
		Если ЭлементКоллекции.Использовать Тогда
			
			Результат = Результат + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ЗагрузитьДанныеВТаблицуФормы(Источник, Приемник, ИмяРеквизита)
	
	Приемник.Очистить();
	
	Для Каждого СтрокаИсточника Из Источник Цикл
		
		СтрокаПриемника = Приемник.Добавить();
		СтрокаПриемника[ИмяРеквизита] = СтрокаИсточника.Представление;
		СтрокаПриемника[ИмяРеквизита + "_Ключ"] = СтрокаИсточника.Идентификатор;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	Элементы.ДатаНачалаВыгрузкиДокументов.Доступность = 
			(ВариантСинхронизацииДокументов = "ОтправлятьИПолучатьАвтоматически" 
			ИЛИ ВариантСинхронизацииДокументов = "ОтправлятьАвтоматически");
	Элементы.ВариантСинхронизацииДокументовПолучатьАвтоматически.Доступность = 
			(ВариантСинхронизацииСправочников <> "ОтправлятьИПолучатьПриНеобходимости");
	Элементы.ВариантСинхронизацииСправочниковТолькоИспользуемуюВДокументах.Доступность = 
			(ВариантСинхронизацииДокументов <> "ПолучатьАвтоматически");
КонецПроцедуры

#КонецОбласти
