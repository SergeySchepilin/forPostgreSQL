-- Отпуска сотрудников
create table p.Vacation (
ID serial not null primary key,
ID_Employee int not null references p.Employee(ID),
DateBegin date not null,
DateEnd date not null)
;

insert into p.Vacation (ID_Employee, DateBegin, DateEnd)
values (1, '2019-08-10', '2019-09-01')
,(1, '2019-05-13', '2019-06-02')
,(1, '2019-12-29', '2020-01-14')
,(2, '2019-05-01', '2019-05-15');
-- Задача. Вывести имена сотрудников, которые не были в отпуске в 2020 году
-- Должно вернуться 2 строки: Petrov Petr Petrovich, Sidorov Sidr Sidorovich
-- * - задание желательно решить без использования Distinct
--это задание 2
select
  name
from
  p.vacation as v
  JOIN p.employee as e on v.ID_Employee = e.id
where
  date_trunc ('year', DateEnd) != '2020-01-01'
group by
  1


--Задание 3 – Написать запрос для данных из Сотрудники.txt, который выводит список периодов и 
--кол-во сотрудников находившихся в этот период в отпуске. 
--Необходимо сделать тестовый пример, который воспроизводит разные ситуации пересечения отпусков. 
--Результат должен быть со столбцами: DateBegin, DateEnd, Count. Периоды должны быть расположены последовательно. 
--Вывести периоды, в которые не было ни одного человека в отпуске. Т.е. чтобы в Count для некоторых периодов была цифра 0

  
 --пример:

WITH
  cte AS (
    SELECT x::date, SUM(inc) AS inc
      FROM (
        SELECT date'2019-01-01' AS x, 0 AS inc
        UNION ALL
          SELECT date'2019-12-31', 0
        UNION ALL
          SELECT DateBegin, +1
            FROM p.Vacation
		  UNION ALL
          SELECT DateEnd + INTERVAL '1 DAY', -1
            FROM p.vacation
        
      ) AS t
      GROUP BY x
    )
SELECT (LAG(x, 1) OVER win)::date AS DateBegin,
       (x - INTERVAL '1 DAY')::date AS DateEnd,
       (SUM(inc) OVER win) - inc AS "Count"
  FROM cte
  WINDOW win AS (ORDER BY x ROWS UNBOUNDED PRECEDING)
 