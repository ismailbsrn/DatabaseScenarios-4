SELECT 
    'Kaynak' as veri_asamasi,
    COUNT(*) as toplam_satir_sayisi,
    SUM(CASE WHEN email IS NULL OR email NOT LIKE '%@%' THEN 1 ELSE 0 END) as gecersiz_eposta_sayisi,
    SUM(CASE WHEN status NOT IN ('ACTIVE', 'INACTIVE', 'PENDING') THEN 1 ELSE 0 END) as standart_disi_statu_sayisi
FROM source_data.customers
UNION ALL
SELECT 
    'Temizlenmiş Veri' as veri_asamasi,
    COUNT(*) as toplam_satir_sayisi,
    SUM(CASE WHEN email IS NULL OR email NOT LIKE '%@%' THEN 1 ELSE 0 END) as gecersiz_eposta_sayisi,
    SUM(CASE WHEN status NOT IN ('ACTIVE', 'INACTIVE', 'PENDING') THEN 1 ELSE 0 END) as standart_disi_statu_sayisi
FROM dest_db.customers;
