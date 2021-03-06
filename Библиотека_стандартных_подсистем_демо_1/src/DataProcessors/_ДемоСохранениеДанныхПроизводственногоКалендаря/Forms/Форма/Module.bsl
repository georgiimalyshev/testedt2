#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьКалендариНаСервере();
	
	МакетПроизводственныеКалендари = Неопределено;
	МакетДанныеПроизводственныхКалендарей = Неопределено;
	
	ВерсияКалендарей = КалендарныеГрафики.ВерсияКалендарей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПроизводственныеКалендари

&НаКлиенте
Процедура ПроизводственныеКалендариПриИзменении(Элемент)
	
	МакетПроизводственныеКалендари = Неопределено;
	МакетДанныеПроизводственныхКалендарей = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьКалендари(Команда)
	
	ЗаполнитьКалендариНаСервере();
	МакетПроизводственныеКалендари = Неопределено;
	МакетДанныеПроизводственныхКалендарей = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьМакеты(Команда)
	
	СформироватьМакетыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПоставляемыеДанные(Команда)
	
	АдресФайлаПоставляемыхДанных = АдресФайлаПоставляемыхДанныхНаСервере();
	ПолучитьФайл(АдресФайлаПоставляемыхДанных, ИмяНовогоФайла(ВерсияКалендарей));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьМакетыНаСервере()
	
	Сравнение = Новый СравнениеЗначений;
	
	МакетПроизводственныеКалендари = Неопределено;
	СформироватьМакетПроизводственныеКалендари();
	
	Элементы.ПроизводственныеКалендариСтраница.Картинка = Новый Картинка;
	Если Сравнение.Сравнить(МакетПроизводственныеКалендари, ТекстМакетаПроизводственныеКалендари()) <> 0 Тогда
		Элементы.ПроизводственныеКалендариСтраница.Картинка = БиблиотекаКартинок.Предупреждение;
	КонецЕсли;
	
	МакетДанныеПроизводственныхКалендарей = Неопределено;
	СформироватьМакетДанныеПроизводственныхКалендарей();
	
	Элементы.ДанныеПроизводственныхКалендарейСтраница.Картинка = Новый Картинка;
	Если Сравнение.Сравнить(МакетДанныеПроизводственныхКалендарей, ТекстМакетаДанныеПроизводственныхКалендарей()) <> 0 Тогда
		Элементы.ДанныеПроизводственныхКалендарейСтраница.Картинка = БиблиотекаКартинок.Предупреждение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьМакетДанныеПроизводственныхКалендарей()
		
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Calendar");
	Таблица.Колонки.Добавить("Year");
	Таблица.Колонки.Добавить("DayType");
	Таблица.Колонки.Добавить("Date");
	Таблица.Колонки.Добавить("SwapDate");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Календари", ОбщегоНазначения.ВыгрузитьКолонку(ПроизводственныеКалендари, "ПроизводственныйКалендарь", Истина));
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеКалендарей.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
		|	ДанныеКалендарей.ПроизводственныйКалендарь.Код КАК КодПроизводственногоКалендаря,
		|	ДанныеКалендарей.Год КАК Год,
		|	ДанныеКалендарей.Дата КАК Дата,
		|	ДанныеКалендарей.ВидДня КАК ВидДня,
		|	ДанныеКалендарей.ДатаПереноса КАК ДатаПереноса
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеКалендарей
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК БазовыеДанные
		|		ПО (БазовыеДанные.ПроизводственныйКалендарь = ДанныеКалендарей.ПроизводственныйКалендарь.БазовыйКалендарь)
		|			И (БазовыеДанные.Год = ДанныеКалендарей.Год)
		|			И (БазовыеДанные.Дата = ДанныеКалендарей.Дата)
		|			И (БазовыеДанные.ВидДня = ДанныеКалендарей.ВидДня)
		|			И (БазовыеДанные.ДатаПереноса = ДанныеКалендарей.ДатаПереноса)
		|ГДЕ
		|	ДанныеКалендарей.ПроизводственныйКалендарь В(&Календари)
		|	И БазовыеДанные.Дата ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	КодПроизводственногоКалендаря,
		|	ПроизводственныйКалендарь,
		|	Год,
		|	Дата";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("ПроизводственныйКалендарь") Цикл
		Пока Выборка.СледующийПоЗначениюПоля("Год") Цикл
			Пока Выборка.Следующий() Цикл
				Если Выборка["ВидДня"] = ВидДняПоДате(Выборка["Дата"]) И Не ЗначениеЗаполнено(Выборка["ДатаПереноса"]) Тогда
					Продолжить;
				КонецЕсли;
				НоваяСтрока = Таблица.Добавить();
				НоваяСтрока["Calendar"] = Выборка.КодПроизводственногоКалендаря;
				НоваяСтрока["Year"] = Формат(Выборка["Год"], "ЧГ=");
				НоваяСтрока["DayType"] = Строка(Выборка["ВидДня"]);
				НоваяСтрока["Date"] = Формат(Выборка["Дата"], "ДФ=yyyyMMdd");
				НоваяСтрока["SwapDate"] = Формат(Выборка["ДатаПереноса"], "ДФ=yyyyMMdd");
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	
	ЗаписатьТаблицуВXML(ЗаписьXML, Таблица, НСтр("ru = 'Данные производственного календаря'"));
	
	МакетДанныеПроизводственныхКалендарей = ЗаписьXML.Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьМакетПроизводственныеКалендари()
		
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Code");
	Таблица.Колонки.Добавить("Description");
	Таблица.Колонки.Добавить("Base");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Календари", ОбщегоНазначения.ВыгрузитьКолонку(ПроизводственныеКалендари, "ПроизводственныйКалендарь", Истина));
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Календари.Код КАК Код,
		|	Календари.Наименование КАК Наименование,
		|	БазовыеКалендари.Код КАК КодБазового,
		|	Календари.БазовыйКалендарь КАК БазовыйКалендарь
		|ИЗ
		|	Справочник.ПроизводственныеКалендари КАК Календари
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПроизводственныеКалендари КАК БазовыеКалендари
		|		ПО (БазовыеКалендари.Ссылка = Календари.БазовыйКалендарь)
		|ГДЕ
		|	Календари.Ссылка В(&Календари)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Календари.БазовыйКалендарь,
		|	Код";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока["Code"] = Выборка.Код;
		НоваяСтрока["Description"] = Выборка.Наименование;
		НоваяСтрока["Base"] = Выборка.КодБазового;
	КонецЦикла;
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	
	ЗаписатьТаблицуВXML(ЗаписьXML, Таблица, НСтр("ru = 'Производственные календари'"));
	
	МакетПроизводственныеКалендари = ЗаписьXML.Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьТаблицуВXML(ЗаписьXML, Таблица, ИмяТаблицы)
	
	ИменаКолонок = ОбщегоНазначения.ВыгрузитьКолонку(Таблица.Колонки, "Имя");
	ИменаКолонокСтр = СтрСоединить(ИменаКолонок, ",");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Items");
	ЗаписьXML.ЗаписатьАтрибут("Description", ИмяТаблицы);
	ЗаписьXML.ЗаписатьАтрибут("Columns",     ИменаКолонокСтр);
	
	Для Каждого СтрокаДанных Из Таблица Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("Item");
		Для Каждого ИмяКолонки Из ИменаКолонок Цикл
			ЗаписьXML.ЗаписатьАтрибут(ИмяКолонки, Строка(СтрокаДанных[ИмяКолонки]));
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

&НаСервере
Функция ВидДняПоДате(Дата)
	
	НомерДняНедели = ДеньНедели(Дата);
	
	Если НомерДняНедели <= 5 Тогда
		Возврат Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий;
	КонецЕсли;
	
	Если НомерДняНедели = 6 Тогда
		Возврат Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота;
	КонецЕсли;
	
	Если НомерДняНедели = 7 Тогда
		Возврат Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКалендариНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроизводственныеКалендари.Ссылка КАК ПроизводственныйКалендарь,
		|	ПроизводственныеКалендари.Код КАК Код,
		|	ПроизводственныеКалендари.БазовыйКалендарь КАК БазовыйКалендарь
		|ИЗ
		|	Справочник.ПроизводственныеКалендари КАК ПроизводственныеКалендари
		|ГДЕ
		|	ПроизводственныеКалендари.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	БазовыйКалендарь,
		|	Код";
	ПроизводственныеКалендари.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресФайлаПоставляемыхДанныхНаСервере()
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьНачалоЭлемента("CalendarSuppliedData");
	
	ЗаписьXML.ЗаписатьАтрибут("Version", Строка(КалендарныеГрафики.ВерсияКалендарей()));
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Calendars");
	ТекстМакета = ТекстМакетаПроизводственныеКалендари();
	ДанныеМакета = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстМакета);
	ЗаписатьТаблицуВXML(ЗаписьXML, ДанныеМакета.Данные, ДанныеМакета.ИмяТаблицы);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CalendarData");
	ТекстМакета = ТекстМакетаДанныеПроизводственныхКалендарей();
	ДанныеМакета = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстМакета);
	ЗаписатьТаблицуВXML(ЗаписьXML, ДанныеМакета.Данные, ДанныеМакета.ИмяТаблицы);
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Возврат ПоместитьВоВременноеХранилище(ЗаписьXML.Закрыть());
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекстМакетаПроизводственныеКалендари()
	Возврат Обработки.ЗаполнениеКалендарныхГрафиков.ПолучитьМакет("ПроизводственныеКалендари").ПолучитьТекст();
КонецФункции

&НаСервереБезКонтекста
Функция ТекстМакетаДанныеПроизводственныхКалендарей()
	Возврат Обработки.ЗаполнениеКалендарныхГрафиков.ПолучитьМакет("ДанныеПроизводственныхКалендарей").ПолучитьТекст();
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяНовогоФайла(ВерсияКалендарей)
	Возврат "CalendarSuppliedData_v" + Формат(ВерсияКалендарей, "ЧГ=") + ".xml";
КонецФункции

#КонецОбласти
