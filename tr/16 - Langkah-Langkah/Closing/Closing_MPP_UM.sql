USE [MPP]

SELECT *
from MPP_Journal_Hdr
WHERE TransactionYear ='2018'
AND SourceOfDoc = 'BBKA66'
AND NumberOfDoc = 1275

-- Cek apa transaksi tsb punya sumdok lain
SELECT *
FROM MPP_Journal_Hdr
WHERE NoDataTransaction = 76520
AND JenisAplikasi = 'UMTG'

-- Update Status Flag di Jurnal
UPDATE MPP_Journal_Hdr
SET StatusFlag = 'A'
WHERE NoDataJournal = 264933

---------------------------------------------UMTG------------------------------------------------------------------
-- Cek No PJ
SELECT *
FROM MPP_PertanggungJawabanUM_Hdr
--where NoPtgJwb = 't170009269'
WHERE NoDataPtgJwb = 72524

----------------------------------------------UM-----------------------------------------------------------------
-- Cek apakah UM tsb punya PJ
SELECT *
FROM MPP_PertanggungJawabanUM_Hdr
WHERE NoDataPengajuan = 73810

-- Cek No Pengajuannya
SELECT *
FROM MPP_PengajuanUM
WHERE NoDataPengajuan = 73810


-----------------------------------------------MPP------------------------------------------------------------------
--Cek No MPP
SELECT *
FROM MPP_Pencairan_Hdr
WHERE NoDataPencairanHdr = 15586

SELECT *
FROM MPP_Transaksi
where NoDataMPPTransaksi = 15586