
/*

---- VİEW ----

Bir veya birden fazla tablodan seçili alanları sanal tablo gibi görüntülenmesini sağlar.

Amacımız:
Karmaşık sorguları birleştirmek,
veriyi tekrar tekrar kullanılabilir hale getirmek,
Sorgu tekrarını önlemek
Yetkili/yetkisiz kişilere kaynakları açık açık paylaşmadan bilgi vermek

- Viewlar'da birer database nesnesidir. DDL komutları onlar üzerinde de çalışır.
- Tek tablo üzerinde insert, update, delete yapabilirler ancak daha fazlasını yapamazlar.
- Dışarıdan parametre almazlar.
- Özellikle raporlama ve güvenlik için kullanılır.
- No column name bırakılmamalıdır.

*/

-- Soru: OrderDetails tablosundaki kolonları ve her satırdaki toplam tutarı gösteriniz.
create view vw_ToplamTutar
as
select OrderID, ProductID, UnitPrice, Discount, (UnitPrice*Quantity*(1-Discount)) as ToplamTutar
from [Order Details]

select * from dbo.vw_ToplamTutar
select OrderID, ToplamTutar from dbo.vw_ToplamTutar



-- Soru: Ürün adı, Kategori adı ve Tedarikçi adı getiren bir view yazınız.
CREATE VIEW vw_UrunKategoriTedarikciGorunumu AS
SELECT p.ProductName AS UrunAdi, c.CategoryName AS KategoriAdi, s.CompanyName AS TedarikciAdi
FROM Products p JOIN Categories c ON p.CategoryID = c.CategoryID JOIN Suppliers s ON p.SupplierID = s.SupplierID;

select * from dbo.vw_UrunKategoriTedarikciGorunumu

-- Gizli-Kilitli Şekilde View: Ürün adı, Kategori adı ve Tedarikçi adı getiren bir view yazınız.
CREATE VIEW vw_UrunKategoriTedarikciGorunumu2 AS
with encryption		--Gizli çekmek için kullanılır
as
SELECT p.ProductName AS UrunAdi, c.CategoryName AS KategoriAdi, s.CompanyName AS TedarikciAdi
FROM Products p JOIN Categories c ON p.CategoryID = c.CategoryID JOIN Suppliers s ON p.SupplierID = s.SupplierID;



-- Soru: Yıllara göre her yılın ilk 3 ayında ne kadar kazandığımı bulan view yazınız.
CREATE VIEW vw_IlkUcAyToplamKazanci AS
SELECT YEAR(o.OrderDate) AS Yil, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS ToplamKazanc
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) IN (1, 2, 3)  -- İlk üç ay
GROUP BY YEAR(o.OrderDate);

select * from dbo.vw_IlkUcAyToplamKazanci

