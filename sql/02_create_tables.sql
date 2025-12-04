CREATE TABLE Supplier (
    id_supplier INT PRIMARY KEY AUTO_INCREMENT,
    nama_supplier VARCHAR(100) NOT NULL,
    kontak_person VARCHAR(100),
    telepon VARCHAR(20),
    alamat TEXT
);

CREATE TABLE Produk (
    id_produk INT PRIMARY KEY AUTO_INCREMENT,
    nama_produk VARCHAR(150) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    deskripsi TEXT,
    berat DECIMAL(10, 2),
    satuan VARCHAR(10) NOT NULL,
    harga_beli DECIMAL(10, 2),
    id_supplier INT,
    FOREIGN KEY (id_supplier) REFERENCES Supplier(id_supplier)
);

CREATE TABLE Lokasi_Gudang (
    id_lokasi INT PRIMARY KEY AUTO_INCREMENT,
    kode_lokasi VARCHAR(20) UNIQUE NOT NULL,
    kapasitas INT,
    tipe_lokasi VARCHAR(50)
);

CREATE TABLE Stok (
    id_stok INT PRIMARY KEY AUTO_INCREMENT,
    id_produk INT NOT NULL,
    id_lokasi INT NOT NULL,
    jumlah_stok INT NOT NULL DEFAULT 0,
    tanggal_update DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_produk) REFERENCES Produk(id_produk),
    FOREIGN KEY (id_lokasi) REFERENCES Lokasi_Gudang(id_lokasi),
    
    UNIQUE KEY (id_produk, id_lokasi) 
);

CREATE TABLE Pemesanan_Masuk (
    id_masuk INT PRIMARY KEY AUTO_INCREMENT,
    nomor_po VARCHAR(50) UNIQUE NOT NULL,
    tanggal_masuk DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Diterima',
    id_supplier INT,
    
    FOREIGN KEY (id_supplier) REFERENCES Supplier(id_supplier)
);

CREATE TABLE Detail_Masuk (
    id_detail_masuk INT PRIMARY KEY AUTO_INCREMENT,
    id_masuk INT NOT NULL,
    id_produk INT NOT NULL,
    kuantitas_diterima INT NOT NULL,
    tanggal_kadaluarsa DATE,
    
    FOREIGN KEY (id_masuk) REFERENCES Pemesanan_Masuk(id_masuk),
    FOREIGN KEY (id_produk) REFERENCES Produk(id_produk)
);

CREATE TABLE Pemesanan_Keluar (
    id_keluar INT PRIMARY KEY AUTO_INCREMENT,
    nomor_penjualan VARCHAR(50) UNIQUE NOT NULL,
    tanggal_keluar DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Diproses',
    nama_pelanggan VARCHAR(100) NOT NULL
);

CREATE TABLE Detail_Keluar (
    id_detail_keluar INT PRIMARY KEY AUTO_INCREMENT,
    id_keluar INT NOT NULL,
    id_produk INT NOT NULL,
    kuantitas_diminta INT NOT NULL,
    
    FOREIGN KEY (id_keluar) REFERENCES Pemesanan_Keluar(id_keluar),
    FOREIGN KEY (id_produk) REFERENCES Produk(id_produk)
);