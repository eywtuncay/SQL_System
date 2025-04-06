


-- Product table oluşturunuz
-- id, ad, fiyat, indirimiVarmi, stokMiktari
-- en az 5 veri ekleyiniz.


create database marketim

create table urunler
(
	Id int primary key identity(1,1),
	Ad nvarchar(30) not null,
	Fiyat money not null,
	IndirimVarMi bit,
	Stok int,
	KayitTarihi date
)


insert into urunler(Fiyat,IndirimVarMi,Stok,Ad,KayitTarihi)
values (230,0,23,'Eklma','03-03-2025')

insert into urunler(Fiyat,IndirimVarMi,Stok,Ad,KayitTarihi)
values (130,0,13,'Armut','05-02-2025')

insert into urunler(Fiyat,IndirimVarMi,Stok,Ad,KayitTarihi)
values (630,0,30,'Ayva','03-03-2025')

insert into urunler(Fiyat,IndirimVarMi,Stok,Ad,KayitTarihi)
values (1630,0,3,'Çanta','02-02-2025')


-- UPDATE
update urunler set Ad = 'Elma' where Id=1	-- id'si 1 olan ürünün adını Elma yap -- Eklma'dan Elma ya güncellendi.

update urunler set Stok = 2 where Id = 7	-- çantanın stoğunu 2 yaptım.

update urunler set Stok = 1, Fiyat = 2000 where Id = 7 -- çatanın stoğunu düşürüp fiyatını arttırdım. 


--DELETE
delete from urunler where Id<2 -- id'si 2 den küçük olanları sildim.


--TRUNCATE
truncate table urunler	-- ürünler tablosunu temizledim.



/*
	Not: koşulsuz Delete yazmak ile Truncate yazmak tablonun içini boşaltır ancak,
	Delete tablonun primary key'ini sıfırlamaz kaldığı yerden devam eder.
	Truncate de tablonun pk sıfırlanır.
*/


--ALTER
alter table urunler add Aciklama nvarchar(40);	--Ürünler tablosuna Aciklama kolonunu ekledim.


--Tüm ürünlerin fiyat bilgilerine %30 zam yap.
update urunler set Fiyat+=(fiyat*0.3)

--Açıklama kolonunun veri tipini değiştir. varchar(20) yap.
alter table urunler alter column Aciklama varchar(20);


--Açıklama kolonunu sil
alter table urunler drop column Aciklama;

