#Использовать logos

Перем Лог;
Перем мОбработчики;

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Для каждого Обработчик Из мОбработчики Цикл
		Обработчик.ОписаниеКоманды(Команда);
	КонецЦикла;

КонецПроцедуры

Процедура ПриЧтенииПараметров(Команда) Экспорт
	
	Для каждого Обработчик Из мОбработчики Цикл
		Обработчик.ПриЧтенииПараметров(Команда);
	КонецЦикла;
	
	ПослеЧтенияПараметров();

КонецПроцедуры

Процедура ПослеЧтенияПараметров()
	Для каждого Обработчик Из мОбработчики Цикл
		Обработчик.ПослеЧтенияПараметров();
	КонецЦикла;
КонецПроцедуры

Процедура ВыполнитьОбработчики(МассивФайлов) Экспорт
	Для каждого Обработчик Из мОбработчики Цикл
		Если Обработчик.Включен() Тогда
			Попытка
				Обработчик.ВыполнитьДействие(МассивФайлов);
			Исключение
				Лог.Ошибка("Выполнение обработчика %1 вызвало исключение. Обработчик пропущен.
						|  - %2", Обработчик.Имя(), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПодключитьОбработчик(Объект)
	мОбработчики.Добавить(Объект);
КонецПроцедуры

Лог = Логирование.ПолучитьЛог(ПараметрыПриложения.ИмяЛога());

мОбработчики = Новый Массив;
ПодключитьОбработчик(Новый Архиватор());
ПодключитьОбработчик(Новый Версионирование());
ПодключитьОбработчик(Новый Внешний());
