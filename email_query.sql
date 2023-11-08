/*Работа с полями email*/

/*Запрос выбирающий дубли emails*/
select `email` from zm_students 
where email IN (SELECT `email` FROM `zm_students` GROUP BY `email` HAVING COUNT(*) > 1)
and email !=' '
ORDER BY `email`;

select *,`email` from op_students
where email IN (SELECT `email` FROM `op_students` GROUP BY `email` HAVING COUNT(*) > 1)
and email !=' '
ORDER BY `email`;

/*Выбор email ов где бараны написали единицу*/
SELECT *,  length(substring_index(email, '@', 1)) as mailcount FROM current190922.op_students 
where  length(substring_index(email, '@', 1)) = 1;

/*Вывести email где email = no.email*/
SELECT *, SUBSTRING_INDEX(email, '.', -2) AS substring
FROM op_students
where email like '%@no.mail';

/*Запрос обрезающий часть email до @*/
SELECT *, substring_index(email, '@', 1) as cut_email  FROM op_students;

/*Обновление дублирующихся emails выборка осуществляется сравнением исходной таблицы zm_students и op_students*/
UPDATE op_students `os`
SET os.email = concat(os.username,'@','no.mail')
        where os.email IN (select email from zm_students group by email having count(*) > 1);

/*Обновить op_students где username в таблице email c некорректным email*/
UPDATE op_staff_bulk_diff /*Обновить staff_bulk из другого файла*/
SET email = select email from zm_mail_user
WHERE username IN (SELECT username from tmp_bad_email);

/*Обновить email zm_dom users где email пустой*/
UPDATE zm_dom_users `du`
SET os.email = concat(du.login,'@','no.mail')
where email not like '%@%';

/*обновить op_staff_bulk из zm_mail users*/
UPDATE op_staff_bulk_diff osb, zm_mail_users zu 
SET osb.email =  zu.email
WHERE osb.username = zu.login;

/*Создать таблицу zm_mail_users как выбор всех полей из zm_dom_users*/
create table zm_mail_users as SELECT * FROM zm_dom_users; 


/*вставить в таблицу zm_dom_users email вида no.email, где email пустой или не корректный*/
insert into select login, staff_id, code_staff, concat( login,'@','no.mail') as email
from zm_dom_users where email not like '%@%';  /*Вставить email адреса из другой таблицы*/

/*Добавить строки в zm_mail_users из zm_dom_users где email корректный*/
insert into zm_mail_users select staff_id, code_staff, email from zm_dom_users 
where email like '%@%' ; 

/* Вставить email адреса из другой таблицы*/
insert into zm_mail_users 
select login, staff_id, code_staff, concat( login,'@','no.mail') as email
from zm_dom_users where email not like '%@%';  /*Вставить email адреса из другой таблицы*/

 /*Вставить с emailами форматами *.no.mail*/
insert into zm_mail_users
select *
from zm_dom_users where email like '%no.mail%';

/*Удалить все строки без email адресов из таблицы zm_dom_users*/
delete from zm_dom_users where email not like "%@%"; 
/*Удалить все строки без email адресов таблицы zm_mail_users*/
delete from zm_mail_users where email not like "%@%"; 

/*Выбрать все строки без емейлов и с некоректными email ами*/
select * from zm_mail_users where email not like '%@%'; 