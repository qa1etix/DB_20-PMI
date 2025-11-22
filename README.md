<h1>Описание предметной области</h1>
<ol style="font-size: 18px;">
<li>Информация об абонентах:</li>
    <ul style="font-size: 15px; list-style-type: none;">
        <li>ИНН</li> 
        <li>Адрес</li> 
        <li>ФИО</li>
        <li>Название организации (для юр. лиц)</li>
        <li>Лицевой счет (с поступлениями и списаниями средств)</li>
    </ul>
<li>Прайс:</li>
    <ul style="font-size: 15px; list-style-type: none;"> 
        <li>Населенный пункт</li> 
        <li>Стоимость в дневное/ночное время</li> 
    </ul>
<li>Информация о звонках:</li> 
    <ul style="font-size: 15px; list-style-type: none;">
        <li>Населенный пункт</li> 
        <li>Дата</li> 
        <li>Время суток</li> 
        <li>Длительность</li>
    </ul>
</ol>

<h1>Лабораторная работа 1</h1>
<h4>ER модель</h4>
<img alt="Лабораторная 1.1" src="https://github.com/qa1etix/DB_20-PMI/blob/main/img/1.1.png">
<h4>Реляционная модель</h4>
<img alt="Лабораторная 1.2" src="https://github.com/qa1etix/DB_20-PMI/blob/main/img/1.2.png?raw=true">

<h1>Лабораторная работа 2</h2>
<p>Ввиду еще не реализованных триггеров логика insert запросов была задана искусственно, например, <br>
для транзакий возникающих на списание за звонки (они должны будут возникать автоматически (транзакции на звонки)), <br>
а так же само по себе списание (если транзкация имеет тип "списание"). Конечно, набор аттрибутов, вероятно не конечный.<br>
Скрипт создания таблиц и инсерты находятся в папке "Лабораторная 2" </p>
<h4>Результат выполнения запросов</h4>
<img alt="Лабораторная 2 - users"        src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 2/img/users.png">
<img alt="Лабораторная 2 - accounts"     src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 2/img/accounts.png">
<img alt="Лабораторная 2 - calls"        src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 2/img/Calls.png">
<img alt="Лабораторная 2 - city"         src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 2/img/City.png">
<img alt="Лабораторная 2 - transactions" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 2/img/transactions.png">

<h1>Лабораторная работа 4</h1>

<h2>Процедуры</h2>
<p>A.</p>
<img alt="Лабораторная 4 - Процедуры, A" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Процедуры/1aRES.png">
<p>B.</p>
<img alt="Лабораторная 4 - Процедуры, B" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Процедуры/1bRES.png">
<p>C.</p>
<img alt="Лабораторная 4 - Процедуры, C" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Процедуры/1cRES.png">
<p>D.</p>
<img alt="Лабораторная 4 - Процедуры, D" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Процедуры/1dRES.png">

<h2>Функции</h2>
<p>A.</p>
<img alt="Лабораторная 4 - Функции, A" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Функции/2aRES.png">
<p>B.</p>
<img alt="Лабораторная 4 - Функции, B" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Функции/2bRES.png">
<p>C.</p>
<img alt="Лабораторная 4 - Функции, C" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Функции/2cRES.png">

<h2>Триггеры</h2>

<p>A.</p>
<h3>Счета пользователей до</h3>
<img alt="Лабораторная 4 - Триггеры, A" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/A/accounts_1.png">
<h3>Счета пользователе после</h3>
<img alt="Лабораторная 4 - Триггеры, A" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/A/accounts_after.png">
<h3>Звонки</h3>
<img alt="Лабораторная 4 - Триггеры, A" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/A/calls_after.png">
<h3>Транзакции</h3>
<img alt="Лабораторная 4 - Триггеры, A" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/A/transactions_after.png">

<p>B.</p>
<h3>Должники</h3>
<img alt="Лабораторная 4 - Триггеры, B" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/B/debtor.png">
<h3>После Update</h3>
<img alt="Лабораторная 4 - Триггеры, B" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/B/After Update.png">

<p>C.</p>
<h3>Таблица city</h3>
<img alt="Лабораторная 4 - Триггеры, C" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/C/city.png">
<h3>После DELETE</h3>
<img alt="Лабораторная 4 - Триггеры, C" src="https://github.com/qa1etix/DB_20-PMI/blob/main/Лабораторная 4/Изображения/Триггеры/C/after_delete.png">