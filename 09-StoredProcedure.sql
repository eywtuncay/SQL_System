

/*

------ STORED PROCEDURE (SP) ------
- Saklı yöntem/yordam anlamında kullanılır.
- Belrli bir işi, görevi yerine getirmek için yazılmış bir veya daha fazla sorguyu birleştiren kod parçasıdır.
- Kısaca da derlenmiş sql cümleleridir diyebiliriz.
- Normalde her sorgu yazılıp okunduğunda önce derlenir sonra çalışır anca sp'ler zaten kayıtlı kayıtlı sorgular olduğundan execute planları zaten bir kez hazırlanmıştır ve doğrudan çalışır. O yüzden kayıtlı sql cümleleridir denir.
- Bu yüzden normal sorgulardan daha hızlı çalışır.
 -Veritabanı nesneleri olduğundan DDL ile üzerinde işlem yapılır ve ayrıca içinde de DHL ile işlemler yaptırılır.
- İsterse geriye değer dönebilir/dönmeyebilir.
- Subquery içinde kullanılmazlar. Kendileri başlı başlına iş yapar.
- Güvenliği yüksektir.
- Birbirleri içinde çağrılabilir.
- İçinde transaction kullanılabilir. (Fonksiyon kullanılmaz)
- Parametreleri opsiyoneldir
- Out parametresi vardır.

syntax;

create procedure/proc İsim
as
-Çalışacak Kodlar

çağrı: execute/exe isim


*/



-- Soru1: Ürün güncelleyebilen bir sp yazınız. ÜrünId, KategoriId, Fiyat bilgilerini alsın.

create proc UrunumuGuncelle(@UrunAd nvarchar(60), @KategoriId int, @Fiyat money, @UrunId int)
as UPDATE Products set ProductName = @UrunAd, CategoryID = @KategoriId, UnitPrice = @Fiyat where ProductID = @UrunId


exec UrunumuGuncelle 'patatoes', 4, 200, 78

select * from Products order by ProductID desc



-- Soru2: Yeni bir ürün ekleyelim, KategoriId ile beraber ancak bende böyle bir kategori varsa eklesin ürünü yoksa eklemesin. -print(eklenemedi)

alter proc UrunEkle (@ProductName nvarchar(50), @SuplirId int, @KategoriId int, @Quantity nvarchar(100), @UnitPrice int, @UnitStock int, @UnitOrder int, @ReorderLevel int, @Discontinued int)
as if exists(select 1 from Categories where CategoryID = @KategoriId)
insert Products ( ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued) 
values ( @ProductName,@SuplirId,@KategoriId,@Quantity,@UnitPrice, @UnitStock,@UnitOrder,@ReorderLevel,@Discontinued  )
else print 'Ürün Eklenemedi'

exec UrunEkle  'xxx', 12, 4123, 'asdas', 200, 0,0,0,0


-- Soru2: Yeni bir ürün ekleyelim, KategoriId ile beraber ancak bende böyle bir kategori varsa eklesin ürünü yoksa eklemesin. -print(eklenemedi)
-- Soru2 güncelleme: Kategori yoksa önce kategoriyi eklesin. Sonra ürünü o kategoriye eklesin - Tekrar bak

create proc UrunEkle2 (@KategoriAdi nvarchar(50), @Discontinued int @Name nvarchar(100)
as
declare @KategoriId int
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = @KategoriAdi)
INSERT Categories (CategoryName) VALUES (@KategoriAdi); 
select @KategoriId = CategoryID from Categories where CategoryName=@KategoriAdi
insert Products(ProductName, Discontinued, CategoryID) values (@KategoriAdi, @Discontinued, @KategoriId)



--- OUT PARAMETRESİ ---
-- Soru: Yeni bir kargo firması ekleyerek eklenen kargo firmasının id bilgisini out ile dışarı çıkartınız.

alter proc KargoFirmaEkle(@FirmaAd nvarchar(40), @FirmaId int out)
as
insert Shippers(CompanyName) values(@FirmaAd)
set @FirmaId = @@IDENTITY	--en son eklenen kişinin id'sini bizimle paylaşıyor.
--set @FirmaId = SCOPE_IDENTITY()


--Çağıralım
declare @KargoId int
exec KargoFirmaEkle 'Kargo2', @KargoId output

select @KargoId

--alternatif
--exec KargoFirmaEkle 'Kargo2', @FirmaId=@KargoId output
--select @KargoId


select * from Shippers




--Soru: Maksimum 10 karakterlik bir parametre alan ve isminde bu ifade geçen tüm çalışanlarımın ad ve soyad bilgisini getiren bir sp yazın.


create PROCEDURE AdSoyadGetir(@Parametre NVARCHAR(10))
AS
BEGIN
    SELECT FirstName, LastName FROM Employees  WHERE FirstName LIKE '%' + @Parametre + '%';
END

EXEC AdSoyadGetir @Parametre = 'a';


select * from Employees



-- Soru: Customers tablosuna ekleme yapalım, yeni bir müşteri ekleyelim ancak içerde ABC isminde bir firma varsa ben ABc ya da abC yi ve kombinasyonlarını ekleyemeyim.

alter proc MüsteriEkle(@CompanyName nvarchar(40))
as
IF NOT EXISTS (SELECT 1 FROM Customers WHERE UPPER(CustomerID) = UPPER(@CompanyName))
insert Customers(CustomerID, CompanyName) values(UPPER(LEFT(@CompanyName, 5)), @CompanyName)
ELSE PRINT 'Aynı isimde bir müşteri zaten mevcut.';


exec MüsteriEkle 'ALfKasdI'

select * from Customers



-- Soru: Aldığı yıl bilgisine göre o yıldaki ciromu/kazancımı bulan sp yazalım.

alter PROCEDURE YillikCiroHesapla(@Yil INT)   
AS
    SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS ToplamCiro
    FROM Orders o
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = @Yil
END


exec YillikCiroHesapla 1969

select * from Orders



/*

Ardışık yapılan işlemlerde bir hata meydana geldiğinde yapılan tüm işlemleri geri almamızı,
ya da işlemleri tamamlamamızı sağlayan TRANSACTION yapısı mevcuttur.

C# tarafında benzer işi transactionscope yapacak. Buradaki transaction içindeki;
Comit: İşlem tamam başaralılı. derken,
Rollback: Hata oluştu yaptıklarımızı geri al. Der.

Transaction yapısı genelde try-catch yapısıyla desteklenir ki,
bilinmeyen x sebepten hata alırsanız işlem havada kalmasın ve geri alınsın.

*/



/*

Soru: yeni bir sipariş geldiğinde ilgili ürünün kendi stoğunu da azaltalım ancak,
ürün yoksa ya da ürünün kendi stoğu negatif olduysa yaptığımız işlemleri geri alarak hiçbirşey yapmamış olalım.
(Order eklememiş olalım mesela)

*/
select * from Orders

create proc SiparisOlustur(@UrunId int, @SiparisAdet int, @calisanId int, @MusteriId nvarchar(5))
as
begin transaction
begin try
declare @OrderId int
declare @GuncelStok int

--Sipariş Oluşturalım
insert Orders(EmployeeID, CustomerID, ShipCity) values (@calisanId, @MusteriId, 'Ankara')
set @OrderId = @@IDENTITY

--Ürün var mı?
if exists (select 1 from Products where ProductID=@UrunId)
begin
print 'Böyle bir ürün olmadığından siparişiniz iptal edildi'
rollback
return
end

--Order Detail'e ürünü ekleyelim
insert into [Order Details] (ProductID, Quantity, UnitPrice, OrderID, Discount) values (@UrunId, @SiparisAdet, 200, @OrderId, 0)

--Ürün stok azaltalım
update Products set UnitsInStock=UnitsInStock-@SiparisAdet where ProductID=@UrunId
select @GuncelStok=UnitsInStock from Products where ProductID=@UrunId
--Stok negatif mi?
if(@GuncelStok<0)
begin
print 'stok miktarınız yeterli olmadığından siparişiniz iptal edildi '
rollback
return
end

print 'siparişiniz alınmıştır, teşekkür ederiz.'
commit --Transaction tamamlandı.
end try

begin catch
print 'Hata oluştu, tüm işlemler iptal edildi.'
rollback
return
end catch


exec SiparisOlustur 2, 10, 3, 'ALFKI'

select * from Products
select * from Orders




/*
çalışan + müşteri kontrolü de ekle

*/

create proc SiparisOlustur2(@UrunId int, @SiparisAdet int, @calisanId int, @MusteriId nvarchar(5))
as
begin transaction
begin try
declare @OrderId int
declare @GuncelStok int

--Sipariş Oluşturalım
insert Orders(EmployeeID, CustomerID, ShipCity) values (@calisanId, @MusteriId, 'Ankara')
set @OrderId = @@IDENTITY

--Ürün var mı?
if exists (select 1 from Products where ProductID=@UrunId)
begin
print 'Böyle bir ürün olmadığından siparişiniz iptal edildi'
--NOT: products üzerinde constraint var ve direkt catch'e düşüyoruz.
rollback
return
end

--Çalışan var mı
if not exists (select 1 from Employees where EmployeeID=@calisanId)
begin
print 'Böyle bir çalışan yok'
rollback
return
end

--Müşteri var mı
if not exists (select 1 from Customers where CustomerID=@MusteriId)
begin
print 'Böyle bir müşteri yok'
rollback
return
end


--Order Detail'e ürünü ekleyelim
insert into [Order Details] (ProductID, Quantity, UnitPrice, OrderID, Discount) values (@UrunId, @SiparisAdet, 200, @OrderId, 0)

--Ürün stok azaltalım
update Products set UnitsInStock=UnitsInStock-@SiparisAdet where ProductID=@UrunId
select @GuncelStok=UnitsInStock from Products where ProductID=@UrunId
--Stok negatif mi?
if(@GuncelStok<0)
begin
print 'Stok miktarınız yeterli olmadığından siparişiniz iptal edildi '
rollback
return
end

print 'Siparişiniz alınmıştır, teşekkür ederiz.'
commit --Transaction tamamlandı.
end try

begin catch
print 'Hata oluştu, tüm işlemler iptal edildi.'
rollback
return
end catch


