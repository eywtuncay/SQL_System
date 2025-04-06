
create database Matbaa



/*

1) (INNER) JOIN



2) (OUTER) JOIN
--	LEFT (OUTER) JOIN
--	RIGHT (OUTER) JOIN
--	FULL (OUTER) JOIN

Ortak anahtarı üzerinden ilişkisi bulunan tablolar birleştirilerek tek tablo gibi davranır ve üzerinden sorgulamalar yapılır.
Kalıcı bir değişiklik değildir.

Join'in sağında kalan hep RIGHT TABLE, solunda kalan hep LEFT TABLE kabul edilir.


*/



-- Nortwind üzerinde product ve category tablosunu join'leyerek farklı türleri deneyelim.

--select ProductName, CategoryName
--from Products join Categories on Products.CategoryID = Categories.CategoryID





create table Yazarlar
(
	YazarId int primary key identity(1,1),
	YazarAd nvarchar(40) not null,
	YazarSoyad nvarchar(40) not null,
	DogumYeri nvarchar(50)
)


create table Kitaplar
(
	KitapId int primary key identity(1,1),
	KitapAdi nvarchar(40) not null,
	SayfaSayisi int,
	YazarId int,
	constraint fk_yazarlar foreign key(YazarId) references Yazarlar(YazarId)

)

-- Inner Join
select YazarAd, YazarSoyad, KitapAdi from Yazarlar y join Kitaplar k on k.YazarId = y.YazarId



-- Left Join
select YazarAd, YazarSoyad, KitapAdi
from Yazarlar y left join Kitaplar k on k.YazarId = y.YazarId



-- Right Join
select YazarAd, YazarSoyad, KitapAdi
from Yazarlar y right join Kitaplar k on k.YazarId = y.YazarId



-- Full Join
select YazarAd, YazarSoyad, KitapAdi
from Yazarlar y full join Kitaplar k on k.YazarId = y.YazarId



-- Northwind --> Adında Leka geçen tedarikçilerimin tedarik ettiği ürünlerden ne kadar kazandım?
select sum(od.UnitPrice*od.Quantity*(1-od.Discount)) as ToplamKazanc, s.SupplierID, s.CompanyName
from [Order Details] od inner join Products p on p.ProductID=od.ProductID
						inner join Suppliers s on s.SupplierID=p.SupplierID
where CompanyName like '%Leka%'
group by s.SupplierID, s.CompanyName




-- Speddy express kargo firması ile taşınan ürünlerimin kategorileri ve adları nelerdir?

select distinct CategoryName
from Shippers s join Orders o on o.ShipVia=s.ShipperID
join [Order Details] od on od.OrderID=o.OrderID
join Products p on p.ProductID=od.ProductID
join Categories c on c.CategoryID=p.CategoryID
where s.CompanyName = 'Speddy express';




-- Bana en çok kazandıran müşterimin adı nedir?
select top 1 sum(od.UnitPrice*od.Quantity*(1-Discount)) as Kazanc, c.CompanyName
from Customers c join Orders o on c.CustomerID=o.CustomerID
join [Order Details] od on od.OrderID=o.OrderID
group by c.CompanyName
order by Kazanc desc



-- Andrew fuller'e rapor verenleri join ile deneyelim. (çalışanlar- employees)
select * from Employees
select raporVeren.FirstName,raporVeren.Lastname
from Employees raporVeren join Employees raporAlan on raporVeren.ReportsTo=raporAlan.EmployeeID
where raporAlan.FirstName = 'Andrew'



-- Çalışanlarım kaç yaşında işe başlamıştır?
select FirstName, LastName, DATEDIFF(YEAR, BirthDate, HireDate) as IseBaslamaYasi
from Employees
where HireDate is not null
order by IseBaslamaYasi desc




-- Stoğu en fazla olan ürünümün stoğu kaçtır.
select top 1 *
from Products
order by UnitsInStock desc


-- Robert, Margaret ya da Anne tarafından onaylanan/alınan ve madrid'e kargolanan siparişlerim hangi müşterime ait? isimleri?
select distinct CompanyName
from Customers c join Orders o on c.CustomerID = o.CustomerID
join Employees e on e.EmployeeID = o.EmployeeID
where FirstName in ('Margaret', 'Anne', 'Roberts') and ShipCity = 'Madrid'



-- Geciken siparişlerim hangi kargo firmasıyla taşınmış
select distinct CompanyName
from Orders o join Shippers s on s.ShipperID=o.ShipVia
where RequiredDate < ShippedDate


