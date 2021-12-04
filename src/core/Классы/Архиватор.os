#Использовать fs

Перем Параметры;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("archivepath", "", "архивировать в папку")
				.ТСтрока();

КонецПроцедуры

Процедура ПриЧтенииПараметров(Команда) Экспорт

	Параметры = Новый Структура();
	Параметры.Вставить("Путь", Команда.ЗначениеОпции("archivepath"));

КонецПроцедуры

Процедура ПослеЧтенияПараметров() Экспорт

	Если Включен() Тогда
		ФС.ОбеспечитьКаталог(Параметры.Путь);
	КонецЕсли;

КонецПроцедуры

Функция Включен() Экспорт
	Возврат ЗначениеЗаполнено(Параметры.Путь);
КонецФункции

Процедура ВыполнитьДействие(мФайлыКОбработке) Экспорт

	мИменаФайлов = Новый Массив();
	Для каждого СтрокаТаблицыКонтроля Из мФайлыКОбработке Цикл
		Сообщить(СтрокаТаблицыКонтроля.ИмяФайла + " - " + СтрокаТаблицыКонтроля.Статус);
		мИменаФайлов.Добавить(СтрокаТаблицыКонтроля.ИмяФайла);
	КонецЦикла;

	ИмяАрхива = ОбъединитьПути(Параметры.Путь, Формат(ТекущаяДата(), "ДФ=yyyy-MM-dd_HH-mm-ss"));
	Зип = Новый ЗаписьZipФайла(ИмяАрхива+".zip", , 
			"Автоархивация", ,
			УровеньСжатияZIP.Оптимальный);
	Для каждого ИмяФайла Из мИменаФайлов Цикл
		Зип.Добавить(ИмяФайла, РежимСохраненияПутейZIP.НеСохранятьПути);
	КонецЦикла;
	Зип.Записать();
	
КонецПроцедуры
