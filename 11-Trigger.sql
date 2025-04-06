
/*

---- TRİGGER ----

- Triggerlar otomatik olarak çalışan sp'lerdir
- Otomatik tetiklenirler.
- Bir tablo üzerinde insert, update, delete yaptığımızda devreye girmesini istediğimiz işlemleri sırasıyla triggerlara yazarız.
- Veritabanı nesnesidir ve DDL komutları ile oluşur
- Otomatik işlemlerde bize yardımcı olmak amacıyla INSERTED ve DELETED adında iki sanal tablo bulunur, eklenen ve silinenleri buradan takip ederiz. UPDATE yoktur, gerek de yoktur.
- Üç çeşit triggerdan bahsedebiliriz
	- DML Trigger: insert, update, delete
	- DDL Trigger: create, alter, drop
	- LOGON Triger

-- DML Triggerlar: After(for) ve Instead of olmak üzere ikiye ayrılır.

*/


-- Soru: Çalışan tablosuna yeni bir çalışan ekledikten sonra sgk'ya bildirdiniz mi yazısını yazalım.
create trigger trg_CalisanEklediktenSonra
on Employees
after insert
as
print 'Çalışanı sgk ya bildirdiniz mi?'

insert into Employees (FirstName, LastName) values ('Mutlu','Kutlu')


-- Soru: Sipariş verdiğimde siparişlerimdeki product quantity kadar, product'ın kendi stoğundan düşsün. 
create trigger trg_stokMiktariniAzalt
on [Order Details]
after insert
as
declare @SatilanUrunId int, @SatilanAdet int
select @SatilanUrunId=ProductID, @SatilanAdet=Quantity from inserted
update Products set UnitsInStock -= @SatilanAdet where ProductID=@SatilanUrunId


select * from [Order Details]
insert into [Order Details] values (10248, 1, 10, 2, 0)

select * from Products



-- Order Details tablosunda yapılan güncelleme sonucunda product'ın stok bilgisini güncelleyen trigger'ı yazınız.  - TEKRAR YAZ
alter TRIGGER UpdateProductStock
ON [Order Details]
AFTER UPDATE
AS
    UPDATE p SET p.UnitsInStock = p.UnitsInStock - (i.Quantity - d.Quantity)
    FROM Products p JOIN inserted i ON p.ProductID = i.ProductID JOIN deleted d ON i.OrderID = d.OrderID AND i.ProductID = d.ProductID;

UPDATE [Order Details] SET Quantity = 50
WHERE OrderID = 1048 AND ProductID = 2;


select * from [Order Details]
select ProductID, UnitsInStock from Products


-- İnsert, Update, Delete işlemleri için ortak bir trigger yazalım. Duruma göre oluşturuldu, gğncellendi, silindi çıktılarını versin.
create trigger trg_Karisik
on [Order Details] 
after insert, update, delete
as
if exists (select * from inserted) and exists(select * from deleted)
print 'update'
if exists (select * from inserted) and exists(select * from deleted)
print 'insert'
if exists (select * from deleted) and exists(select * from inserted)
print 'deleted'


-- Bir view silindikten sonra çıktı verelim
create trigger trg_ViewSilinistir
on database
after drop_view
as
print 'view silindi'

