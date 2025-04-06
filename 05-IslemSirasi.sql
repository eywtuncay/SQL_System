

/*

HAVING: Sorgu sonucu dönen kümede aggregate func. bağlı olacak şekilde bir filtreleme işlemi yapılacaksa,
where değil having kullanırız.

Eğer aggregate func. yok ise where ile having aynı işlemi yapar.
Dikkat etmemiz gerken neye göre filtrelediğimizdir.

İŞLEM SIRASI	AŞAMA
5				select
1				from
2				where
3				group by
4				having
6				order by

Tüm hepsinin kullanıldığı bir sorguda sıralama bu şekilde olur.
Herhangi biri olmadığında da akış aynen devam eder.

*/


-- Toplam tutar bilgisi 2600 ile 3500 arasında olan siparişlerimi çoktan aza sırala
select OrderId, sum(UnitPrice*Quantity*(1-Discount)) as kazanc from [Order Details] 
group by OrderID
having sum(UnitPrice*Quantity*(1-Discount)) between 2600 and 3500
order by kazanc desc




-- Her bir siparişteki toplam ürün adeti sayısı 200'den az olanları getir
select * from [Order Details]

select OrderID, sum(Quantity) from [Order Details] group by OrderID having sum(Quantity)<100




