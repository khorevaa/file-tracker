Перем Параметры;
Перем ТаблицаКонтроля;
Перем Статусы;


Процедура УстановитьПараметры(пПараметры) Экспорт

	Параметры.Вставить("Путь", пПараметры.Путь);
	Параметры.Вставить("Фильтр", пПараметры.Фильтр);
	Параметры.Вставить("Рекурсивно", пПараметры.Рекурсивно);
	Параметры.Вставить("Период", пПараметры.Период);
	Параметры.Вставить("Длительность", пПараметры.Длительность);
	
КонецПроцедуры

Процедура ЗапуститьКонтроль() Экспорт

	НачалоКонтроля = ТекущаяДата();
	Сообщить("Начало контроля: " + НачалоКонтроля);

	Если ЗначениеЗаполнено(Параметры.Длительность) Тогда 
		
		ОкончаниеКонтроля = НачалоКонтроля + Параметры.Длительность;
		Сообщить("Ожидаемое окончание контроля: " + ОкончаниеКонтроля);
		УсловиеЦиклаКонтроля = "ТекущаяДата() < ОкончаниеКонтроля";
	
	Иначе

		Сообщить("Окончание контроля: <не задано>");
		УсловиеЦиклаКонтроля = "Истина";

	КонецЕсли;
	
	Пока Вычислить(УсловиеЦиклаКонтроля) Цикл
		ВыполнитьКонтроль();
		Приостановить(Параметры.Период * 1000);
	КонецЦикла;

	Сообщить("Окончание контроля: " + ТекущаяДата());

КонецПроцедуры

Процедура ВыполнитьКонтроль()

	Для каждого Стр Из ТаблицаКонтроля Цикл
		Стр.Статус = Статусы.Удален;
	КонецЦикла;

	мФайлы = НайтиФайлы(Параметры.Путь, Параметры.Фильтр, Параметры.Рекурсивно);
	Для каждого Файл Из мФайлы Цикл
		ПолноеИмя = Файл.ПолноеИмя;
		
		Стр = ТаблицаКонтроля.Найти(ПолноеИмя, "ПолноеИмя");
		СвойстваФайла = СвойстваФайла(Файл);
		Если Стр = Неопределено Тогда
			Стр = ТаблицаКонтроля.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, СвойстваФайла);
			Стр.Статус = Статусы.Новый;
		ИначеЕсли Стр.Размер <> СвойстваФайла.Размер
			Или Стр.ДатаИзменения <> СвойстваФайла.ДатаИзменения Тогда
			ЗаполнитьЗначенияСвойств(Стр, СвойстваФайла);
			Стр.Статус = Статусы.Изменен;
		Иначе
			Стр.Статус = Статусы.НеИзменился;
		КонецЕсли;

	КонецЦикла;

	мСнятьСКонтроля = Новый Массив;
	мФайлыКОбработке = Новый Массив;
	Для каждого Стр Из ТаблицаКонтроля Цикл
		Если Стр.Статус = Статусы.Удален Тогда
			мСнятьСКонтроля.Добавить(Стр);
		ИначеЕсли Стр.Статус = Статусы.Изменен
			Или Стр.Статус = Статусы.Новый Тогда
			мФайлыКОбработке.Добавить(Стр);
		КонецЕсли;
	КонецЦикла;

	Для каждого Стр Из мСнятьСКонтроля Цикл
		ТаблицаКонтроля.Удалить(Стр);
	КонецЦикла;

	Если ЗначениеЗаполнено(мФайлыКОбработке) Тогда
		МенеджерОбработчиков.ВыполнитьОбработчики(мФайлыКОбработке);
	КонецЕсли;

КонецПроцедуры

Функция СвойстваФайла(Файл)
	сткСвойства = Новый Структура();
	сткСвойства.Вставить("ПолноеИмя", Файл.ПолноеИмя);
	сткСвойства.Вставить("Имя", Файл.Имя);
	Если НЕ Файл.ЭтоКаталог() Тогда
		сткСвойства.Вставить("Размер", Файл.Размер());
		сткСвойства.Вставить("ЭтоКаталог", Ложь);
	Иначе
		сткСвойства.Вставить("Размер", 0);
		сткСвойства.Вставить("ЭтоКаталог", Истина);
	КонецЕсли;
	сткСвойства.Вставить("ДатаИзменения", Файл.ПолучитьВремяИзменения());
	Возврат сткСвойства;
КонецФункции

Процедура Инициализировать()

	ТаблицаКонтроля = Новый ТаблицаЗначений();
	
	ТаблицаКонтроля.Колонки.Добавить("ПолноеИмя");
	ТаблицаКонтроля.Колонки.Добавить("Имя");
	ТаблицаКонтроля.Колонки.Добавить("ЭтоКаталог");
	ТаблицаКонтроля.Колонки.Добавить("Размер");
	ТаблицаКонтроля.Колонки.Добавить("ДатаИзменения");
	ТаблицаКонтроля.Колонки.Добавить("Статус");

	сткСтатусы = Новый Структура();
	сткСтатусы.Вставить("Новый", "Новый");
	сткСтатусы.Вставить("Изменен", "Изменен");
	сткСтатусы.Вставить("Удален", "Удален");
	сткСтатусы.Вставить("НеИзменился", "Не изменился");
	Статусы = Новый ФиксированнаяСтруктура(сткСтатусы);

	Параметры = Новый Структура();

КонецПроцедуры

Инициализировать();
