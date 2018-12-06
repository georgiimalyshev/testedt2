#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Записывает таблицу настроек в данные регистра по указанным измерениям.
Функция Набор(ТаблицаНастроек, Измерения, Ресурсы, ПоверхСуществующих) Экспорт
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Для Каждого КлючИЗначение Из Измерения Цикл
		НаборЗаписей.Отбор[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение, Истина);
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Для Каждого КлючИЗначение Из Ресурсы Цикл
		ТаблицаНастроек.Колонки.Добавить(КлючИЗначение.Ключ);
		ТаблицаНастроек.ЗаполнитьЗначения(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	Если Не ПоверхСуществующих Тогда
		НаборЗаписей.Прочитать();
		СтарыеЗаписи = НаборЗаписей.Выгрузить();
		ПоискПоИзмерениям = Новый Структура("Отчет, Вариант, ВерсияРасширений, КлючВарианта");
		Для Каждого СтараяЗапись Из СтарыеЗаписи Цикл
			ЗаполнитьЗначенияСвойств(ПоискПоИзмерениям, СтараяЗапись);
			Если ТаблицаНастроек.НайтиСтроки(ПоискПоИзмерениям).Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(ТаблицаНастроек.Добавить(), СтараяЗапись);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	НаборЗаписей.Загрузить(ТаблицаНастроек);
	Возврат НаборЗаписей;
	
КонецФункции

#КонецОбласти

#КонецЕсли