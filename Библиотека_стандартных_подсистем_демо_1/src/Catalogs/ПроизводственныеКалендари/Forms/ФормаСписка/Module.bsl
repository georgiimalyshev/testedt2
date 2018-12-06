
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДоступноДобавлениеИзКлассификатора = Истина;
	Если Не ПравоДоступа("Добавление", Метаданные.Справочники.ПроизводственныеКалендари) Тогда
		ДоступноДобавлениеИзКлассификатора = Ложь;
	Иначе
		Если Метаданные.Обработки.Найти("ЗаполнениеКалендарныхГрафиков") = Неопределено Тогда
			ДоступноДобавлениеИзКлассификатора = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ФормаПодборИзКлассификатора.Видимость = ДоступноДобавлениеИзКлассификатора;
	Если Не ДоступноДобавлениеИзКлассификатора Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьКалендарь", "Заголовок", НСтр("ru = 'Создать'"));
		Элементы.Создать.Вид = ВидГруппыФормы.ГруппаКнопок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = РезультатВыбора;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ИмяФормыПодбора = "Обработка.ЗаполнениеКалендарныхГрафиков.Форма.ПодборКалендарейИзКлассификатора";
	ОткрытьФорму(ИмяФормыПодбора, , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
