USE [Pajak]
GO
/****** Object:  StoredProcedure [dbo].[USP_ProsesData]    Script Date: 2/2/2018 11:13:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC USP_ProsesData '23'

ALTER PROC [dbo].[USP_ProsesData]
	@TIPENPWP AS NCHAR(5)
AS

DECLARE @PERIODE AS NUMERIC(6,0),
		@NPWP_PP AS VARCHAR(15),
		@NoData INT,
		@NoAwal AS INT,
		@Count AS INT,
		@Inisial AS VARCHAR(MAX),
		@InisialSesudah AS VARCHAR(MAX),
		@Butpot AS VARCHAR(MAX),
		@JenisPajak AS VARCHAR(MAX),
		@Tahun AS VARCHAR(MAX),
		@Month AS VARCHAR(MAX),
		@Year AS VARCHAR(MAX),
		@Tgl AS DATETIME

SET @InisialSesudah = ''
SET @Count = 0

--DELETE DATA GABUNGAN (MANUAL AND DS)
DELETE PJK_DataGabungan
FROM PJK_DataGabungan G
INNER JOIN PJK_MasaPajak M
ON G.MasaPajak = M.CurrentMonthPeriod
AND G.TahunPajak = M.CurrentYearPeriod
WHERE G.JenisPajak = 'PPH' + @TIPENPWP

--DELETE DATA GAGAL (MANUAL AND DS)
DELETE PJK_DataGagalProses
FROM PJK_DataGagalProses G
INNER JOIN PJK_MasaPajak M
ON G.MasaPajak = M.CurrentMonthPeriod
AND G.TahunPajak = M.CurrentYearPeriod
WHERE G.JenisPajak = 'PPH' + @TIPENPWP

--GET PERIODE
SELECT @PERIODE = ( CurrentYearPeriod * 100 ) + CurrentMonthPeriod
FROM PJK_MasaPajak

--GET MONTH AND YEAR FOR PPH 21
SELECT	@Year =  Right(CurrentYearPeriod,2) ,
		@Month = CASE WHEN LEN(CurrentMonthPeriod) = 1  THEN '0' + CONVERT(VARCHAR(MAX),CurrentMonthPeriod)
				 ELSE CONVERT(VARCHAR(MAX),CurrentMonthPeriod)
				 END
FROM PJK_MasaPajak


--SET TglBuktiPotong For PPH 21 Fidusia
SET @Tgl = DBO.SetJamTgl(
			DBO.SetMonthEndDate(
            CONVERT(
                DATETIME,
                (
                    CONVERT(CHAR, CONVERT(INT, @PERIODE) % 100) + '/1/' + 
                    CONVERT(CHAR, CONVERT(INT, @PERIODE) / 100)
                )
            )
        )
    )

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
	[fTanpaNPWP] [nchar](1) NULL,
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
	EXEC SQLCLUSTER.DS.dbo.USP_KIRIM_FILE_PPH @PERIODE,@TIPENPWP,'ALL','A'

	--INSERT PPH 21 Fidusia
	IF @TIPENPWP = '21'
	BEGIN
			INSERT INTO #PajakDS
			SELECT	DISTINCT CASE WHEN RIGHT(A.PERIODE,2) >= 10 THEN RIGHT(A.PERIODE,2)
							 ELSE RIGHT(A.PERIODE,1)
							 END MasaPajak,
					LEFT(A.PERIODE,4) TahunPajak,
					0 AS Pembetulan,
					'' AS NoBuktiPotong,
					REPLACE(REPLACE(REPLACE(REPLACE(N.NPWP,'.',''),'-',''),' ',''),',','') AS NPWP_WP,
					REPLACE(REPLACE(REPLACE(REPLACE(N.NO_KTP,'.',''),'-',''),' ',''),',','') AS KTP_WP,
					N.NAMA_NOTARIS AS Nama_WP,
					N.ALAMAT1 AS Alamat_WP,
					'N' AS fWNA,
					'' AS KodeNegara,
					'21-100-07' AS KodePajak,
					A.KUMULATIF_BLN_INI * 2 AS JumlahBruto,
					A.KUMULATIF_BLN_INI AS JumlahDPP,
					CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(N.NPWP,'.',''),'-',''),' ',''),',','')) = 15 THEN 'N'
							ELSE 'Y'
					END fTanpaNPWP,
					CASE WHEN A.KUMULATIF_SD_BLN_LALU >= 0 AND A.KUMULATIF_SD_BLN_LALU <= 50000000 THEN 5
							WHEN A.KUMULATIF_SD_BLN_LALU > 50000000 AND A.KUMULATIF_SD_BLN_LALU <= 250000000 THEN 15
							WHEN A.KUMULATIF_SD_BLN_LALU > 250000000 AND A.KUMULATIF_SD_BLN_LALU <= 500000000 THEN 25
							WHEN A.KUMULATIF_SD_BLN_LALU > 500000000 THEN 30
					END Rate,
					A.PPH_REAL_BLN_INI AS JumlahPPH,
					REPLACE(REPLACE(REPLACE(REPLACE(A.NO_NPWP_CBG,'.',''),'-',''),' ',''),',','') AS NPWPPemotong,
					'PT INDOMOBIL FINANCE INDONESIA' AS NamaPemotong,
					@Tgl AS TglBuktiPotong,
					'' AS KodeForm,
					'' AS KodeJasa
			FROM SQLCLUSTER.DS.DBO.DS_BIAYA_AKTA A 
			INNER JOIN SQLCLUSTER.DS.DBO.DS_BIAYA_AKTA_TRANSAKSI T 
			ON A.NO_DATA_BIAYAAKTA = T.NO_DATA_BIAYAAKTA
			INNER JOIN SQLCLUSTER.DS.DBO.DS_NOTARIS N 
			ON N.NO_DATA_NOTARIS = T.NO_DATA_NOTARIS
			WHERE A.PERIODE = @PERIODE
	END

	--ADD COLUMNS IN TEMP TABLE
	ALTER TABLE #PajakDS
	ADD [JenisPajak] [varchar](50) NULL,
		[KodeCabang] [numeric](3, 0) NULL,
		[CabangUtama] [varchar](200) NULL,
		[Inisial] [varchar](20) NULL,
		[fDS] [bit] NULL,
		[NoDataBuktiPotongHdr][varchar](MAX) NULL ;


	--UPDATE COLUMN JenisPajak AND fDS
	UPDATE #PajakDS
	SET JenisPajak = LTRIM(RTRIM('PPH' + @TIPENPWP)),
		fDS = 'TRUE',
		NoDataBuktiPotongHdr='';


	--UPDATE COLUMNS KodeCabang AND Inisial 
	UPDATE #PajakDS
	SET KodeCabang = P.KodeCabang,
		CabangUtama = H.Keterangan,
		Inisial = 'IMFI-' +  H.Inisial	
	FROM PJK_PemotongPajak P
	INNER JOIN PJK_InisialCabangDtl D
	ON P.KodeCabang = D.KodeCabang
	INNER JOIN PJK_InisialCabangHdr H
	ON D.NoDataInisialHdr = H.NoDataInisialHdr
	WHERE NPWPPemotong = P.NPWP
	AND D.fAktif = 1
	AND P.Aktif = 1
END
ELSE
BEGIN

	--ADD COLUMNS IN TEMP TABLE
	ALTER TABLE #PajakDS
	ADD [JenisPajak] [varchar](50) NULL,
		[KodeCabang] [numeric](3, 0) NULL,
		[CabangUtama] [varchar](200) NULL,
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
		CASE WHEN @TIPENPWP = '23' AND (JP.KodeJasa = '' OR JP.KodeJasa IS NULL) THEN 'NO' + CONVERT(VARCHAR(MAX),JP.NoUrutCetak)
			 WHEN @TIPENPWP = '23' AND (JP.KodeJasa <> '' AND JP.KodeJasa IS NOT NULL) THEN JP.KodeJasa
			 WHEN @TIPENPWP = '4(2)' AND (JP.KodeJasa = '' OR JP.KodeJasa IS NULL) THEN 'NO' + CONVERT(VARCHAR(MAX),JP.NoUrutCetak)
			 ELSE ''
		END AS KodeJasa,
		REPLACE(J.JenisPajak,' ','') AS JenisPajak,
		PP.KodeCabang,
		IH.Keterangan,
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
AND H.Status = 'L'
AND H.NoDataJenisPajak IN	( 
								SELECT NoDataJenisPajak
								FROM PJK_JenisPajak
								WHERE JenisPajak LIKE '%' + RTRIM(@TIPENPWP) + '%'
							)


IF (@TIPENPWP = '21')
BEGIN
		--GET NoBuktiPotong
		DECLARE db_cursor21 CURSOR FOR  

			SELECT NoData , Replace(Inisial,' ','') , 0 
			FROM #PajakDS
			WHERE Inisial IS NOT NULL
			ORDER BY Inisial, fDS 

		OPEN db_cursor21  
		FETCH NEXT FROM db_cursor21 INTO @NoData , @Inisial , @NoAwal

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

			IF @Month <> '01'
			BEGIN
				SELECT @NoAwal = MAX(CONVERT(INT,RIGHT(NoBuktiPotong,7))) 
				FROM PJK_DataGabungan
				WHERE JenisPajak = 'PPH' + @TIPENPWP
				AND TahunPajak = LEFT(@PERIODE,4)
				AND Inisial = @Inisial
				GROUP BY Inisial
			END

			IF @InisialSesudah = @Inisial
			BEGIN
				IF LEN(@Count) = 1 
				BEGIN
					SET @Butpot = '1.3-' + @Month + '.' + @Year + '-000000' + CONVERT(VARCHAR(MAX),@Count)
				END
				ELSE IF LEN(@Count) = 2 
				BEGIN
					SET @Butpot = '1.3-' + @Month + '.' + @Year + '-00000' + CONVERT(VARCHAR(MAX),@Count)
				END
				ELSE IF LEN(@Count) = 3 
				BEGIN
					SET @Butpot = '1.3-' + @Month + '.' + @Year + '-0000' + CONVERT(VARCHAR(MAX),@Count)
				END
				ELSE IF LEN(@Count) = 4
				BEGIN
					SET @Butpot = '1.3-' + @Month + '.' + @Year + '-000' + CONVERT(VARCHAR(MAX),@Count)
				END
				ELSE IF LEN(@Count) = 5 
				BEGIN
					SET @Butpot = '1.3-' + @Month + '.' + @Year + '-00' + CONVERT(VARCHAR(MAX),@Count)
				END
				ELSE IF LEN(@Count) = 6 
				BEGIN
					SET @Butpot = '1.3-' + @Month + '.' + @Year + '-0' + CONVERT(VARCHAR(MAX),@Count)
				END
				ELSE IF LEN(@Count) = 7
				BEGIN
					SET @Butpot = '1.3-' + @Month + '.' + @Year + '-' + CONVERT(VARCHAR(MAX),@Count)
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
					SET NoBuktiPotong = '1.3-' + @Month + '.' + @Year + '-000000' + CONVERT(VARCHAR(MAX),@Count)
					WHERE NoData = @NoData
				END

				ELSE
				BEGIN
					SET @Count = @NoAwal + 1

					IF LEN(@Count) = 1 
					BEGIN
						SET @Butpot = '1.3-' + @Month + '.' + @Year + '-000000' + CONVERT(VARCHAR(MAX),@Count)
					END
					ELSE IF LEN(@Count) = 2 
					BEGIN
						SET @Butpot = '1.3-' + @Month + '.' + @Year + '-00000' + CONVERT(VARCHAR(MAX),@Count)
					END
					ELSE IF LEN(@Count) = 3 
					BEGIN
						SET @Butpot = '1.3-' + @Month + '.' + @Year + '-0000' + CONVERT(VARCHAR(MAX),@Count)
					END
					ELSE IF LEN(@Count) = 4
					BEGIN
						SET @Butpot = '1.3-' + @Month + '.' + @Year + '-000' + CONVERT(VARCHAR(MAX),@Count)
					END
					ELSE IF LEN(@Count) = 5 
					BEGIN
						SET @Butpot = '1.3-' + @Month + '.' + @Year + '-00' + CONVERT(VARCHAR(MAX),@Count)
					END
					ELSE IF LEN(@Count) = 6 
					BEGIN
						SET @Butpot = '1.3-' + @Month + '.' + @Year + '-0' + CONVERT(VARCHAR(MAX),@Count)
					END
					ELSE IF LEN(@Count) = 7
					BEGIN
						SET @Butpot = '1.3-' + @Month + '.' + @Year + '-' + CONVERT(VARCHAR(MAX),@Count)
					END

					UPDATE #PajakDS
					SET NoBuktiPotong = @Butpot
					WHERE NoData = @NoData
				END
			END
		
			SET @Count = @Count + 1
			SET @InisialSesudah = @Inisial

			FETCH NEXT FROM db_cursor21 INTO @NoData , @Inisial , @NoAwal
		END

		CLOSE db_cursor21  
		DEALLOCATE db_cursor21 
		
END
ELSE
BEGIN
		--GET NoBuktiPotong
		DECLARE db_cursor CURSOR FOR  

			SELECT NoData , Replace(Inisial,' ','') , 0 , Replace(JenisPajak,' ',''), Replace(TahunPajak,' ','')
			FROM #PajakDS
			WHERE Inisial IS NOT NULL
			ORDER BY Inisial , KodeForm , fDS

		OPEN db_cursor  
		FETCH NEXT FROM db_cursor INTO @NoData , @Inisial , @NoAwal, @JenisPajak,@Tahun

		WHILE @@FETCH_STATUS = 0  
		BEGIN   
	
			IF @Month <> '01'
			BEGIN
				SELECT @NoAwal = MAX(CONVERT(INT,SUBSTRING(NoBuktiPotong,1,6))) 
				FROM PJK_DataGabungan
				WHERE JenisPajak = 'PPH' + @TIPENPWP
				AND TahunPajak = LEFT(@PERIODE,4)
				AND Inisial = @Inisial
				GROUP BY Inisial
			END
	
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
END

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
		CabangUtama,
		Inisial,
		fDS,
		'system',
		GETDATE(),
		'system',
		GETDATE()
FROM #PajakDS
WHERE Inisial IS NOT NULL
ORDER BY Inisial,fDs

--INSERT INTO TABLE PJK_DataGagalProses
INSERT INTO PJK_DataGagalProses
SELECT	MasaPajak,
		TahunPajak,
		Pembetulan,
		'-',
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
		CabangUtama,
		Inisial,
		fDS,
		NoDataBuktiPotongHdr,
		'system',
		GETDATE(),
		'system',
		GETDATE()
FROM #PajakDS
WHERE Inisial IS NULL
ORDER BY Inisial,fDs

--UPDATE NoBuktiPotong in TABLE PJK_BuktiPotongPajakHdr
UPDATE PJK_BuktiPotongPajakHdr 
SET NoBuktiPotong =  A.NoBuktiPotong
FROM #PajakDS A 
INNER JOIN PJK_BuktiPotongPajakHdr H
ON A.NoDataBuktiPotongHdr = CONVERT(VARCHAR(MAX),H.NoDataBuktiPotongHdr)
WHERE A.fDS = 0

--DROP TEMP TABLE
DROP TABLE #PajakDS
