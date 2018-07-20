USE Deposito

SELECT *
FROM DPST_Journal_Hdr
WHERE TransactionYear = '2017'
AND SourceOfDoc = 'BBKA5'
AND NumberOfDoc = 5

UPDATE DPST_Journal_Hdr
SET StatusFlag = 'A'
WHERE TransactionYear = '2017'
AND SourceOfDoc = 'BBKA5'
AND NumberOfDoc = 5

SELECT *
FROM DPST_PenerimaanBunga
WHERE NoDataPenerimaanBunga   = 218
