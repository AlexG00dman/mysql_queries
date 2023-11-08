/*Запрос выбирающий дубли emails*/
/*HAVING*/
select `email` from zm_students 
where email IN (SELECT `email` FROM `zm_students` GROUP BY `email` HAVING COUNT(*) > 1)
and email !=' '
ORDER BY `email`;