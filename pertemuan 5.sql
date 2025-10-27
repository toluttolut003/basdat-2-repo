CREATE TABLE produk_motor (
	id_motor int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nama_motor VARCHAR(30),
	harga INT
)

CREATE TABLE log_harga (

	id_log int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_motor INT REFERENCES produk_motor(id_motor),
	harga_lama INT,
	harga_baru INT,
	tgl_ubah DATE
);

SELECT * FROM produk_motor;
SELECT * FROM log_harga;

INSERT INTO produk_motor
VALUES (DEFAULT, 'Supra Fit',	5000000),
		(DEFAULT,'Astrea',		3000000),
		(DEFAULT, 'Beat Kabru', 7000000),
		(DEFAULT, 'Satria FU', 	7000000);

--membuat fungsi trigger nya

CREATE OR REPLACE FUNCTION
func_log_harga()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL --program language postgreSQL
	AS
$$
BEGIN
	INSERT INTO log_harga
	VALUES 
		(DEFAULT, OLD.id_motor, OLD.harga, NEW.harga, CURRENT_DATE);
	RETURN NEW;
END;
$$

--sekarang membuat triger nya

CREATE TRIGGER trig_log_harga
	BEFORE UPDATE ON produk_motor
	FOR EACH ROW
	EXECUTE PROCEDURE func_log_harga();

--lakukan perubahan
	UPDATE produk_motor SET harga = 10000000
	WHERE id_motor = '3';
--lalu cek log nya
SELECT * FROM log_harga;

--UPDATE NAMA TRIGGER
ALTER TRIGGER trig_log_harga
ON produk_motor
RENAME TO ini_trigger_harga;

--show trigger list
SELECT * FROM pg_trigger;

DROP TRIGGER ini_trigger_harga ON produk_motor;

DROP FUNCTION tambah --function tidak perlu di drop kalau mau update, jalani ulang saja

CREATE OR REPLACE FUNCTION tambah(angka1 INT, angka2 INT)
	RETURNS INT
	LANGUAGE PLPGSQL
AS
$$
	BEGIN
		RETURN angka2 - angka1;
	END
$$

SELECT tambah (1,2);

--fungsi cek harga mahal atau tidak dengan

CREATE OR REPLACE FUNCTION cek_harga(harga NUMERIC)
	RETURNS TEXT --PAKE S
	LANGUAGE PLPGSQL
AS
$$
	BEGIN
	IF harga > 100000 THEN
		RETURN 'Mahal nyoo';
	ELSE 
		RETURN 'Murah Teing';
	END IF;
END;
$$

SELECT cek_harga(harga) FROM produk_motor;