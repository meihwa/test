--EXEC USP_ProsesData 201709,4

CREATE PROC USP_ProsesData
	@PERIODE AS NUMERIC(6,0),
	@NoDataJenisPajak AS INT
AS

DECLARE @TIPENPWP AS NCHAR(5),
		@NPWP_PP AS VARCHAR(15),
		@NoData INT,
		@NoAwal AS INT,
		@Count AS INT,
		@Inisial AS VARCHAR(MAX),
		@InisialSesudah AS VARCHAR(MAX),
		@Butpot AS VARCHAR(MAX),
		@JenisPajak AS VARCHAR(MAX),
		@Tahun AS VARCHAR(MAX)

SET @InisialSesudah = ''
SET @Count = 0

--GET TIPE NPWP
SELECT @TIPENPWP = REPLACE(JenisPajak,'PPH ','')
FROM PJK_JenisPajak
WHERE NoDataJenisPajak = @NoDataJenisPajak
AND fAktif = 1

--CREATE TEMP TABLE
CREATE TABLE #PajakDS (
	[NoData] [int] IDENTITY(1,1) NOT NULL,
	[MasaPajak] [varchar](2) NULL,
	[TahunPajak] [varchar](4) NULL,
	[Pembetulan] [varchar](10) NULL,
	[NoBuktiPotong] [varchar](50) NULL,
	[NPWP_WP] [varchar](15) NULL,
	[KTP_WP] [varchar](100) NULL,
	[Nama_WP] [varchar](200) NULL,
	[Alamat_WP] [varchar](500) NULL,
	[fWNA] [nchar](1) NULL,
	[KodeNegara] [varchar](10) NULL,
	[KodePajak] [varchar](10) NULL,
	[JumlahBruto] [decimal](18, 0) NULL,
	[JumlahDPP] [decimal](18, 0) NULL,
	[fTanpaNPWP] [nchar](10) NULL,
	[Rate] [decimal](18, 2) NULL,
	[JumlahPPH] [decimal](18, 0) NULL,
	[NPWPPemotong] [varchar](15) NULL,
	[NamaPemotong] [varchar](200) NULL,
	[TglBuktiPotong] [datetime] NULL,
	[KodeForm] [varchar](20) NULL,
	[KodeJasa] [varchar](5) NULL
)


IF (@TIPENPWP = '23' OR @TIPENPWP = '21')
BEGIN
	
	--INSERT USP_KIRIM_FILE_PPH TO TEMP TABLE
	INSERT INTO #PajakDS
	EXEC SQLCLUSTER.DS.dbo.USP_KIRIM_FILE_PPH @PERIODE,@TIPENPWP,'ALL','0'

	--ADD COLUMNS IN TEMP TABLE
	ALTER TABLE #PajakDS
	ADD [JenisPajak] [varchar](50) NULL,
		[KodeCabang] [numeric](3, 0) NULL,
		[Inisial] [varchar](20) NULL,
		[fDS] [bit] NULL,
		[NoDataBuktiPotongHdr][varchar](MAX) NULL ;


	--UPDATE COLUMN JenisPajak AND fDS
	UPDATE #PajakDS
	SET JenisPajak = 'PPH' + @TIPENPWP,
		fDS = 'TRUE',
		NoDataBuktiPotongHdr='';


	--UPDATE COLUMNS KodeCabang AND Inisial 
	UPDATE #PajakDS
	SET KodeCabang = P.KodeCabang,
		Inisial = 'IMFI-' +  H.Inisial	
	FROM PJK_PemotongPajak P
	INNER JOIN PJK_InisialCabangDtl D
	ON P.KodeCabang = D.KodeCabang
	INNER JOIN PJK_InisialCabangHdr H
	ON D.NoDataInisialHdr = H.NoDataInisialHdr
	WHERE NPWPPemotong = P.NPWP
END
ELSE
BEGIN

	--ADD COLUMNS IN TEMP TABLE
	ALTER TABLE #PajakDS
	ADD [JenisPajak] [varchar](50) NULL,
		[KodeCabang] [numeric](3, 0) NULL,
		[Inisial] [varchar](20) NULL,
		[fDS] [bit] NULL,
		[NoDataBuktiPotongHdr][varchar](MAX) NULL ;

END


--INSERT PAJAK FROM DBWEB2 TO TEMP TABLE
INSERT INTO #PajakDS
SELECT	CASE WHEN RIGHT(H.Periode,2) >= 10 THEN RIGHT(H.Periode,2)
			 ELSE RIGHT(H.Periode,1)
		END AS MasaPajak,
		LEFT(H.Periode,4) AS TahunPajak,
		H.Pembetulan,
		H.NoBuktiPotong,
		WP.NPWP AS NPWP_WP,
		WP.NIK AS KTP_WP,
		WP.NamaWajibPajak AS Nama_WP,
		WP.Alamat AS Alamat_WP,
		CASE WHEN WP.fWNA = 'FALSE' THEN 'N'
			 ELSE 'Y'
		END AS fWNA,
		WP.KodeNegara,
		CASE WHEN @TIPENPWP = '21' THEN JP.KodeJasa
			 ELSE ''
		END AS KodePajak,
		D.JmlPenghasilanBruto,
		D.JumlahDPP,
		CASE WHEN WP.fTanpaNPWP = 'FALSE' THEN 'N'
			 ELSE 'Y'
		END AS fTanpaNPWP,
		D.Tarif,
		D.PPhDipotong,
		PP.NPWP AS NPWP_PP,
		PP.NamaPemotongPajak AS Nama_PP,
		H.TanggalPotong,
		J.FormBukPot,
		CASE WHEN @TIPENPWP = '23' AND JP.KodeJasa = '' THEN 'NO' + CONVERT(VARCHAR(MAX),JP.NoUrutCetak)
			 WHEN @TIPENPWP = '23' AND JP.KodeJasa <> '' THEN JP.KodeJasa
			 ELSE ''
		END AS KodeJasa,
		REPLACE(J.JenisPajak,' ','') AS JenisPajak,
		PP.KodeCabang,
		'IMFI-' + IH.Inisial AS Inisial,
		'0' AS fDS,
		CONVERT(VARCHAR(MAX),H.NoDataBuktiPotongHdr) AS NoDataBuktiPotongHdr
FROM PJK_BuktiPotongPajakHdr H
INNER JOIN PJK_BuktiPotongPajakDtl D
ON H.NoDataBuktiPotongHdr = D.NoDataBuktiPotongHdr
INNER JOIN PJK_WajibPajak WP
ON H.NoDataWajibPajak = WP.NoDataWajibPajak
INNER JOIN PJK_PemotongPajak PP
ON H.NoDataPemotongPajak = PP.NoDataPemotongPajak
INNER JOIN PJK_JenisPajak J
ON H.NoDataJenisPajak = J.NoDataJenisPajak
INNER JOIN PJK_InisialCabangDtl ID
ON PP.KodeCabang = ID.KodeCabang
INNER JOIN PJK_InisialCabangHdr IH
ON ID.NoDataInisialHdr = IH.NoDataInisialHdr
INNER JOIN PJK_JenisPenghasilan JP
ON D.NoDataJenisPenghasilan = JP.NoDataJenisPenghasilan
WHERE H.Periode = @PERIODE
AND H.NoDataJenisPajak = @NoDataJenisPajak


--GET NoBuktiPotong
DECLARE db_cursor CURSOR FOR  

	SELECT NoData , Inisial , 0 , JenisPajak, TahunPajak
	FROM #PajakDS
	WHERE Inisial IS NOT NULL
	ORDER BY Inisial

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @NoData , @Inisial , @NoAwal, @JenisPajak,@Tahun

WHILE @@FETCH_STATUS = 0  
BEGIN   
	
	SELECT @NoAwal = MAX(CONVERT(INT,SUBSTRING(NoBuktiPotong,1,6))) 
	FROM PJK_DataGabungan
	WHERE JenisPajak = 'PPH' + @TIPENPWP
	AND Inisial = @Inisial
	GROUP BY Inisial
	
	IF @InisialSesudah = @Inisial
	BEGIN
		
		IF LEN(@Count) = 1 
		BEGIN
			SET @Butpot = '00000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
		END
		ELSE IF LEN(@Count) = 2 
		BEGIN
			SET @Butpot = '0000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
		END
		ELSE IF LEN(@Count) = 3 
		BEGIN
			SET @Butpot = '000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
		END
		ELSE IF LEN(@Count) = 4
		BEGIN
			SET @Butpot = '00' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
		END
		ELSE IF LEN(@Count) = 5 
		BEGIN
			SET @Butpot = '0' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
		END
		ELSE IF LEN(@Count) = 6 
		BEGIN
			SET @Butpot = CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
		END

		UPDATE #PajakDS
		SET NoBuktiPotong = @Butpot
		WHERE NoData = @NoData
	END

	ELSE
	BEGIN
		
		IF @NoAwal = 0
		BEGIN
			
			SET @Count = 1
			
			UPDATE #PajakDS
			SET NoBuktiPotong = '00000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
			WHERE NoData = @NoData
		END

		ELSE
		BEGIN
			SET @Count = @NoAwal + 1

			IF LEN(@Count) = 1 
			BEGIN
				SET @Butpot = '00000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
			END
			ELSE IF LEN(@Count) = 2 
			BEGIN
				SET @Butpot = '0000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
			END
			ELSE IF LEN(@Count) = 3 
			BEGIN
				SET @Butpot = '000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
			END
			ELSE IF LEN(@Count) = 4
			BEGIN
				SET @Butpot = '00' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
			END
			ELSE IF LEN(@Count) = 5 
			BEGIN
				SET @Butpot = '0' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
			END
			ELSE IF LEN(@Count) = 6 
			BEGIN
				SET @Butpot = CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
			END

			UPDATE #PajakDS
			SET NoBuktiPotong = @Butpot
			WHERE NoData = @NoData
		END
	END
		
	SET @Count = @Count + 1
	SET @InisialSesudah = @Inisial

	FETCH NEXT FROM db_cursor INTO @NoData , @Inisial , @NoAwal, @JenisPajak,@Tahun
END

CLOSE db_cursor  
DEALLOCATE db_cursor 


--INSERT INTO TABLE PJK_DataGabungan
INSERT INTO PJK_DataGabungan
SELECT	MasaPajak,
		TahunPajak,
		Pembetulan,
		NoBuktiPotong,
		NPWP_WP,
		KTP_WP,
		Nama_WP,
		Alamat_WP,
		fWNA,
		KodeNegara,
		KodePajak,
		JumlahBruto,
		JumlahDPP,
		fTanpaNPWP,
		Rate,
		JumlahPPH,
		NPWPPemotong,
		NamaPemotong,
		TglBuktiPotong,
		KodeForm,
		KodeJasa,
		JenisPajak,
		KodeCabang,
		Inisial,
		fDS,
		'system',
		GETDATE(),
		'system',
		GETDATE()
FROM #PajakDS
WHERE Inisial IS NOT NULL


--INSERT INTO TABLE PJK_DataGagalProses
INSERT INTO PJK_DataGagalProses
SELECT	MasaPajak,
		TahunPajak,
		Pembetulan,
		NoBuktiPotong,
		NPWP_WP,
		KTP_WP,
		Nama_WP,
		Alamat_WP,
		fWNA,
		KodeNegara,
		KodePajak,
		JumlahBruto,
		JumlahDPP,
		fTanpaNPWP,
		Rate,
		JumlahPPH,
		NPWPPemotong,
		NamaPemotong,
		TglBuktiPotong,
		KodeForm,
		KodeJasa,
		JenisPajak,
		KodeCabang,
		Inisial,
		fDS,
		'system',
		GETDATE(),
		'system',
		GETDATE()
FROM #PajakDS
WHERE Inisial IS NULL

--UPDATE NoBuktiPotong in TABLE PJK_BuktiPotongPajakHdr
UPDATE PJK_BuktiPotongPajakHdr 
SET NoBuktiPotong =  A.NoBuktiPotong
FROM #PajakDS A 
INNER JOIN PJK_BuktiPotongPajakHdr H
ON A.NoDataBuktiPotongHdr = CONVERT(VARCHAR(MAX),H.NoDataBuktiPotongHdr)
WHERE A.fDS = 0

--DROP TEMP TABLE
DROP TABLE #PajakDS

