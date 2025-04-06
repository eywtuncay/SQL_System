
create database hastane


create table Hastane
(
	HastaneId int primary key identity(1,1),
	Ad nvarchar(100) unique,
	Adres nvarchar(200) unique,
	Telefon nvarchar(15) unique check(len(Telefon)=11),
	Sehir nvarchar(15) check (Sehir = 'İstanbul' or Sehir = 'Ankara' or Sehir = 'İzmir'),
	Kapasite int check(kapasite > 0),
	KurulusYili int check (KurulusYili BETWEEN 1990 AND getdate())
)

insert Hastane(Ad, Adres, Telefon, Sehir, Kapasite, KurulusYili)
values ('Genel', 'Gebze', 11111111111, 'İstanbul', '10', 2000)


create table Uzmanlıklar
(
	UzmanlikId int primary key identity(1,1),
	Ad nvarchar(50) unique not null,
	Aciklama nvarchar(100) not null,
)
insert Uzmanlıklar(Ad, Aciklama)
values ('Genel Cerrahi', 'tüm sağlık işlemleri')



create table Doktor
(
	DoktorId int primary key identity(1,1),
	Ad nvarchar(50) unique not null,
	Soyad nvarchar(100) unique not null,
	DeneyimYili int check(DeneyimYili>0),
	Maas int check(Maas>7000),
	Email nvarchar(100) unique not null,

	HastaneId int not null,
	constraint fk_hastane foreign key(HastaneId) references Hastane(HastaneId),

	UzmanlikId int not null,
	constraint fk_uzmanlik foreign key(UzmanlikId) references Uzmanlıklar(UzmanlikId)

)
insert Doktor(Ad, Soyad, DeneyimYili, Maas, Email, HastaneId, UzmanlikId)
values ('Tuncay', 'Albayrak', 5, 9000, 'asda@outlook.com', 1, 1)



create table Hasta
(
	HastaID int primary key identity(1,1),
	Ad nvarchar(50) unique not null,
	Soyad nvarchar(100) unique not null,
	DogumTarihi datetime,
	Cinsiyet char(1) check(cinsiyet = 'e' or cinsiyet = 'k'),
	EvTelefonu nvarchar(10) default 'blrtlmedi',
	CepTelefonu nvarchar(11) not null,
	Email nvarchar(100) unique,
	SaglikSigortasi nvarchar(20) check(SaglikSigortasi='Yok' or SaglikSigortasi='Özel' or SaglikSigortasi='SGK'),

)
insert Hasta(Ad, Soyad, DogumTarihi, Cinsiyet, EvTelefonu, CepTelefonu, Email, SaglikSigortasi)
values ('Tuncay', 'Albayrak', 2001, 'e', 1111111111, 11111111111, 'deneme@deneme.com', 'Yok')



-- Hasta,Doktor ilşkisine birdaha bak
create table Randevu
(
	RandevuId int primary key identity(1,1),

	HastaId int not null,
	constraint fk_hasta foreign key(HastaId) references Hasta(HastaId),

	DoktorId int not null,
	constraint fk_doktor foreign key(DoktorId) references Doktor(DoktorId),

	--Tarih,Saat (hasta aynı saatte birden fazla randevu alamaz,aynı doktordan aynı saatte başka randevu alamaz).
	Ucret int check(Ucret>0),
	Durum nvarchar(10) not null check(Durum='Beklemede' or Durum='Ödendi' or Durum='İptal')
)
insert Randevu(HastaId, DoktorId, Ucret, Durum)
values (1, 1, 5000, 'Beklemede')



create table IlacKategori
(
	KategoriId int primary key identity(1,1),
	KategoriAdi nvarchar(20) unique not null,
)
insert IlacKategori(KategoriAdi)
values ('Kişisel Bakım')



create table Ilac
(
	IlacId int primary key identity(1,1),
	Ad nvarchar(15) not null,
	Fiyat int check(fiyat>0),
	UretimTarihi datetime check(getdate() < Uretimtarihi),
	RafOmru int check(RafOmru > 0 and RafOmru <= 12),

	KategoriId int not null,
	constraint fk_kategori foreign key(KategoriId) references IlacKategori(KategoriId)
)
insert Ilac( Ad, Fiyat, UretimTarihi, RafOmru, KategoriId)
values ('arveles', 50, 2024-01-01, 8, 1)




create table Recete
(
	--RandevuId --> HastaId ve DoktorId bilinmelidir.

	ReceteId int primary key identity(1,1),
	RandevuId int not null,
	constraint fk_randevu foreign key(RandevuId) references Randevu(RandevuId),

	OlusturmaTarihi datetime check(OlusturmaTarihi < getdate()),
	Aciklama nvarchar(20)
)
insert Recete(RandevuId, OlusturmaTarihi, Aciklama)
values (1, 2024-01-01, 'arveles')


--composit key 
create table ReceteDetay
(
	ReceteId int not null,
	constraint fk_recete foreign key(ReceteId) references Recete(ReceteId),

	IlacId int not null,
	constraint fk_ilac foreign key(IlacId) references Ilac(IlacId),

	Adet int check(Adet>0),
	GunlukDoz int check(GunlukDoz>0),
	KullanımAciklamasi nvarchar(100)
)
insert ReceteDetay(ReceteId, IlacId, Adet, GunlukDoz, KullanımAciklamasi)
values (1, 1, 10, 1, 'günde bir kez')

