#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьЗамеры(Замеры) Экспорт
	Если ТипЗнч(Замеры) = Тип("РезультатЗапроса") Тогда
		ЗаписатьРезультатЗапроса(Замеры);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаписатьРезультатЗапроса(Замеры)
	Если НЕ Замеры.Пустой() Тогда
		НаборЗаписей = СоздатьНаборЗаписей();
		
		Выборка = Замеры.Выбрать();
		Пока Выборка.Следующий() Цикл
			НовЗапись = НаборЗаписей.Добавить();
			НовЗапись.Период = Выборка.Период;
			НовЗапись.ОперацияСтатистики = Выборка.ОперацияСтатистики;
			НовЗапись.ИдентификаторУдаления = Выборка.ИдентификаторУдаления;
			НовЗапись.КоличествоЗначений = Выборка.КоличествоЗначений;
			НовЗапись.СуммаЗначений = Выборка.СуммаЗначений;
			НовЗапись.ПериодОкончание = Выборка.ПериодОкончание;
		КонецЦикла;
		
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать(Ложь);
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьАгрегированныеЗаписи(ГраницаАгрегирования, ОбработатьЗаписиДо, ПериодАгрегации, ПериодУдаления) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200) КАК Период,
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200 + &ПериодАгрегации - 1) КАК ПериодОкончание,
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодУдаления - 0.5 КАК ЧИСЛО(11,0)) * &ПериодУдаления - 63555667200) КАК ИдентификаторУдаления,
	|	ЗамерыОперацииСтатистики.ОперацияСтатистики,
	|	СУММА(ЗамерыОперацииСтатистики.КоличествоЗначений) КАК КоличествоЗначений,
	|	СУММА(ЗамерыОперацииСтатистики.СуммаЗначений) КАК СуммаЗначений
	|ИЗ
	|	РегистрСведений.ЗамерыОперацииСтатистики КАК ЗамерыОперацииСтатистики
	|ГДЕ
	|	ЗамерыОперацииСтатистики.Период >= &ГраницаАгрегирования
	|	И ЗамерыОперацииСтатистики.Период < &ОбработатьЗаписиДо
	|СГРУППИРОВАТЬ ПО
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200),
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200 + &ПериодАгрегации - 1),
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодУдаления - 0.5 КАК ЧИСЛО(11,0)) * &ПериодУдаления - 63555667200),
	|	ЗамерыОперацииСтатистики.ОперацияСтатистики
	|";
	
	Запрос.УстановитьПараметр("ГраницаАгрегирования", ГраницаАгрегирования);
	Запрос.УстановитьПараметр("ОбработатьЗаписиДо", ОбработатьЗаписиДо);
	Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации);
	Запрос.УстановитьПараметр("ПериодУдаления", ПериодУдаления);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
КонецФункции

Процедура УдалитьЗаписи(ГраницаАгрегирования, ОбработатьЗаписиДо) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗамерыОперацииСтатистики.ИдентификаторУдаления	
	|ИЗ
	|	РегистрСведений.ЗамерыОперацииСтатистики КАК ЗамерыОперацииСтатистики
	|ГДЕ
	|	ЗамерыОперацииСтатистики.Период >= &ГраницаАгрегирования
	|	И ЗамерыОперацииСтатистики.Период < &ОбработатьЗаписиДо
	|";
	
	Запрос.УстановитьПараметр("ГраницаАгрегирования", ГраницаАгрегирования);
	Запрос.УстановитьПараметр("ОбработатьЗаписиДо", ОбработатьЗаписиДо);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей.Отбор.ИдентификаторУдаления.Установить(Выборка.ИдентификаторУдаления);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьЗамеры(ДатаНачала, ДатаОкончания, ПериодУдаления) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОперацииСтатистики.Наименование КАК ОперацияСтатистики,
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодУдаления - 0.5 КАК ЧИСЛО(11,0)) * &ПериодУдаления - 63555667200) КАК Период,
	|	СУММА(ЗамерыОперацииСтатистики.КоличествоЗначений) КАК КоличествоЗначений,
	|	СУММА(ЗамерыОперацииСтатистики.СуммаЗначений) КАК СуммаЗначений
	|ИЗ
	|	РегистрСведений.ЗамерыОперацииСтатистики КАК ЗамерыОперацииСтатистики
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОперацииСтатистики КАК ОперацииСтатистики
	|ПО
	|	ЗамерыОперацииСтатистики.ОперацияСтатистики = ОперацииСтатистики.ИдентификаторОперации
	|ГДЕ
	|	ЗамерыОперацииСтатистики.Период >= &ДатаНачала
	|	И ЗамерыОперацииСтатистики.ПериодОкончание <= &ДатаОкончания
	|	И ЗамерыОперацииСтатистики.ИдентификаторУдаления < ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), &ДатаОкончания, СЕКУНДА) + 63555667200)/&ПериодУдаления - 0.5 КАК ЧИСЛО(11,0)) * &ПериодУдаления - 63555667200)
	|СГРУППИРОВАТЬ ПО
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодУдаления - 0.5 КАК ЧИСЛО(11,0)) * &ПериодУдаления - 63555667200),
	|	ОперацииСтатистики.Наименование
	|УПОРЯДОЧИТЬ ПО
	|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), ЗамерыОперацииСтатистики.Период, СЕКУНДА) + 63555667200)/&ПериодУдаления - 0.5 КАК ЧИСЛО(11,0)) * &ПериодУдаления - 63555667200),
	|	ОперацииСтатистики.Наименование
	|";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ПериодУдаления", ПериодУдаления);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;	
КонецФункции

#КонецОбласти

#КонецЕсли
