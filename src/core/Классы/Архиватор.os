#Использовать fs
#Использовать logos

Перем Лог;
Перем Параметры;

Функция Имя() Экспорт
	Возврат "Архиватор ZIP";
КонецФункции

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("arc archivepath", "", Имя() +": архивировать в папку")
				.ТСтрока();

КонецПроцедуры

Процедура ПриЧтенииПараметров(Команда) Экспорт

	Параметры = Новый Структура();
	Параметры.Вставить("Путь", Команда.ЗначениеОпции("archivepath"));

КонецПроцедуры

Процедура ПослеЧтенияПараметров() Экспорт

	Если Включен() Тогда
		ФС.ОбеспечитьКаталог(Параметры.Путь);
		Лог.Информация("Включен обработчик %1. Путь: %2", Имя(), ФС.ПолныйПуть(Параметры.Путь));
	КонецЕсли;

КонецПроцедуры

Функция Включен() Экспорт
	Возврат ЗначениеЗаполнено(Параметры.Путь);
КонецФункции

Процедура ВыполнитьДействие(мФайлыКОбработке) Экспорт

	ИмяАрхива = Формат(ТекущаяДата(), "ДФ=yyyy-MM-dd_HH-mm-ss") +".zip";
	ПутьАрхива = ОбъединитьПути(Параметры.Путь, ИмяАрхива);

	мИменаФайлов = Новый Массив();
	Для каждого СтрокаТаблицыКонтроля Из мФайлыКОбработке Цикл
		Если СтрокаТаблицыКонтроля.Статус = Перечисления.Статусы.Удален Тогда
			Продолжить;
		КонецЕсли;
		мИменаФайлов.Добавить(СтрокаТаблицыКонтроля.ПолноеИмя);
		Лог.Информация("%1: %2 (добавлен в архив %3)", СтрокаТаблицыКонтроля.Статус, СтрокаТаблицыКонтроля.Имя, ИмяАрхива);
	КонецЦикла;

	Зип = Новый ЗаписьZipФайла(ПутьАрхива, , 
			"Автоархивация", ,
			УровеньСжатияZIP.Оптимальный);
	Для каждого ПолноеИмя Из мИменаФайлов Цикл
		Зип.Добавить(ПолноеИмя, РежимСохраненияПутейZIP.НеСохранятьПути);
	КонецЦикла;
	Зип.Записать();
	
КонецПроцедуры

Лог = Логирование.ПолучитьЛог(ПараметрыПриложения.ИмяЛога());
