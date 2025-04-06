
-- Kategorilere göre toplam stok miktarını bulunuz
select * from Products

select  c.CategoryName, sum(p.UnitsInStock)
from Products p
JOIN Categories c on p.CategoryID = c.CategoryID
group by c.CategoryName




-- her bir çalışanın ad-soyad toplamında ne kadarlık satış yaptığını bulalım ve çoktan aza sıralayalım --TEKRAR BAK

--select  e.FirstName + e.LastName as EmployeeName, e.EmployeeID sum() as ToplamSatis
--from Employees e
--JOIN Orders o on e.EmployeeID = o.EmployeeID
--group by e.EmployeeID, e.FirstName, e.LastName
--order by ToplamSatis desc;



select * from [Order Details]
select * from Employees
select * from Orders




-- Federal shipping ile taşınan ve nancy adlı çalışanım tarafından onaylanan siparişler hangileridir
select o.OrderID, o.OrderDate, o.ShippedDate, e.FirstName  + e.LastName as CalisanAdi, s.CompanyName as KargoAdi
from Orders o
JOIN Employees e on o.EmployeeID = e.EmployeeID
JOIN Shippers s on o.ShipVia = s.ShipperID
where e.FirstName = 'Nancy' AND s.CompanyName = 'Federal Shipping'





-- Hangi kadın çalışanlarımın yaptığı satışlarımın indirimsiz tutarı 2000'in üzerindedir?
select FirstName as isim, sum(UnitPrice*Quantity) as tutar
from Employees e join Orders o on o.EmployeeID=e.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
where e.TitleOfCourtesy in ('Ms.','Mrs.')
group by FirstName
having sum(UnitPrice*Quantity)>2000




-- Her bir kargo firmasına toplam ne kadar ödeme yapmışım
select  s.CompanyName as ShipperName, sum(o.Freight) as ToplamOdeme
from Orders o
JOIN Shippers s on o.ShipVia = s.ShipperID
group by s.CompanyName
order by ToplamOdeme desc;



-- Bugüne kadar oluşturduğu Sipariş adeti 70'den fazla olan çalışanlarımızı bulalım (ad ve soyad ile beraber)
select e.FirstName + ' ' + e.LastName as EmployeeName, count(o.OrderID) as OrderCount
from Employees e
JOIN Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName, e.LastName
having count(o.OrderID) > 70
order by OrderCount desc;




-- Kategorilere göre kazancımı bulmak istersem, en çok kazandıran 3 kategori nedir	--TEKRAR BAKS
--SELECT c.CategoryName, SUM(Quantity * od.UnitPrice) AS ToplamKazanc
--FROM Products p
--JOIN OrderDetails od ON p.ProductID = od.ProductID
--JOIN Categories c ON p.CategoryID = c.CategoryID
--GROUP BY c.CategoryName
--ORDER BY ToplamKazanc DESC
--LIMIT 3;





-- 1997 yılında alınan siparişeri hangi çalışanım almıştır?
select FirstName, LastName
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
where year(OrderDate)=1977
group by FirstName, LastName







--- SELF JOIN: Bir tablonun kendisiyle joing işlemine tabi tutulmasıdır. Hiyerarşik verileri sorgulamak ya da aynı tablodaki satırları kıyaslamak için kullanılır. Karışıklık olmaması adına tablolara alias(takma ad) verilmelidir. Normal join'in aynı tabloları birleştirilmesi

-- Tüm çalışanlarımı ve varsa yöneticilerini getiriniz
select e1.FirstName+space(2)+e2.LastName CalisanAd, e2.FirstName+SPACE(2)+e2.LastName
from Employees e1 left join Employees e2 on e1.ReportsTo=e2.EmployeeID
order by CalisanAd



-- Aynı kategorideki ürünlerimi getiriniz.
select p1.ProductName as Urun1, p2.ProductName as Urun2, p1.CategoryID
from Products p1 join Products p2 on p1.CategoryID=p2.CategoryID and p1.ProductID<p2.ProductID





-- SORGULARIN BİRLEŞTİRİLMESİ

-- UNION	 : İki veya daha fazla select sorgusunun sonuçlarını birleştirir. Dublicate olanları göstermez yani tekrarlı olanları göstermez. Birleşen sorgu sonuçlarının tipi, adeti aynı olmalıdır. 
-- UNION ALL : Yine iki veya daha fazla sorgu sonucunu birleştirir ancak tekrarlı veriyi de gösterir.
	
-- Dikkat: Sonuçları birleştiri, tabloları değil. Tabloları join ile birleştiririz.


select City from Customers
union 
select City from Suppliers

--
select City from Customers
union all
select City from Suppliers


-- Soru: Aynı ülkedeki müşteri ve tedarikçilerin ad ve ülkelerini birleştirelim.

select CompanyName, Country from Customers where Country='Brazil'
union
select CompanyName, Country from Suppliers where Country='Brazil'


select CompanyName, Country from Customers where Country='Brazil'
union all
select CompanyName, Country from Suppliers where Country='Brazil'



-- EXCEPT: Birleşen iki sonuçtan ilki ile ikinciyi kıyaslar ve ilkinde olup ikincisinde olmayan sonuçları döner


--SORU: Ürünler tablosunda olup satışı olmayan/satılmayan ürünler
select ProductID from Products
except
select ProductID from [Order Details]

insert Products (ProductName, Discontinued) values ('patates',0)


-- INTERSECT: Birleşen iki sonucun kesişimini, ortak olan sonuçlarını verir.

-- SORU: Liste fiyatına satılan ürünlerimin adları
select UnitPrice, ProductID from Products
intersect
select UnitPrice, ProductID from [Order Details]




--- TARİHSEL FONKSİYONLAR

-- DATEPART(): Bir tarih bilgisinin istediğimiz kısmını alırız.

select FirstName, LastName, DATEPART(YY,BirthDate) as DogumYili
from Employees 


select FirstName, LastName, DATEPART(DY,BirthDate) as YılınKacıncıGunu
from Employees 


select FirstName, LastName, DATEPART(mm,BirthDate) as DogumAyı
from Employees 




-- DATEDIFF(x, y, z): İki tarih arasında istenen tipten bir fark alır.
select FirstName, DATEDIFF(YEAR, BirthDate, GETDATE()) as Yas
from Employees

-- kaç gündür dünyada
select FirstName, DATEDIFF(DAY, BirthDate, GETDATE()) as KacGundurDunyada
from Employees

-- kaç yaşında işe girmiş
select FirstName, DATEDIFF(DAY, BirthDate, HireDate) as KacYAsındaIseGirdi
from Employees


select FirstName, YEAR(GETDATE()) - YEAR(BirthDate) as yas
from Employees




--- STRİNG FONKSİYONLAR

select ASCII('A') as AscııKodunuPaylasir

select LOWER('MerHabaLar') as KucukHarfliHali

select UPPER('MerHabaLar') as BuyukHarfliHali

select LEFT('Merhaba', 3) as SoldanKarakterAl

select RIGHT(FirstName, 3) as SagdanKarakterAl from Employees

select CHAR(83) BuAscıKoduHangiKarakter

select LEN('selam') as KarakterSayisiGetirir

select REPLACE('bir bir birilerine', 'bir', 'iki') as YerDegistirme

select SUBSTRING('Gazi Antep', 2, 5) as IfadedeIstedigimIndekstenSonraKarakterSayısınıAl

select 1/3

select 1/3.0

select CAST(1 as float)/3



