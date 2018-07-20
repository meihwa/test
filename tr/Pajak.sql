--DROP TABLE #PajakDS

DECLARE @PERIODE AS NUMERIC(6,0),
@TIPENPWP AS NCHAR(2),
@NoDataJenisPajak as int,
@NPWP_PP AS VARCHAR(15),
@NoData INT

SET @PERIODE = 201709
SET @TIPENPWP = '23'

--CREATE TEMP TABLE
CREATE TABLE #PajakDS (
	[NoData] [int] IDENTITY(1,1) NOT NULL,
	[MasaPajak] [varchar](2) NULL,
	[TahunPajak] [varchar](4) NULL,
	[Pembetulan] [varchar](10) NULL,
	[NoBuktiPotong] [varchar](30) NULL,
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
	[KodeJasa] [varchar](5) NULL,	
)

--INSERT USP_KIRIM_FILE_PPH TO TEMP TABLE
INSERT INTO #PajakDS
EXEC SQLCLUSTER.DS.dbo.USP_KIRIM_FILE_PPH @PERIODE,@TIPENPWP,'ALL','0'

--ADD COLUMNS IN TEMP TABLE
ALTER TABLE #PajakDS
ADD [JenisPajak] [varchar](50) NULL,
	[KodeCabang] [numeric](3, 0) NULL,
	[Inisial] [varchar](20) NULL,
	[fDS] [bit] NULL ;


-- AND GET NoDataJenisPajak
SELECT @NoDataJenisPajak = NoDataJenisPajak
FROM PJK_JenisPajak
WHERE JenisPajak LIKE '%' + @TIPENPWP
AND fAktif = 1


--UPDATE COLUMN JenisPajak AND fDS
UPDATE #PajakDS
SET JenisPajak = @TIPENPWP,
fDS = 'TRUE'


--UPDATE COLUMNS KodeCabang AND Inisial WITH CURSOR
DECLARE db_cursor CURSOR FOR  

	SELECT NoData, NPWPPemotong
	FROM #PajakDS

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @NoData, @NPWP_PP

WHILE @@FETCH_STATUS = 0  
BEGIN   
	
	UPDATE #PajakDS
	SET KodeCabang = D.KodeCabang,
		Inisial = 'IMFI-' +  H.Inisial	
	FROM PJK_PemotongPajak P
	INNER JOIN PJK_InisialCabangDtl D
	ON P.KodeCabang = D.KodeCabang
	INNER JOIN PJK_InisialCabangHdr H
	ON D.NoDataInisialHdr = H.NoDataInisialHdr
	WHERE P.NPWP = @NPWP_PP
	AND NoData = @NoData
	
	FETCH NEXT FROM db_cursor INTO @NoData, @NPWP_PP   
END   

CLOSE db_cursor  
DEALLOCATE db_cursor 


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
		J.JenisPajak,
		PP.KodeCabang,
		'IMFI-' + IH.Inisial AS Inisial,
		'0' AS fDS
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


SELECT	*
from #PajakDS
ORDER BY Inisial

