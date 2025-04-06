
-- Yorum Satırı

/*

VERİ TİPLERİ

Unicode : Unicode, dünya çapındaki tüm yazılı dilleri ve sembollerini, matematiksel işaretlerden özel sembollere kadar, tek bir sistemde temsil etmeyi amaçlar.
n ile başlayanlar unicode destekler.

Sonuna noktalı virgül koysan da çalışır koymasan da


------ METİNSEL VERİ TİPLERİ ------

char(n) --> n karakter sayısını belirtir. Unicode desteklemez. 8 bin karaktere kadar destekler.
belirtilenden yani n'den az sayıda harf kullansam da n'de belirtilen kadar yer kaplar (katı).


nchar --> n karakter sayısını belirtir. Unicode destekler. 4 bin karakter destekler. n kadar yer kaplar.

varchar(n) --> Unicode desteklemez. 8 bin karaktere kadar destekler. n'den az karakter kullanılırsa kullanılan kadar yer kaplar.

nvarcahar(n) --> Unicode destekler. 4 bin karaktere kadar destekler. n'den az karakter kullanılırsa kullanılan kadar yer kaplar. En sık kullanılan.

text --> Unicode desteklemez. 8 bin karakterden fazlası için. Katı.
ntext --> Unicode destekler. 8 bin karakterden fazlasını destekler. Katı değil.




------ SAYISAL VERİ TİPLERİ ------

tinyint	--> 0-255 arasındaki değerleri tutar. 1 byte
smallint --> -32.768 - +32.768 arasındaki değerleri tutar. 2 byte
int	--> - 2 milyar ile + 2 milyar arasındaki değerleri tutar. 4 byte
bigint --> -2 üssü 63 ile +2 üssü 63 arasındaki değerleri tutar. 8 byte

bit	--> True/False tutar. 0/1 (bool veri tipini hatırlatıyor)


--- Ondalıklı Sayı Tipleri ---

decimal --> hassas verilerde kullanılır. (x,y) x toplam sayısını. y ondalıklı basanak sayısını ifade eder. 38 basamağa kadar destekler.
float --> 


--- Parasal Veri Tipleri ---

smallmoney --> -214 bin ile +214 bin arasındaki değerleri tutar.
defaul da virgülden sonra 4 karakter hazırlar.

money --> -2 üssü 64 ile +2 üssü 64 arasındaki değerleri tutar



--- Tarihsel Veri Tipleri ---

date --> yıl-gün-ay formatında veri tutar.
datetime --> tarih ve zaman tutar. yıl-ay-gün-saat-dakika-saniye formatında saklar
time --> sadece saat-dakika-saniye tutar.

*/



/*

DML --> DATA MANUPULATION LANGUAGE --> Veri Tanımlama Dili

insert - insert into --> veri eklemek için kullanılır
update --> veriyi güncellemek için kullanılır.
delete --> veriyi silmek için kullanılır.
select --> verileri seçmek için kullanılır. (DQL: Data Query Language başlığı altında da olabilr.)


DDL --> DATA DEFINITION LANGUAGE

Create --> veritabanı nesnesi oluşturmak için (table, sq, function....)
Alter --> veritabanı nesnesini güncellerken kullanılır.
Drop --> mevcuttaki bir nesneyi silmek için kullanılır.
Truncate --> mevcuttaki tablonun içini boşaltır. (tabloyu silmez)

*/



/*
	Soru: Bir Bilgeadam db oluşturunuz. içerisine öğrenciler tablosunu oluşturunuz.
	her öğrencinin ad, soyad, mail, doğum tarihi, cinsiyet bilgisi olsun.
	id bilgisi 100'den başlasın.
	cinsiyet bilgisi tek karakter tutulsun (e/k)
*/

--create database Bilgeadam;

create database [Bilge Adam Teknoloji];	-- Boşluklu isim vermek istiyorsan [] kullanmalısın.

create table Personeller
(
ID int primary key identity(100, 1),
Ad nvarchar(40) not null,
Soyad nvarchar(50),
Mail nvarchar(60) not null,
[Dogum Tarihi] date null,
Cinsiyet char(1) check(Cinsiyet='e' or Cinsiyet = 'k')
)

insert Personeller (Soyad, Ad, Mail, Cinsiyet) values
('Albayrak', 'Tuncay', 'tuncay@outllok.com', 'e')

--insert Personeller (Soyad, Ad, Mail, Cinsiyet) values
--('Albayrak', 'Tuncay', 'tuncay@outllok.com', 'a')		-- hata verir 'a' cinsiyeti yüzünden.


--insert Personeller (Mail) values ()


---------
-----------------------------------------------------------------------------------

create database Satis;

create table Kategoriler
(
ID int primary key identity(1,1),
Aciklama nvarchar(200) null,
Ad nvarchar(40) not null,
[Olusturma Tarihi] date null
)

create table Urunler
(
Id int primary key identity(1,1),
Ad nvarchar(50) not null,
Fiyat money not null,
Stok int not null,
IndirimVarMi bit not null,
KategoriId int not null,
constraint fk_kategori foreign key(KategoriId) references Kategoriler(ID)
)



create database Dershane;

create table Kurs
(
	Id int primary key identity(1,1),
	Ad nvarchar(50) not null,
	Kontenjan int not null
)

create table Ogrenci
(
	Id int primary key identity(1,1),
	Ad nvarchar(50) not null,
	Soyad nvarchar(40) not null
)

create table KursOgrenci
(
	KursId int,		--not null olacağı belli diye tekrar yazmadım.
	OgrenciId int,
	constraint fk_Kurs foreign key(KursId) references Ogrenci(id),
	constraint fk_Ogrenci foreign key(OgrenciId) references kurs(id)
)



/*

üye - kitap - yazar arasında bir ilişki bulunmaktadır.
Üye bir kitabı ödünç alabilir, bir kitap farklı üyelerce ödünç alınabilir.
Bir kitabın birden fazla yazarı olabilir ve tabiki bir yazar birden fazla kitap yazmış olabilir.

Kitap: id, ad, sayfa sayısı, fiyat, önsöz, basımevi, ısbno bilgilerine sahiptir.
fiyat 500'den büyük olmalıdır.
basımevini boş geçmek isteyenler olabilir ancak geçildiğinde default lütfen bilgi giriniz yazmalıdır.

Yazar: id, ad, soyad, mail, tc, doğum tarihi alanları olmalıdır.
mail ve tc eşsizdir.
tc boş geçilemez, mail boş geçilebilir.
yazar 18 yaşından büyük olmalıdır.

Üye: id, username, kayit tarihi, tc, mail bilgileri olmalıdır.
tc boş olamaz ve 11 karakter olmak zorundadır. eşsizdir.
username eşsizdir ve boş olamaz.
mail eşsiz ve mail formatında olmalıdır.
kayıt tarihi ileri bir tarih olamaz.

*/

create database Kütüphane;

create table Kitaplar
(
	Id int primary key identity(1,1),
	Ad nvarchar(50) not null,
	SayfaSayisi int not null,
	Fiyat money not null check(Fiyat>500),
	Onsöz ntext null,
	BasimEvi nvarchar(60) default 'Lütfen Bilgi Giriniz',
	Isbno nvarchar(14) null check(len(Isbno)=11 OR len(Isbno)=14),
)

create table Yazarlar
(
	Id int primary key identity(1,1),
	Ad nvarchar(30) not null,
	Soyad nvarchar(30) not null,
	Mail nvarchar(255) null unique check(charindex('@',Mail,0)>0 and charindex('.',Mail,0)>0),
	Tc nvarchar(11) unique not null check(len(Tc)=11),
	DogumTarihi date check(datediff(year, DogumTarihi,getdate()) > 18 ),
)

create table KitapYazar
(
	KitapId int,
	YazarId int,
	primary key(KitapId, YazarId),
	constraint fk_kitap foreign key(KitapId) references Kitaplar(Id),
	constraint fk_yazar foreign key(YazarId) references Yazarlar(Id),

)



create table Uyeler
(
	Id int primary key identity(1,1),
	Username nvarchar(30) unique not null,
	Tc nvarchar(11) unique not null check(len(Tc)=11),
	Mail nvarchar(255) null unique check(charindex('@',Mail,0)>0 and charindex('.',Mail,0)>0),
	KayitTarihi date not null check(KayitTarihi<getdate()),
	kitapId int,
	constraint fk_uyeler foreign key(KitapId) references Kitaplar(Id)
)

drop table Uyeler
