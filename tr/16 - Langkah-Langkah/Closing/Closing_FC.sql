USE [FuelClaim]

SELECT *
FROM FC_PencairanMPP_Hdr
WHERE NoDataPencairanMPP = 11175

SELECT *
FROM FC_Journal_Hdr
WHERE NoDataPencairanMPP = 11175

SELECT *
FROM FC_Journal_Hdr fjh
WHERE fjh.TransactionYear = '2017'
AND fjh.SourceOfDoc = 'bbka31'
AND fjh.NumberOfDoc = 8

--UNTUK UPDATE
UPDATE FC_Journal_Hdr
SET StatusFlag = 'A'
WHERE TransactionYear = '2017'
AND SourceOfDoc = 'bbka31'
AND NumberOfDoc = 8