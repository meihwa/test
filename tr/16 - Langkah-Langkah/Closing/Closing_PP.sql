USE [Prepaid]

SELECT *
FROM PP_Journal_Hdr pjh
WHERE  pjh.TransactionYear = '2016'
AND pjh.SourceOfDoc = 'BBKA96'
AND pjh.NumberOfDoc = 1

UPDATE PP_Journal_Hdr 
SET StatusFlag = 'A'
WHERE TransactionYear = '2016'
AND SourceOfDoc = 'BBKA96'
AND NumberOfDoc = 1

SELECT *
FROM PP_Prepaid pp
WHERE pp.TransactionYearPusat = '2016'
AND pp.SourceOfDocPusat = 'BBKA96'
AND pp.NumberOfDocPusat = 1