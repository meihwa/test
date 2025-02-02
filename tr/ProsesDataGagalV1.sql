USE [Pajak20171012]
GO
/****** Object:  StoredProcedure [dbo].[USP_ProsesDataGagal]    Script Date: 8/11/2017 10:16:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC USP_ProsesDataGagal '21'

ALTER PROC [dbo].[USP_ProsesDataGagal]
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
		@Year AS VARCHAR(MAX)

SET @InisialSesudah = ''
SET @Count = 0


--UPDATE COLUMNS KodeCabang AND Inisial 
UPDATE PJK_DataGagalProses
SET KodeCabang = P.KodeCabang,
	Inisial = 'IMFI-' +  H.Inisial	
FROM PJK_PemotongPajak P
INNER JOIN PJK_InisialCabangDtl D
ON P.KodeCabang = D.KodeCabang
INNER JOIN PJK_InisialCabangHdr H
ON D.NoDataInisialHdr = H.NoDataInisialHdr
WHERE NPWPPemotong = P.NPWP

--GET PERIODE
SELECT @PERIODE = ( CurrentYearPeriod * 100 ) + CurrentMonthPeriod
FROM PJK_MasaPajak

--GET MONTH AND YEAR FOR PPH 21
SELECT	@Year =  Right(CurrentYearPeriod,2) ,
		@Month = CASE WHEN LEN(CurrentMonthPeriod) = 1  THEN '0' + CONVERT(VARCHAR(MAX),CurrentMonthPeriod)
				 ELSE CONVERT(VARCHAR(MAX),CurrentMonthPeriod)
				 END
FROM PJK_MasaPajak

IF (@TIPENPWP = '21')
BEGIN
		--GET NoBuktiPotong
		DECLARE db_cursor21 CURSOR FOR  

			SELECT NoData , 0 
			FROM #PajakDS
			WHERE Inisial IS NOT NULL
			ORDER BY Inisial, fDS 

		OPEN db_cursor21  
		FETCH NEXT FROM db_cursor21 INTO @NoData , @NoAwal

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

			SELECT @NoAwal = MAX(CONVERT(INT,RIGHT(NoBuktiPotong,7))) 
			FROM PJK_DataGabungan
			WHERE JenisPajak = 'PPH' + @TIPENPWP

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
		
			SET @Count = @Count + 1
			
			FETCH NEXT FROM db_cursor21 INTO @NoData , @Inisial , @NoAwal
		END

		CLOSE db_cursor21  
		DEALLOCATE db_cursor21 
		
END
ELSE
BEGIN
		--GET NoBuktiPotong
		DECLARE db_cursor CURSOR FOR  

			SELECT NoDataGagal , Replace(Inisial,' ','') , 0 , Replace(JenisPajak,' ',''), Replace(TahunPajak,' ','')
			FROM PJK_DataGagalProses
			WHERE Inisial IS NOT NULL
			ORDER BY Inisial , KodeForm , fDS

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

				UPDATE PJK_DataGagalProses
				SET NoBuktiPotong = @Butpot
				WHERE NoDataGagal = @NoData
			END

			ELSE
			BEGIN
		
				IF @NoAwal = 0
				BEGIN
			
					SET @Count = 1
			
					UPDATE PJK_DataGagalProses
					SET NoBuktiPotong = '00000' + CONVERT(VARCHAR(MAX),@Count) + '/' + @JenisPajak + '/' + @Inisial + '/' + @Tahun
					WHERE NoDataGagal = @NoData
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

					UPDATE PJK_DataGagalProses
					SET NoBuktiPotong = @Butpot
					WHERE NoDataGagal = @NoData
				END
			END
		
			SET @Count = @Count + 1
			SET @InisialSesudah = @Inisial

			FETCH NEXT FROM db_cursor INTO @NoData , @Inisial , @NoAwal, @JenisPajak,@Tahun
		END

		CLOSE db_cursor  
		DEALLOCATE db_cursor 
END


--UPDATE NoBuktiPotong in TABLE PJK_BuktiPotongPajakHdr
UPDATE PJK_BuktiPotongPajakHdr 
SET NoBuktiPotong =  A.NoBuktiPotong
FROM PJK_DataGagalProses A 
INNER JOIN PJK_BuktiPotongPajakHdr H
ON A.NoDataBuktiPotongHdr = CONVERT(VARCHAR(MAX),H.NoDataBuktiPotongHdr)
WHERE A.fDS = 0


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
FROM PJK_DataGagalProses
WHERE Inisial IS NOT NULL
ORDER BY Inisial

--DELETE DATA FROM PJK_DataGagalProses
DELETE FROM PJK_DataGagalProses
WHERE NoBuktiPotong <> '-'


