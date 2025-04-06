
/*

Temelde 4 tip fonksiyondan bahsedebiliriz

1) Scalar Value Func.
2) Table Falue Func.
3) Aggregare Func.
4) System Func.


UDF yani UserDefine Func. bizim tarafımızdan tanımlanan func. ve scalar/table value olabilir.
Fonksiyonlar alışık olduğumuz bildiğimiz mantıkta hesaplamalar ve bazı işlemlerde kullanacağımız yapılar olacaktır.

return/Returns ile geriye değer döner.
Parametre alabilir/almayabilir.
Fonk. birer database nesnesi olduğundan DDL komutları onlar içinde geçerlidir.
Subqueryler içinde kullanılabilirler.
Table Falue Fonk. sadece SELECT ile kullanılacaktır.

*/


-- Soru: aldığı tutar ve vergi oranı ile, ödenmesi gereken vergili tutarı döndüren fonk. yazınız.

create function VergiliTutarHesapla(@Anapara money, @Oran float)
returns money
as
begin
return @Anapara*(1+@Oran/100)
end



select * from Products

select dbo.VergiliTutarHesapla(200,25) as VergiliTutar
select dbo.VergiliTutarHesapla(UnitPrice,13), UnitPrice, ProductName
from Products where UnitPrice>0



-- Soru: Doğum tarihi bilgisi alan ve yaşını hesaplayan metot

create function YasHesapla(@DogumTarihi date)
returns int
as
begin
return datediff(year, @DogumTarihi, getdate())
end

select FirstName, dbo.YasHesapla(BirtDate) from Employees 




-- Soru: Alınan ad, soyad paremetresine göre ad.soyad@gmail.com mail adresini oluşturan fonksiyonu yazınız.

create function MailOlustur(@Ad varchar(50), @Soyad varchar(50))
returns varchar(100)
as
begin
return @Ad+'.'+@soyad+'@gmail.com'
end

select dbo.MailOlustur('tuncay','albayrak') 




-- Soru: Alınan productId bilgisine göre, ilgili ürünün stok miktarı 0 ise "yok". 1-10 arasında ise "Stok az" ve 10'dan fazlaysa "Stok var" ifadelerini dönen fonksiyon.

create function StokDurumu(@ProductId int)
returns nvarchar(70)
as
begin
declare @stok int 
select @stok=UnitsInStock from Products where ProductID=@ProductId
if @stok = 0 return 'Stok yok'
if @stok <= 10 and @stok >= 1 return 'Stok az'
return 'Stok var'
end


select ProductID, ProductName, UnitsInStock, dbo.StokDurumu(ProductID) from Products 




-- Çalışan isimlerinde, dışarıdan girilen harf ile başlayan çalışanların tüm bilgilerini getirecek fonksiyonu yazınız.(return table)
alter function HarfeGoreCalisanGetir(@Harf nvarchar(1))
returns table
as
return
    select * from Employees
    where FirstName LIKE @Harf + '%';

select *  from dbo.HarfeGoreCalisanGetir('a');



-- kategoriId bilgisi alan ve bu kategoriden kaç adet ürün satıldığını dönen fonksiyonu yazınız.
alter FUNCTION KategoriSatilanUrunSayisi(@KategoriId INT)
RETURNS INT
AS
BEGIN
    DECLARE @ToplamSatilan INT;

    SELECT @ToplamSatilan = SUM(od.Quantity) FROM [Order Details] od
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE p.CategoryID = @KategoriId;

	RETURN @ToplamSatilan;
END;

SELECT dbo.KategoriSatilanUrunSayisi(1);



select * from Categories



-- Alınan iki tarih arasındaki geciken siparişlerin tüm bilgilerini getiren fonksiyonu yazınız.
ALTER FUNCTION GecikenSiparisler(@BaslangicTarihi DATE, @BitisTarihi DATE)
RETURNS TABLE
AS
RETURN
    SELECT * FROM Orders
    WHERE OrderDate BETWEEN @BaslangicTarihi AND @BitisTarihi AND DATEDIFF(DAY, OrderDate, ShippedDate) > 0;


SELECT *  FROM dbo.GecikenSiparisler('1998-01-01', '1999-04-01');

SELECT * FROM Orders



-- Alınan şehir bilgisine göre o şehirdeki müşterilerin bana ne kadar kazandırdıklarını bulan fonksiyonu yazın.
ALTER FUNCTION dbo.KazancBySehir(@Sehir NVARCHAR(100))
RETURNS int
AS
BEGIN
    DECLARE @ToplamKazanc int;

    SELECT @ToplamKazanc = SUM(od.Quantity * od.UnitPrice*(1-Discount))
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE c.City = @Sehir;

    RETURN @ToplamKazanc
END;


SELECT dbo.KazancBySehir('Lyon');

select * from Orders


-- OrderId bilgisi alınan siparişin hangi kargo ile taşındığını bulalım(firma adı)
ALTER FUNCTION dbo.KargoFirmasiByOrderID (@OrderID INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @KargoFirmasi NVARCHAR(100);

    -- OrderID'ye göre kargo firmasını buluyoruz
    SELECT @KargoFirmasi = s.CompanyName
    FROM Orders o
    JOIN Shippers s ON o.ShipVia = s.ShipperID 
    WHERE o.OrderID = @OrderID;

    RETURN @KargoFirmasi;
END;

SELECT dbo.KargoFirmasiByOrderID(10248);

SELECT * FROM Orders


-- Müşteri id ve Tutar bilgisi alan ve ilgili müşterinin bugüne kadar ödediği toplam kargo ücretini parametredeki tutar bilgisinden fazlaysa "Altın Müşteri" değilse "Normal Müşteri" bilgisini paylaşan fonksiyonu yazın.

create function MusteriTur(@MusteriId nvarchar(5), @Tutar money)
returns nvarchar(100)
as
begin
declare @Result int
select @Result=sum(Freight) from Orders
where CustomerID=@MusteriId

if @Result>@Tutar return 'Altın Müşteri'
return 'Normal Müşter,'
end

select CompanyName, dbo.MusteriTur(CustomerID,2000) from Customers


-- ÖDEV

-- SORU1: alınan OrderId bilgisine göre o orderin id, içinde kaç kolon ürün olduğunu ve ne kadar tuttuğunu bulan fonks.

ALTER FUNCTION GetOrderDetails(@OrderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT o.OrderID, COUNT(od.ProductID) AS ProductCount, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Tutar
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.OrderID = @OrderId
    GROUP BY o.OrderID
);


SELECT * FROM GetOrderDetails(10248);


/*
Müşterinin adını alarak 1. ve 3. harflerini büyük harfe çeviren +
city bilgisinin ilk iki harfini küçültüp ekleyen +
iletişimde bulunduğu kişinin ismini ters çeviren ve o tabloya özel bir barkod oluşturup dönen fonksiyonu yazın
*/


alter FUNCTION GetCustomerInfo(@CustomerName NVARCHAR(100), @City NVARCHAR(100), @ContactName NVARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        UPPER(SUBSTRING(@CustomerName, 1, 1)) +                 -- 1. harf büyük
        LOWER(SUBSTRING(@CustomerName, 2, 1)) +                 -- 2. harf küçük
        UPPER(SUBSTRING(@CustomerName, 3, 1)) +                 -- 3. harf büyük
        LOWER(SUBSTRING(@CustomerName, 4, LEN(@CustomerName) - 3)) AS FormatliCustomerAdı,

		--UPPER(SUBSTRING(@CustomerName, 1, 1)) + LOWER(SUBSTRING(@CustomerName, 2, LEN(@CustomerName) - 1)) AS FormatliCustomerAdı,
        LOWER(SUBSTRING(@City, 1, 2)) + UPPER(SUBSTRING(@City, 3, LEN(@City) - 2)) AS FormatliCity,
        REVERSE(@ContactName) AS TersIletisimAdi,
        CONCAT(UPPER(LEFT(@CustomerName, 1)), LEFT(@City, 2), REVERSE(@ContactName)) AS Barcode
);

SELECT * FROM GetCustomerInfo('John Doe', 'New York', 'Jane Smith');




