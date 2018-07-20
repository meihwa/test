begin tran
UPDATE PC_Journal_DTL
SET Description =  convert(VARCHAR(MAX), h.BranchCode) + ' ' + d.Description + ' ' + p.PencairanNumber

SELECT d.*
from PC_Journal_HDR h inner join PC_Journal_DTL d
on h.NoDataJournal =d.NoDataJournal 
inner JOIN PC_Pencairan_Hdr p
on ( p.TransactionYearPusat = h.TransactionYear
AND p.SourceOfDocPusat = h.SourceOfDoc
AND p.NumberOfDocPusat = h.NumberOfDoc)
OR ( p.TransactionYearCabang = h.TransactionYear
AND p.SourceOfDocCabang = h.SourceOfDoc
AND p.NumberOfDocCabang = h.NumberOfDoc)
where YEAR(p.WaktuDibuat) = 2017
and MONTH(p.WaktuDibuat) = 8

COMMIT

ROLLBACK

update PC_Journal_DTL_Temp
set Description = convert(VARCHAR(MAX), t.BranchCode) + ' ' + t.Description + ' ' + h.PencairanNumber
SELECT *
from PC_Journal_DTL_Temp t
inner JOIN PC_Pencairan_Hdr h
on h.NoDataPencairan = t.NoDataPencairan
where YEAR(h.WaktuDibuat) = 2017




SELECT *
FROM PC_Journal_HDR h inner join PC_Journal_DTL d
on h.NoDataJournal =d.NoDataJournal 
inner JOIN PC_Pencairan_Hdr p
on ( p.TransactionYearPusat = h.TransactionYear
AND p.SourceOfDocPusat = h.SourceOfDoc
AND p.NumberOfDocPusat = h.NumberOfDoc)
OR ( p.TransactionYearCabang = h.TransactionYear
AND p.SourceOfDocCabang = h.SourceOfDoc
AND p.NumberOfDocCabang = h.NumberOfDoc)
where YEAR(p.WaktuDibuat) = 2017
and MONTH(p.WaktuDibuat) = 8




--Tot 581
--P : 579
--C : 573
-- 1152
SELECT COUNT(p.SourceOfDocPusat)
from PC_Pencairan_Hdr p
where YEAR(p.WaktuDibuat) = 2017
and MONTH(p.WaktuDibuat) = 8

SELECT COUNT(p.SourceOfDocCabang)
from PC_Pencairan_Hdr p
where YEAR(p.WaktuDibuat) = 2017
and MONTH(p.WaktuDibuat) = 8