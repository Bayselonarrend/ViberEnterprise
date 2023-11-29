//MIT License

//Copyright (c) 2023 Anton Tsitavets

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#Область НастройкиИИнформация

//ВАЖНО: Установка Webhook обязательна по правилам Viber. Для этого надо иметь свободный URL, 
//который будет возвращать 200 и подлинный SSL сертификат. Если есть сертификат и база опубликована
//на сервере - можно использовать http-сервис. Туда же будет приходить и информация о новых сообщениях
//Viber периодически стучит по адресу Webhook, так что если он будет неактивен, то все перестанет работать
Функция УстановитьWebhook(Знач Токен, Знач URL) Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("url", URL);
	СтруктураПараметров.Вставить("auth_token", Токен);
	
	Инструменты.PostUrlencoded("https://chatapi.viber.com/pa/set_webhook"
		, СтруктураПараметров);
	
КонецФункции

//Тут можно получить ID пользователей канала. ID для бота необходимо получать из прилетов на Webhook 
//ID пользователя из информации о канале не подойдет для отправки сообщений через бота - они разные
Функция ПолучитьИнформациюОКанале(Знач Токен) Экспорт
	
	Возврат Инструменты.Get("https://chatapi.viber.com/pa/get_account_info"
		,
		, ТокенВЗаголовки(Токен));
	
КонецФункции

#КонецОбласти


#Область ОтправкаСообщений

Функция ОтправитьТекстовоеСообщение(Знач Токен, Знач Текст, Знач IDПользователя, Знач ОтправкаВКанал) Экспорт
	
	Возврат ОтправитьСообщение(Токен, "text", IDПользователя, ОтправкаВКанал, , Текст); 
	
КонецФункции

Функция ОтправитьСообщение(Знач Токен
	, Знач Тип
	, Знач IDПользователя
	, Знач ЭтоКанал
	, Знач Значение = ""
	, Знач Текст = "")
	
	СтруктураПараметров = ВернутьСтандартныеПараметры();
	СтруктураПараметров.Вставить("type", Тип);	
	СтруктураПараметров.Вставить("text", Текст);
	
	Если ЭтоКанал Тогда
		СтруктураПараметров.Вставить("from", IDПользователя);
		URL = "https://chatapi.viber.com/pa/post";
	Иначе	
		СтруктураПараметров.Вставить("receiver", IDПользователя);
		URL = "https://chatapi.viber.com/pa/send_message";
	КонецЕсли;

	Ответ = Инструменты.PostUrlencoded(URL
		, СтруктураПараметров
		, ТокенВЗаголовки(Токен));
		
	Возврат Ответ;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ВернутьСтандартныеПараметры() 
	
	СтруктураОтправителя = Новый Структура;
	СтруктураОтправителя.Вставить("name"  , "Bot");
	СтруктураОтправителя.Вставить("avatar", "");
	
	СтруктураПараметров  = Новый Структура;
	СтруктураПараметров.Вставить("sender", СтруктураОтправителя);
	СтруктураПараметров.Вставить("min_api_version", 1);
	
	Возврат СтруктураПараметров;
	
КонецФункции

Функция ТокенВЗаголовки(Знач Токен)
	
	СтруктураЗаголовков = Новый Соответствие;
	СтруктураЗаголовков.Вставить("X-Viber-Auth-Token", Токен);
	Возврат СтруктураЗаголовков;
	
КонецФункции

#КонецОбласти
