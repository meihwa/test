USE UangMuka

SELECT *
FROM UM_Journal_HDR
WHERE TransactionYear = '2017'
AND SourceOfDoc = 'bbka2'
AND NumberOfDoc = 58

UPDATE UM_Journal_HDR
SET StatusFlag = 'A'
WHERE TransactionYear = '2017'
AND SourceOfDoc = 'bbka2'
AND NumberOfDoc = 58

SELECT *
FROM UM_PertanggungJawaban_Hdr
WHERE TransactionYearCabang = '2017'
AND SourceOfDocCabang = 'bbka2'
AND NumberOfDocCabang = 58

-- SELECT *
-- FROM UM_PertanggungJawaban_Hdr
-- WHERE TransactionYearPusat = '2015'
-- AND SourceOfDocPusat = 'jma26'
-- AND NumberOfDocPusat = 1557

SELECT *
FROM UM_Pengajuan
WHERE TransactionYearPusat = '2017'
AND SourceOfDocPusat = 'bbka2'
AND NumberOfDocPusat = 58
