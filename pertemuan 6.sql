--membuat table rekening
CREATE TABLE rekening (
	id_rekening SERIAL PRIMARY KEY,
	nama VARCHAR(100),
	saldo INT
);
--untuk harga cocok nya pakai decimal
--tapi pakai integer agar lebih simpel

INSERT INTO rekening
VALUES (DEFAULT, 'Tomlut', 50000),
	(DEFAULT, 'salman', 75000),
	(DEFAULT, 'Helmi', 100000);

-- syarat saldo tambah rekening saldo min. 20k
-- ingat tambah rekening

CREATE OR REPLACE PROCEDURE pro_tambah_rekening(
	IN nama_nasabah VARCHAR(100),
	IN saldo INT
)
LANGUAGE plpgsql
AS
$$
BEGIN

	--ketika saldo lebih kecil dari 20k
	IF (saldo >= 20000) THEN
		INSERT INTO rekening 
		VALUES (DEFAULT, nama_nasabah, saldo);
		--% diletakan dimana saja sesuai keinginan
		RAISE NOTICE 'Saldo berhasil di tambahkan ke rekening %, sejumlah % !', nama_nasabah, saldo;
	ELSE
		--seperti cout untuk informasi keterangan jika gagal
		RAISE NOTICE 'Saldo kurang dari 20000';
	END IF;
END;
$$;

SELECT * FROM rekening;
CALL pro_tambah_rekening('Emilia Croissant', 70000);

--hapus procedure
DROP PROCEDURE pro_tambah_rekening;
--tentukan parameter nya biar aman jika semisalnya ada prosedur dengan nama yang sama
--pakai type data nya
DROP PROCEDURE pro_tambah_rekening (VARCHAR, INT)

-- prosedur cek saldo berdasarkan id
CREATE OR REPLACE PROCEDURE pro_cek_saldo(
	IN id_nasabah INT,
	OUT saldo_nasabah INT
)
LANGUAGE plpgsql
AS
$$
BEGIN
	--tidak bisa menggunakan id = null harus pakai NOT FOUND
	IF NOT FOUND THEN 
		saldo_nasabah := NULL;
		RAISE NOTICE 'ID Tidak ditemukan !';
		--mengisikan null
	ELSE 
		--menyimpan saldo parent ke saldo show
		SELECT saldo INTO saldo_nasabah FROM rekening 
		WHERE id_rekening = id_nasabah;
		RAISE NOTICE 'ID ditemukan !'; 
	END IF;
END;
$$;

CALL pro_cek_saldo(9, NULL);