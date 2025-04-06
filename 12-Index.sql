
----- İNDEX -----


-- İndeks, bir kitapta konuların hangi sayfada olduğunu gösteren içindekiler kısmı gibi çalışır.

-- Sorgularda tabloyu baştan sona taramak yerine, indeks sayesinde veriye daha hızlı erişilir.

-- Ne zaman kullanılır?
-- WHERE, JOIN, ORDER BY, GROUP BY gibi sorgularda sıkça kullanılan sütunlara indeks eklenirse sorgular çok daha hızlı çalışır.

-- Örnek:
-- CREATE INDEX idx_users_email ON users(email);
-- Bu komut, users tablosundaki email sütununa bir indeks ekler.

-- Not:
-- İndeks performansı okuma işlemlerini hızlandırır, ancak yazma (INSERT, UPDATE, DELETE) işlemlerini biraz yavaşlatabilir çünkü indeks de güncellenmelidir.






create database FakeData


create table Kisi
(
	Id int primary key identity(1,1),
	Ad nvarchar not null,
	Soyad nvarchar not null,
	Telefon nvarchar not null,
)


declare @i int = 1
while @i<1000
begin
insert Kisi select Ad='İkbal' + cast(@i as nvarchar(30)),
Soyad='Cinek'+cast(@i as nvarchar(30)),
Telefon =+ cast(@i as nvarchar(30))
end

-- Defaultta zaten bir kolona identity pk dediğinde sistem onu cluster index kabul eder ama yinede yazmak istersem

create clustered index IndexAdCluster on Kisi(Id)



