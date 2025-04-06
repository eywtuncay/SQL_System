
--Bütün çalışanları getir
select * from Employees

-- Bütün siparişleri getir
SELECT * FROM Orders


--Tüm çalışanların sadece id, ad, soyad, doğum tarihini getir.
select EmployeeID, FirstName, LastName, BirthDate
from Employees 

--İsimlendirme	-- 1) as diyerek isim verilir
select EmployeeID as [Personel Numarası], FirstName as Ad, LastName as Soyad, BirthDate as [Doğum Tarihi]
from Employees 

--İsimlendirme	-- 2) as kullanmadan da olur
select EmployeeID [Personel Numarası], FirstName  Ad, LastName  Soyad, BirthDate [Doğum Tarihi]
from Employees 

--İsimlendirme	-- 3) eşittir ile de olur
select   [Personel Numarası] = EmployeeID, isim = FirstName  ,   Soyad = LastName,  [Doğum Tarihi] = BirthDate
from Employees 


select 2+3 as toplam



-- title + title of coursty + isim + soy isim	-- space(2) -> iki boşluk bırakır.
select Title+space(2)+TitleOfCourtesy+space(2)+FirstName+space(2)+LastName from Employees



-- Tekil kayıtları listelemek

-- Müşterilerimin ülke bilgilerini getiriniz.
select Country from Customers



-- Müşterilerimin ülke bilgilerini getiriniz. tekrarı önle
select distinct Country from Customers

-- Birim fiyat bilgisi 50'den fazla olan ürünlerimin id, ad ve fiyat bilgilerini getiriniz.
select ProductID, ProductName, UnitPrice from Products
where UnitPrice>50

-- Adı Beverages olan kategorilerimin id ve adı nedir?
select CategoryID, CategoryName from Categories
where CategoryName='Beverages'


-- amerikada yaşayan kadın çalışanlarımın ad, soyad, ülke bilgilerini getiriniz.
select FirstName, LastName, Country from Employees
where Country = 'USA' and TitleOfCourtesy = 'Mrs.' or TitleOfCourtesy = 'Ms.'


-- Andrew fuller'e rapor veren çalışanlarım kimdir
select * from Employees
where ReportsTo = 2


-- Bölge bilgisi olmayan / belirtmeyen çalışanlarımın adı ve soyadı
select FirstName, LastName, Region from Employees
where Region is null



-- BETWEEN: Arasında kalmak. iki ismin. iki tarihin. iki sayının - sınırları kabul eder.

-- Doğum yılı 1950 ile 1961 yılı arasında kalan çalışanlarım kimdir.
select FirstName, LastName, year(BirthDate) from Employees
where year(BirthDate) between 1950 and 1961


-- İsmi alfebatik Andrew ile Janet arasında kalan çalışanlarım kimdir.
select * from Employees
where  FirstName between 'Andrew' and 'Janet'


-- IN: içinde olmak. Sunulan seçeneklerin biriyse in (x,y)

-- Kimin doğum yılı 1955 ya da 1690 ya da 1956'dır.
select * from Employees
where year(BirthDate)=1955 or year(BirthDate)=1960 or year(BirthDate)=1956	-- bu şekilde de çözülebilir.

select * from Employees
where year(BirthDate) in (1955,1960,1956)


-- Kimin unvanı Dr. ya da Mr. 'dir.
select * from Employees
where TitleOfCourtesy in ('Dr.', 'Mr.')



-- TOP: En tepedeki X adet.

select top 3 * from Categories -- İlk 3 category'i getirdi.



-- LIKE: gibi/benzetmek --> like x% ---- %x ----- %x%

-- Adı a ile başlayan müşteriler
select * from Customers
where CompanyName like 'a%'

-- Adı a ile biten müşteriler
select * from Customers
where CompanyName like '%a'


-- Adında a geçen müşteriler
select * from Customers
where CompanyName like '%a%'


-- Adında r veya t geçen müşteriler
select * from Customers
where CompanyName like '%[rt]%'


--Adının ilk harfi a-k arasında olan müşteriler
select * from Customers
where CompanyName like '[ak]%'


-- üçüncü harfi a olan
select * from Customers
where CompanyName like '__a%'



-- SIRALAMA İŞLEMLERİ - ORDERBY


-- Defaultta asc(ascending) olarak az --> çok sıralanır. desc(descending) çoktan aza sıralanır.
-- tarihsel, sayısal, alfebetik olarak sıralama yapılabilir.



-- Çalışanları adlarına göre alfebetik sıralayılım. Ad, soyad kolonu gelsin.
select FirstName, LastName from  Employees 
order by FirstName asc



-- Ürün fiyatını 20-50 arasında olanları stoklarına göre çoktan aza sıralayalım. ad, fiyat, stok gelsin
select ProductName, UnitsInStock, UnitPrice from Products
where UnitPrice between 20 and 50
order by UnitsInStock desc



-- Aynı isimde ve farklı soyadda 4 çalışan ekleyiniz. Bu çalışanları ada göre a-->z ve soyada göre z-->a sırala.

insert into Employees(FirstName, LastName)
values('Tuncay','a')

insert into Employees(FirstName, LastName)
values('Tuncay','b')

insert into Employees(FirstName, LastName)
values('Tuncay','c')

insert into Employees(FirstName, LastName)
values('Tuncay','d')

select * from Employees

select * from Employees
order by FirstName asc, LastName desc


-- NOT: Kolon sırasına göre de sıralayabiliriz. LastName'e göre asc ve Title'a göre dsc sıralama; 
select FirstName, EmployeeID, LastName, Title from Employees
order by 3, 4 desc



-- En yaşlı 3 çalışanımı ad soyad (yaş) olarak tek kolon içerisinde getiriniz.

SELECT TOP 3 
    FirstName + SPACE(1) + LastName + ' (' + CONVERT(nvarchar(90), DATEDIFF(year, BirthDate, GETDATE())) + ')' AS FormatliAd 
FROM Employees 
WHERE BirthDate IS NOT NULL 
ORDER BY BirthDate DESC;



-- AGGREGATE FUNCTIONS (TOPLAM/TOPLAMLI FONKSİYONLAR): count, avg, sum, min, max

-- COUNT(*, Kolon Adı) --> * ifadesi ilgili guruptaki herkesi sayar.
							--Kolon Adı ise o kolonun altındaki Dolu satırları sayar


-- Kaç adet ürünüm var?
select count(*) as SatirSayisi from Products
select count(ProductID) as SatirSayisi from Products
select count(QuantityPerUnit) as SatirSayisi from Products


-- AVR(Kolon Adı) --> İlgili kolonun ortalamasını alır fakat kolon metinsel ya da tarihsel bir tip ise hata verir.
select avg(UnitPrice) from Products

-- Çalışanlarımın ortlama yaşı kaçtır?
select avg (DATEDIFF(year, BirthDate, GETDATE())) ortalamaYas from Employees

-- SUM(Kolon Adı) --> İlgili kolon altındaki tüm değerleri toplar. Sadece sayısal değerleri toplayabilir

--Elimdeki toplam stok miktarı nedir.
select sum(UnitsInStock) [ToplamStokMiktari] from Products


-- Bugüne kadar kargolara ne kadar para ödedim
select sum(Freight) from Orders


-- MIN: Minumu Değer, MAX: Maximum Değer. İlgili kolondaki en küçük ve en büyük değerleri döndürür.

-- En ucuz ve en pahalı ürünlerimizin fiyatları nedir
select min(UnitPrice)[En uygun fiyat], max(UnitPrice)[En pahalı fiyat] from Products


-- NOT: Metotların hepsi geriye tek bir değer döner


------ GROUP BY: Gruplama işlemleri için kullanılır.


-- Her ülekede kaç müşterim vardır?
select Country Ulke, count (*) as [Müsteri Sayisi] from Customers
group by Country
order by [Müsteri Sayisi] desc



-- Birim fiyatı 40'ın üzerinde olan ürünlerimi kategorilerine göre gurupla,
	-- her guruptaki toplam stok miktarını bul ve miktara göre sıralı getir.

select CategoryID, sum(UnitsInStock) as Stok
from Products
where UnitPrice>40
group by CategoryID
order by Stok desc



-- Subquery (iç içe sorgu)

-- Norske Meierier firmasının tedarik ettiği ürünlerin kategorilerinin adı?
select CategoryName, CategoryID from Categories
where CategoryID in (select CategoryID from Products
where SupplierID in (select SupplierID from Suppliers
where CompanyName = 'Norske Meierier'))


-- Fiyatı, ortalama birim fiyatının üzerinde olan ürünlerin adları nelerdir?
SELECT ProductName FROM Products 
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);


-- Kuzen bölgesinden sorumlu çalışanların adları nelerdir?
select FirstName, LastName from Employees
where EmployeeID in (select EmployeeID from EmployeeTerritories
where TerritoryID in (select TerritoryID from Territories
where RegionID=(select RegionID from Region
where RegionDescription='Northern')))





-- romoro y tomillo firmasına gönderdiğim siparişlerimi hangi çalışanlarım onaylamıştır? Ad - Soyad
select FirstName, LastName from Employees
where EmployeeID in(select EmployeeID from Orders
where CustomerID in (select CustomerID from Customers
where CompanyName = 'Romero y tomillo'))



-- Brezilyada yaşayan müşterilerimden en yüksek sipariş tutarı nedir? - Ödev. Şu anda hepsini çekiyor. sipariş tutarına göre fiyat hesaplanıyor

 select top 1 
     sum(UnitPrice*Quantity*(1-Discount)) as NetTutar
 from [Order Details] where OrderID in (select OrderID from Orders where CustomerID in (select CustomerID from Customers where Country = 'Brazil' ))
 group by OrderID
 order by NetTutar desc;



-- ortalama birim fiyatın üzerinde kalan ürünlerimi satmadığım müşterilerimin adları?
select * from Customers
where CustomerID not in (select CustomerID from Orders where
OrderID in (select OrderID from [Order Details]
where ProductID in (select ProductID from Products
where UnitPrice > (select avg(UnitPrice) from Products))))



-- steven adlı çalışanım hangi tedarikçimin ürünlerini satıyor?
select CompanyName from Suppliers
where SupplierID in (select SupplierID from Products)
where ProductID in (select ProductID from [Order Details]
where OrderID in(select OrderID from Orders
where EmployeeID in (select EmployeeID from Employees
where FirstName ='Steven') ))




