USE BITIRME_PROJESI_SQL
GO

				-- Temel Sorgular

USE BITIRME_PROJESI
GO

-- En çok sipariþ veren 5 müþteri

SELECT TOP 5 
    M.id,
    M.ad,
    M.soyad,
    COUNT(S.id) AS toplam_siparis_sayisi
FROM Musteri M
INNER JOIN Siparis S ON M.id = S.musteri_id
GROUP BY M.id, M.ad, M.soyad
ORDER BY COUNT(S.id) DESC;

--En çok satýlan ürünler

SELECT TOP 5
    U.ad AS urun_adi,
    SUM(SD.adet) AS toplam_satis
FROM Urun U
INNER JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY U.ad
ORDER BY SUM(SD.adet) DESC;

-- En yüksek cirosu olan satýcýlar

SELECT TOP 5
    S.ad AS satici_adi,
    SUM(SD.adet * SD.fiyat) AS toplam_ciro
FROM Satici S
INNER JOIN Urun U ON S.id = U.satici_id
INNER JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY S.ad
ORDER BY SUM(SD.adet * SD.fiyat) DESC;


			--Aggregate & Group By

-- Þehirlere göre müþteri sayýsý

SELECT 
	M.sehir AS sehirler,
	COUNT(M.id) AS sehirlere_göre_müsteri
FROM Musteri M
GROUP BY M.sehir
ORDER BY COUNT(M.id) DESC;

-- Kategori bazlý toplam satýþlar

SELECT 
    K.ad AS kategori_adi,
    SUM(SD.adet * SD.fiyat) AS kategori_toplam_satis
FROM Kategori K
INNER JOIN Urun U ON K.id = U.kategori_id
INNER JOIN Siparis_Detay SD ON U.id = SD.urun_id
GROUP BY K.ad
ORDER BY SUM(SD.adet * SD.fiyat) DESC;

-- Aylara göre sipariþ sayýsý

SELECT FORMAT(s.tarih, 'yyyy-MM') AS yil_ay,
       COUNT(*) AS siparis_sayisi
FROM dbo.Siparis s
GROUP BY FORMAT(s.tarih, 'yyyy-MM')
ORDER BY yil_ay;


			-- JOIN’ler

--Sipariþlerde müþteri bilgisi + ürün bilgisi + satýcý bilgisi

SELECT 
	M.ad AS	müsteri_ad,
	M.soyad AS müsteri_soyad,
	M.email AS müsteri_email,
	S.id AS siparis_no,
	SD.adet AS siparis_adedi,
    S.tarih AS siparis_tarihi,
	U.ad AS ürün_ad,
	U.fiyat AS ürün_fiyat,
	U.stok AS ürün_stok,
	ST.ad AS satici_ad,
	ST.adres AS satici_adres
FROM Siparis S
INNER JOIN Siparis_Detay SD ON SD.siparis_id=S.id
INNER JOIN Urun U ON U.id= SD.urun_id
INNER JOIN Satici ST ON ST.id=U.satici_id
INNER JOIN Musteri M ON M.id=S.musteri_id
ORDER BY S.id, SD.id

-- Hiç satýlmamýþ ürünler

SELECT 
	U.ad AS urun_adi,
    K.ad AS kategori,
    ST.ad AS satici,
    U.fiyat,
    U.stok
FROM Urun U 
LEFT JOIN Siparis_Detay SD ON SD.urun_id=U.id
LEFT JOIN Satici ST ON ST.id=U.satici_id
LEFT JOIN Kategori K ON K.id=U.kategori_id
WHERE SD.urun_id IS NULL
ORDER BY K.ad, U.ad

-- Hiç sipariþ vermemiþ müþteriler

SELECT 
	M.id AS müsteri_id,
	M.ad AS müsteri_ad,
	M.soyad AS müsteri_soyad,
	M.sehir AS müsteri_sehir,
	M.kayit_tarihi AS müsteri_kayit_tarihi
FROM Musteri M
LEFT JOIN Siparis S ON M.id=S.musteri_id
WHERE S.musteri_id IS NULL
ORDER BY  M.kayit_tarihi DESC


			-- Ýleri Seviye Görevler (Opsiyonel)


-- En çok kazanç saðlayan ilk 3 kategori.
SELECT TOP 3
    k.id, k.ad AS kategori,
    SUM(sd.adet * sd.fiyat) AS ciro
FROM dbo.Siparis_Detay sd
JOIN dbo.Urun u ON u.id = sd.urun_id
JOIN dbo.Kategori k ON k.id = u.kategori_id
GROUP BY k.id, k.ad
ORDER BY ciro DESC;


-- Ortalama sipariþ tutarýný geçen sipariþleri bul.
SELECT s.id, s.tarih, s.toplam_tutar
FROM dbo.Siparis s
WHERE s.toplam_tutar > (SELECT AVG(toplam_tutar) FROM dbo.Siparis);


-- En az bir kez elektronik ürün satýn alan müþteriler.
SELECT DISTINCT m.id, m.ad, m.soyad, m.email
FROM dbo.Musteri m
JOIN dbo.Siparis s ON s.musteri_id = m.id
JOIN dbo.Siparis_Detay sd ON sd.siparis_id = s.id
JOIN dbo.Urun u ON u.id = sd.urun_id
JOIN dbo.Kategori k ON k.id = u.kategori_id
WHERE k.ad = N'Elektronik'
ORDER BY m.ad, m.soyad;

