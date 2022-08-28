/*Тестовые задания на позицию Junior SQL Developer*/

-- Создание и заполнение таблиц
create table p.Promo (
	ID			int
	,Store		varchar(255)
	,Product	varchar(255)
	,DateBegin	date
	,DateEnd	date
	)

;insert into p.Promo (ID, Store, Product, DateBegin, DateEnd)
values
	(1,		'Tesco',	'Gum',			'2018-07-21',	'2018-07-29')
	,(2,	'Tesco',	'Fish',			'2018-08-01',	'2018-08-17')
	,(3,	'Tesco',	'Juice',		'2018-06-06',	'2018-06-15')
	,(6,	'Tesco',	'Shampoo',		'2018-06-28',	'2018-07-07')
	,(7,	'Tesco',	'Coffee',		'2018-06-14',	'2018-06-30')
	,(9,	'Tesco',	'Sugar',		'2018-07-05',	'2018-07-19')
	,(10,	'Tesco',	'Tea',			'2018-06-01',	'2018-06-05')
	,(11,	'Tesco',	'Milk',			'2018-08-03',	'2018-08-14')
	,(12,	'Tesco',	'Wet Wipes',	'2018-08-20',	'2018-08-31')
	,(13,	'Billa',	'Shampoo',		'2018-06-28',	'2018-07-07')
	,(14,	'Billa',	'Coffee',		'2018-06-12',	'2018-06-27')
	,(15,	'Billa',	'Sugar',		'2018-08-01',	'2018-08-12')
	,(16,	'Billa',	'Tea',			'2018-06-04',	'2018-06-18')
	,(17,	'Billa',	'Milk',			'2018-07-07',	'2018-07-21')
	,(18,	'Billa',	'Wet Wipes',	'2018-08-10',	'2018-08-25')
	,(19,	'Auchan',	'Coffee',		'2018-06-05',	'2018-06-18')
	,(20,	'Auchan',	'Fish',			'2018-07-22',	'2018-08-02')
	,(21,	'Auchan',	'Sugar',		'2018-07-01',	'2018-07-31');

-- 1. Таблица: dbo.Promo
--    Вывести номер акции, название магазина и название продукта, а также
--    номер акции и название продукта, где акция
--    пересекается по датам проведения с другими акциями для данного магазина
--    * - желательно исключить повторяющуюся информацию о пересечениях
--3 вариант, только пересечение


  select
  p1.id as id,
  p1.Store as store1,
  p1.product as product1,
  p2.id as id2,
  p2.product as product2
from
  p.promo p1
  join p.promo p2 on p1.store = p2.store
  and (
    (
      p1.datebegin between p2.datebegin
      and p2.dateend
      or p2.datebegin between p1.datebegin
      and p1.dateend
    )
    OR (
      p1.dateend between p2.datebegin
      and p2.dateend
      or p2.dateend between p1.datebegin
      and p1.dateend
    )
  )
  and p1.product <> p2.product
  and p1.id < p2.id
order by
  p1.id,
  p1.store,
  p1.product
	
	-- ещё 1 запрос, где я использую агр. функцию string_agg, посмотрите разницу в строках
	--кстати, можно сократить условие, прописав p1.datebegin <= p2.dateend
	--or p2.datebegin <= p1.dateend	
	
	select
  p1.id as id,
  p1.Store as store1,
  p1.product as product1,
  string_agg (concat (p2.id:: text, '; ', p2.product), ';') as product2
from
  p.promo p1
  join p.promo p2 on p1.store = p2.store
  and (
    (
      p1.datebegin between p2.datebegin
      and p2.dateend
      or p2.datebegin between p1.datebegin
      and p1.dateend
    )
    OR (
      p1.dateend between p2.datebegin
      and p2.dateend
      or p2.dateend between p1.datebegin
      and p1.dateend
    )
  )
  and p1.product <> p2.product
  and p1.id < p2.id
group by
  1,
  2,
  3
order by
  p1.id,
  p1.store,
  p1.product