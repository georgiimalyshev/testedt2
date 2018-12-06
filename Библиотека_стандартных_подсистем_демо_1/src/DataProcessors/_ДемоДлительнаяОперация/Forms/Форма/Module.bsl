#Область ОписаниеПеременных

&НаКлиенте
Перем НомерОперации; // порядковый номер длительной операции.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СкоростьВыполнения = 0;
	ОжидаемыйРезультат = "Успешно";
	ФормаОжидания = "Показывать";
	ПрогрессВыполнения = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	ПередВыполнением();
	
	Если (ПрогрессВыполнения Или ВыводитьСообщения) И (ФормаОжидания <> "Показывать") Тогда
		ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ВыполнитьДействиеПрогрессВыполнения", ЭтотОбъект);
	Иначе
		ОповещениеОПрогрессеВыполнения = Неопределено;
	КонецЕсли;
	
	ДлительнаяОперация = НачатьВыполнениеНаСервере(НомерОперации);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = Уведомление;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = ПрогрессВыполнения;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
	ПараметрыОжидания.ОповещениеПользователя.НавигационнаяСсылка = "e1cib/app/Обработка._ДемоДлительнаяОперация";
	ПараметрыОжидания.ВыводитьОкноОжидания = (ФормаОжидания = "Показывать");
	ПараметрыОжидания.ВыводитьСообщения = ВыводитьСообщения;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ВыполнитьДействиеЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередВыполнением()
	
	ОчиститьСообщения();
	Если НомерОперации = Неопределено Тогда
		НомерОперации = 0;	
	КонецЕсли;
	НомерОперации = НомерОперации + 1;
	
	Если ФормаОжидания = "Показывать" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаУведомление;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
		ТекстУведомления = НСтр("ru = 'Пожалуйста, подождите...'");
		Если Не ПустаяСтрока(Уведомление) Тогда
			ТекстУведомления = Уведомление + Символы.ПС + ТекстУведомления;
		КонецЕсли;
		Элементы.ДлительнаяОперация.РасширеннаяПодсказка.Заголовок = ТекстУведомления;
	КонецЕсли;

КонецПроцедуры 
	
&НаСервере
Функция НачатьВыполнениеНаСервере(НомерОперации)
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 Начало выполнения %2...'"), ТекущаяДатаСеанса(), НомерОперации));
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ОжидаемыйРезультат", ОжидаемыйРезультат);
	ПараметрыПроцедуры.Вставить("ВыполнитьСразу", СкоростьВыполнения = 0);
	ПараметрыПроцедуры.Вставить("НомерОперации", НомерОперации);
	ПараметрыПроцедуры.Вставить("ВыводитьПрогрессВыполнения", ПрогрессВыполнения);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Демо: выполнение длительной операции'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработки._ДемоДлительнаяОперация.ВыполнитьДействие", 
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьДействиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаУведомление;
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	ВывестиРезультат(Результат);
	
	Если Результат.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(,Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьДействиеПрогрессВыполнения(Прогресс, ДополнительныеПараметры) Экспорт
	
	ТекстУведомления = НСтр("ru = 'Пожалуйста, подождите...'");
	Если Не ПустаяСтрока(Уведомление) Тогда
		ТекстУведомления = Уведомление + Символы.ПС + ТекстУведомления;
	КонецЕсли;
	Если Прогресс.Прогресс <> Неопределено Тогда
		ТекстУведомления = ТекстУведомления + ПрогрессСтрокой(Прогресс.Прогресс);
	КонецЕсли;
	Если Прогресс.Сообщения <> Неопределено Тогда
		Для каждого СообщениеПользователю Из Прогресс.Сообщения Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	Элементы.ДлительнаяОперация.РасширеннаяПодсказка.Заголовок = ТекстУведомления;

КонецПроцедуры 

&НаСервере
Процедура ВывестиРезультат(Результат)
	
	Если Результат.Статус = "Выполнено" Тогда
		ТекстСообщения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ТекстСообщения = Результат.ПодробноеПредставлениеОшибки;
	КонецЕсли;
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для каждого СообщениеПользователю Из Результат.Сообщения Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"), ТекущаяДатаСеанса(), ТекстСообщения));
	
КонецПроцедуры

&НаКлиенте
Функция ПрогрессСтрокой(Прогресс)
	
	Результат = "";
	Если Прогресс = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Процент = 0;
	Если Прогресс.Свойство("Процент", Процент) Тогда
		Результат = Строка(Процент) + "%";
	КонецЕсли;
	Текст = 0;
	Если Прогресс.Свойство("Текст", Текст) Тогда
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + " (" + Текст + ")";
		Иначе
			Результат = Текст;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

#КонецОбласти
