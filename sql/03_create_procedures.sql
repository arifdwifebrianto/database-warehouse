-- SUPPLIER
-- Create
CREATE PROCEDURE add_supplier (
    IN p_nama_supplier VARCHAR(100),
    IN p_kontak_person VARCHAR(100),
    IN p_telepon VARCHAR(20),
    IN p_alamat TEXT
)
BEGIN
    INSERT INTO Supplier (nama_supplier, kontak_person, telepon, alamat)
    VALUES (p_nama_supplier, p_kontak_person, p_telepon, p_alamat);
END

-- Read
CREATE PROCEDURE show_supplier(
    IN p_id_supplier INT
)
BEGIN
    SELECT * FROM Supplier WHERE id_supplier = p_id_supplier;
END;

CREATE PROCEDURE show_all_supplier()
BEGIN
    SELECT * FROM Supplier;
END;

-- Update
CREATE PROCEDURE update_supplier (
    IN p_id INT,
    IN p_nama VARCHAR(100),
    IN p_kontak VARCHAR(100),
    IN p_telepon VARCHAR(20),
    IN p_alamat TEXT
)
BEGIN
    UPDATE Supplier 
    SET 
        nama_supplier = p_nama, 
        kontak_person = p_kontak, 
        telepon = p_telepon, 
        alamat = p_alamat 
    WHERE id_supplier = p_id;
END

-- Delete
CREATE PROCEDURE delete_supplier (
    IN p_id INT
)
BEGIN
    DELETE FROM Supplier WHERE id_supplier = p_id;
END

-- PRODUK
-- Create
CREATE PROCEDURE add_produk (
    IN p_nama_produk VARCHAR(150),
    IN p_sku VARCHAR(50),
    IN p_deskripsi TEXT,
    IN p_berat DECIMAL(10, 2),
    IN p_satuan VARCHAR(10),
    IN p_harga_beli DECIMAL(10, 2),
    IN p_id_supplier INT
)
BEGIN
    INSERT INTO Produk (nama_produk, sku, deskripsi, berat, satuan, harga_beli, id_supplier)
    VALUES (p_nama_produk, p_sku, p_deskripsi, p_berat, p_satuan, p_harga_beli, p_id_supplier);
END;

-- Read
CREATE PROCEDURE show_produk (
    IN p_id INT
)
BEGIN
    SELECT 
        P.*, 
        S.nama_supplier 
    FROM 
        Produk P JOIN Supplier S ON P.id_supplier = S.id_supplier 
    WHERE 
        P.id_produk = p_id;
END

CREATE PROCEDURE show_all_produk ()
BEGIN
    SELECT * FROM Produk;
END;

-- Update
CREATE PROCEDURE update_produk (
    IN p_id INT,
    IN p_nama VARCHAR(150),
    IN p_sku VARCHAR(50),
    IN p_deskripsi TEXT,
    IN p_satuan VARCHAR(10),
    IN p_harga_beli DECIMAL(10, 2),
    IN p_id_supplier INT
)
BEGIN
    UPDATE Produk 
    SET 
        nama_produk = p_nama, 
        sku = p_sku, 
        deskripsi = p_deskripsi, 
        satuan = p_satuan, 
        harga_beli = p_harga_beli, 
        id_supplier = p_id_supplier
    WHERE id_produk = p_id;
END

-- Delete
CREATE PROCEDURE delete_produk (
    IN p_id INT
)
BEGIN
    DELETE FROM Produk WHERE id_produk = p_id;
END

-- LOKASI_GUDANG
-- Create
CREATE PROCEDURE add_lokasi_gudang (
    IN p_kode VARCHAR(20),
    IN p_kapasitas INT,
    IN p_tipe VARCHAR(50)
)
BEGIN
    INSERT INTO Lokasi_Gudang (kode_lokasi, kapasitas, tipe_lokasi) 
    VALUES (p_kode, p_kapasitas, p_tipe);
    SELECT LAST_INSERT_ID() AS new_id;
END

-- Read
CREATE PROCEDURE show_lokasi_gudang (
    IN p_id INT
)
BEGIN
    SELECT * FROM Lokasi_Gudang WHERE id_lokasi = p_id;
END

CREATE PROCEDURE show_all_lokasi_gudang ()
BEGIN
    SELECT
        LG.id_lokasi,
        LG.kode_lokasi,
        LG.tipe_lokasi,
        LG.kapasitas AS Kapasitas_Total,
        
        COALESCE(SUM(S.jumlah_stok), 0) AS Stok_Terisi,
        
        (LG.kapasitas - COALESCE(SUM(S.jumlah_stok), 0)) AS Kapasitas_Tersedia
        
    FROM
        Lokasi_Gudang LG
    LEFT JOIN
        Stok S ON LG.id_lokasi = S.id_lokasi
    
    GROUP BY
        LG.id_lokasi, LG.kode_lokasi, LG.tipe_lokasi, LG.kapasitas
    
    ORDER BY
        LG.kode_lokasi;
        
END

-- Update
CREATE PROCEDURE update_lokasi_gudang (
    IN p_id INT,
    IN p_kode VARCHAR(20),
    IN p_kapasitas INT,
    IN p_tipe VARCHAR(50)
)
BEGIN
    UPDATE Lokasi_Gudang 
    SET 
        kode_lokasi = p_kode, 
        kapasitas = p_kapasitas, 
        tipe_lokasi = p_tipe
    WHERE id_lokasi = p_id;
END

-- Delete
CREATE PROCEDURE delete_lokasi_gudang (
    IN p_id INT
)
BEGIN
    DELETE FROM Lokasi_Gudang WHERE id_lokasi = p_id;
END

-- STOK
-- Create
CREATE PROCEDURE add_stok (
    IN p_id_produk INT,
    IN p_id_lokasi INT,
    IN p_jumlah INT
)
BEGIN
    INSERT INTO Stok (id_produk, id_lokasi, jumlah_stok) 
    VALUES (p_id_produk, p_id_lokasi, p_jumlah);
    SELECT LAST_INSERT_ID() AS new_id;
END

-- Read
CREATE PROCEDURE show_stok (
    IN p_id_produk INT
)
BEGIN
    SELECT
        P.nama_produk,
        L.kode_lokasi,
        S.jumlah_stok,
        S.tanggal_update
    FROM
        Stok S
    JOIN
        Produk P ON S.id_produk = P.id_produk
    JOIN
        LokasiGudang L ON S.id_lokasi = L.id_lokasi
    WHERE
        S.id_produk = p_id_produk;

    SELECT
        P.nama_produk,
        SUM(S.jumlah_stok) AS total_stok_global
    FROM
        Stok S
    JOIN
        Produk P ON S.id_produk = P.id_produk
    WHERE
        S.id_produk = p_id_produk
    GROUP BY
        P.nama_produk;
END

CREATE PROCEDURE show_all_stok ()
BEGIN
    SELECT
        P.id_produk,
        P.nama_produk,
        P.sku,
        COALESCE(SUM(S.jumlah_stok), 0) AS total_stok_global,
        P.satuan
    FROM
        Produk P
    LEFT JOIN
        Stok S ON P.id_produk = S.id_produk
    GROUP BY
        P.id_produk, P.nama_produk, P.sku, P.satuan
    ORDER BY
        P.nama_produk;
END

-- Update
CREATE PROCEDURE update_stok (
    IN p_id INT,
    IN p_jumlah INT
)
BEGIN
    UPDATE Stok 
    SET 
        jumlah_stok = p_jumlah 
    WHERE id_stok = p_id;
END

-- Delete
CREATE PROCEDURE delete_stok (
    IN p_id INT
)
BEGIN
    DELETE FROM Stok WHERE id_stok = p_id;
END

-- PEMESANAN_MASUK
-- Create
CREATE PROCEDURE add_pemesanan_masuk (
    IN p_nomor_po VARCHAR(50),
    IN p_tanggal DATE,
    IN p_status VARCHAR(20),
    IN p_id_supplier INT
)
BEGIN
    INSERT INTO Pemesanan_Masuk (nomor_po, tanggal_masuk, status, id_supplier) 
    VALUES (p_nomor_po, p_tanggal, p_status, p_id_supplier);
    SELECT LAST_INSERT_ID() AS new_id;
END

-- Read
CREATE PROCEDURE show_pemesanan_masuk (
    IN p_id INT
)
BEGIN
    SELECT 
        PM.*, 
        S.nama_supplier 
    FROM 
        Pemesanan_Masuk PM JOIN Supplier S ON PM.id_supplier = S.id_supplier 
    WHERE 
        PM.id_masuk = p_id;
END

CREATE PROCEDURE show_all_pemesanan_masuk ()
BEGIN
    SELECT * FROM Pemesanan_Masuk;
END

-- Update
CREATE PROCEDURE update_pemesanan_masuk (
    IN p_id INT,
    IN p_nomor_po VARCHAR(50),
    IN p_tanggal DATE,
    IN p_status VARCHAR(20),
    IN p_id_supplier INT
)
BEGIN
    UPDATE Pemesanan_Masuk 
    SET 
        nomor_po = p_nomor_po, 
        tanggal_masuk = p_tanggal, 
        status = p_status, 
        id_supplier = p_id_supplier
    WHERE id_masuk = p_id;
END

-- Delete
CREATE PROCEDURE delete_pemesanan_masuk (
    IN p_id INT
)
BEGIN
    DELETE FROM Pemesanan_Masuk WHERE id_masuk = p_id;
END

-- PEMESANAN_KELUAR
-- Create
CREATE PROCEDURE add_pemesanan_keluar (
    IN p_nomor_penjualan VARCHAR(50),
    IN p_tanggal_keluar DATE,
    IN p_status VARCHAR(20),
    IN p_nama_pelanggan VARCHAR(100)
)
BEGIN
    INSERT INTO Pemesanan_Keluar (nomor_penjualan, tanggal_keluar, status, nama_pelanggan) 
    VALUES (p_nomor_penjualan, p_tanggal_keluar, p_status, p_nama_pelanggan);
    SELECT LAST_INSERT_ID() AS new_id;
END

-- Read
CREATE PROCEDURE show_pemesanan_keluar (
    IN p_id INT
)
BEGIN
    SELECT * FROM Pemesanan_Keluar WHERE id_keluar = p_id;
END

CREATE PROCEDURE show_all_pemesanan_keluar ()
BEGIN
    SELECT * FROM Pemesanan_Keluar;
END

-- Update
CREATE PROCEDURE update_pemesanan_keluar (
    IN p_id INT,
    IN p_nomor_penjualan VARCHAR(50),
    IN p_tanggal_keluar DATE,
    IN p_status VARCHAR(20),
    IN p_nama_pelanggan VARCHAR(100)
)
BEGIN
    UPDATE Pemesanan_Keluar 
    SET 
        nomor_penjualan = p_nomor_penjualan, 
        tanggal_keluar = p_tanggal_keluar, 
        status = p_status, 
        nama_pelanggan = p_nama_pelanggan
    WHERE id_keluar = p_id;
END

CREATE PROCEDURE delete_pemesanan_keluar (
    IN p_id INT
)
BEGIN
    DELETE FROM PemesananKeluar WHERE id_keluar = p_id;
END

-- BARANG MASUK (PEMESANAN_MASUK + DETAIL_MASUK)
CREATE PROCEDURE SP_PenerimaanBarang (
    IN p_id_masuk INT,          
    IN p_id_produk INT,
    IN p_kuantitas INT,         
    IN p_id_lokasi INT          
)
BEGIN
    DECLARE existing_stok INT;
    
    START TRANSACTION;

    INSERT INTO DetailMasuk (id_masuk, id_produk, kuantitas_diterima) 
    VALUES (p_id_masuk, p_id_produk, p_kuantitas);

    SELECT COUNT(*) INTO existing_stok 
    FROM Stok WHERE id_produk = p_id_produk AND id_lokasi = p_id_lokasi;

    IF existing_stok > 0 THEN
        UPDATE Stok 
        SET jumlah_stok = jumlah_stok + p_kuantitas
        WHERE id_produk = p_id_produk AND id_lokasi = p_id_lokasi;
    ELSE
        INSERT INTO Stok (id_produk, id_lokasi, jumlah_stok) 
        VALUES (p_id_produk, p_id_lokasi, p_kuantitas);
    END IF;
    
    COMMIT;
    
END

-- BARANG KELUAR (PEMESANAN_KELUAR + DETAIL_KELUAR)
CREATE PROCEDURE SP_PengeluaranBarang (
    IN p_id_keluar INT,         
    IN p_id_produk INT,
    IN p_kuantitas INT,         
    IN p_id_lokasi_ambil INT    
)
BEGIN
    DECLARE available_stok INT DEFAULT 0;
    
    SELECT jumlah_stok INTO available_stok 
    FROM Stok WHERE id_produk = p_id_produk AND id_lokasi = p_id_lokasi_ambil;
    
    IF available_stok < p_kuantitas THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERROR: Stok tidak cukup di lokasi pengambilan yang ditentukan.';
    ELSE
        START TRANSACTION;

        UPDATE Stok 
        SET jumlah_stok = jumlah_stok - p_kuantitas
        WHERE id_produk = p_id_produk AND id_lokasi = p_id_lokasi_ambil;

        INSERT INTO DetailKeluar (id_keluar, id_produk, kuantitas_diminta) 
        VALUES (p_id_keluar, p_id_produk, p_kuantitas);
        
        COMMIT;
    
    END IF;
END

-- LAPORAN STATISTIK GUDANG
CREATE PROCEDURE SP_LaporanStatistikGudang ()
BEGIN

    SELECT
        COUNT(DISTINCT P.id_produk) AS Total_Produk_Unik,
        COALESCE(SUM(S.jumlah_stok), 0) AS Total_Unit_Stok,
        COALESCE(SUM(S.jumlah_stok * P.harga_beli), 0) AS Total_Nilai_Inventaris_Beli
    FROM
        Produk P
    LEFT JOIN
        Stok S ON P.id_produk = S.id_produk;

    SELECT
        COUNT(CASE WHEN PM.status = 'Diterima Penuh' AND PM.tanggal_masuk >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) AS PO_Selesai_30Hari,
        COUNT(CASE WHEN PK.status = 'Dikirim' AND PK.tanggal_keluar >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) AS SO_Dikirim_30Hari
    FROM
        Pemesanan_Masuk PM
    CROSS JOIN
        Pemesanan_Keluar PK;

    SELECT
        SUM(LG.kapasitas) AS Total_Kapasitas_Global,
        COALESCE(SUM(S.jumlah_stok), 0) AS Total_Stok_Terisi,
        (SUM(LG.kapasitas) - COALESCE(SUM(S.jumlah_stok), 0)) AS Sisa_Kapasitas_Global
    FROM
        Lokasi_Gudang LG
    LEFT JOIN
        Stok S ON LG.id_lokasi = S.id_lokasi;

    CALL show_all_lokasi_gudang();

    SELECT
        S.nama_supplier,
        COALESCE(SUM(DM.kuantitas_diterima), 0) AS Total_Unit_Diterima
    FROM
        Supplier S
    JOIN
        Pemesanan_Masuk PM ON S.id_supplier = PM.id_supplier
    JOIN
        Detail_Masuk DM ON PM.id_masuk = DM.id_masuk
    GROUP BY
        S.nama_supplier
    ORDER BY
        Total_Unit_Diterima DESC
    LIMIT 5;

END