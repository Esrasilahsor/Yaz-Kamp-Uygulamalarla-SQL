CREATE DATABASE BITIRME_PROJESI

USE BITIRME_PROJESI
GO

-- Tablolar

CREATE TABLE Musteri (
	id INT IDENTITY(1,1) PRIMARY KEY,
	ad NVARCHAR(50) NOT NULL,
	soyad NVARCHAR(50) NOT NULL,
	email NVARCHAR(50),
	sehir NVARCHAR(50),
	kayit_tarihi DATE,
);

CREATE TABLE Kategori(
	id INT IDENTITY(1,1) PRIMARY KEY,
	ad NVARCHAR(50) NOT NULL,
);

CREATE TABLE Satici (
	id INT IDENTITY(1,1) PRIMARY KEY,
	ad NVARCHAR(50) NOT NULL,
	adres NVARCHAR(100) NOT NULL,
);

CREATE TABLE Urun(
	id INT IDENTITY(1,1) PRIMARY KEY,
	ad NVARCHAR(50) NOT NULL,
	fiyat INT NOT NULL CHECK (fiyat>0),
	stok INT NOT NULL CHECK (stok >0),
	kategori_id INT NOT NULL,
	FOREIGN KEY (kategori_id) REFERENCES Kategori(id),
	satici_id INT NOT NULL,
	FOREIGN KEY (satici_id) REFERENCES Satici(id)
);


CREATE TABLE Siparis(
	id INT IDENTITY(1,1) PRIMARY KEY,
	musteri_id INT NOT NULL,
	FOREIGN KEY (musteri_id) REFERENCES Musteri(id),
	tarih DATE NOT NULL DEFAULT GETDATE(),
	toplam_tutar INT NOT NULL CHECK (toplam_tutar >= 0),
	odeme_turu NVARCHAR(50) NOT NULL,
);

CREATE TABLE Siparis_Detay(
	id INT IDENTITY(1,1) PRIMARY KEY,
	siparis_id INT NOT NULL,
	urun_id INT NOT NULL,
	adet INT NOT NULL CHECK (adet > 0),
	fiyat INT NOT NULL CHECK (fiyat > 0),
	FOREIGN KEY (siparis_id) REFERENCES Siparis(id),
	FOREIGN KEY (urun_id) REFERENCES Urun(id)
);


-- INSERT, UPDATE, DELETE, TRUNCATE kullan

UPDATE Musteri SET kayit_tarihi='2023-05-15' WHERE id=5
UPDATE Musteri SET sehir='Nevþehir' WHERE id=4
UPDATE Urun SET fiyat=369.99 WHERE id=6

DELETE Urun WHERE ad='Parfüm'

TRUNCATE TABLE Siparis_Detay

select * from Siparis_Detay 
-- Burada veriler etkilenmesin diye sipariþ detayý verilerini tekrar ekliyoruz.


-- Stok azaldýðýnda güncelleme sorgularý uygula


DECLARE @SatilanUrunId INT = 2; 
DECLARE @SatilanAdet INT = 1;

UPDATE Urun
SET stok = stok - @SatilanAdet
WHERE id = @SatilanUrunId;



DECLARE @SatilanUrunId INT = 12; 
DECLARE @SatilanAdet INT = 2;

UPDATE Urun
SET stok = stok - @SatilanAdet
WHERE id = @SatilanUrunId;



DECLARE @SatilanUrunId INT = 22; 
DECLARE @SatilanAdet INT = 1;

UPDATE Urun
SET stok = stok - @SatilanAdet
WHERE id = @SatilanUrunId;

