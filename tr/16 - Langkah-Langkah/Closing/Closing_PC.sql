USE [PettyCash]

SELECT *
FROM PC_Journal_HDR
WHERE TransactionYear = '2016'
AND SourceOfDoc = 'BBKA12'
AND NumberOfDoc = 341

--SELECT * 
--FROM PC_Journal_DTL pjd
--WHERE pjd.NoDataJournal =102297
--
--DELETE FROM PC_Journal_DTL
--WHERE NoDataJournal = 102297
--
--DELETE FROM PC_Journal_HDR
--WHERE NoDataJournal = 102297

-- update PC_Journal_HDR
-- SET StatusFlag = 'A'
-- WHERE TransactionYear = '2014'
-- AND SourceOfDoc = 'bbka23'
-- AND NumberOfDoc = 587

SELECT *
FROM PC_Journal_HDR
WHERE TransactionYear = '2016'
AND SourceOfDoc = 'BBKA12'
AND NumberOfDoc = 341

SELECT *
FROM PC_Pencairan_Hdr
WHERE TransactionYearPusat = '2016'
AND SourceOfDocPusat = 'BBKA12'
AND NumberOfDocPusat = 341
