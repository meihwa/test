UPDATE MPP_Journal_Dtl
SET Deskripsi = REPLACE(REPLACE(Deskripsi,'UM ',''),'-','UM')
WHERE NoDataJournal IN (
							select D.NoDataJournal
							from MPP_Journal_Hdr h 
							inner join MPP_Journal_Dtl d
							on h.NoDataJournal = d.NoDataJournal
							INNER JOIN MPP_PengajuanUM u
							on h.NoDataTransaction = u.NoDataPengajuan
							and h.JenisAplikasi = 'UM'
							where h.JenisAplikasi ='UM'
							AND  SUBSTRING(D.Deskripsi,1,2) = 'UM'
							AND MONTH(U.WaktuDibuat) = 8
							AND YEAR(U.WaktuDibuat) =2017
							ORDER BY d.NoDataJournal
						)

SELECT REPLACE(REPLACE(t.Deskripsi,'UM ',''),'-','UM'),t.*
FROM MPP_Journal_Dtl_Tmp t 
INNER JOIN MPP_PengajuanUM p
on t.NoDataTransaction = p.NoDataPengajuan
WHERE JenisAplikasi = 'UM'
AND YEAR(p.WaktuDibuat) = 2017
and MONTH(p.WaktuDibuat) = 8

select REPLACE(REPLACE(D.Deskripsi,'UMTG ',''),'-','UMTG'),D.*
from MPP_Journal_Hdr h
inner join MPP_Journal_Dtl d
on h.NoDataJournal = d.NoDataJournal
INNER JOIN MPP_PertanggungJawabanUM_Hdr p
on p.NoDataPtgJwb = h.NoDataTransaction
and h.JenisAplikasi = 'UMTG'
where h.JenisAplikasi = 'UMTG'
AND MONTH(P.WaktuDibuat) = 8
AND YEAR(P.WaktuDibuat) =2017
AND  SUBSTRING(D.Deskripsi,1,4) = 'UMTG'
ORDER BY d.NoDataJournal

SELECT REPLACE(REPLACE(t.Deskripsi,'UMTG ',''),'-','UMTG'),t.*
FROM MPP_Journal_Dtl_Tmp t 
INNER JOIN MPP_PertanggungJawabanUM_Hdr p
on t.NoDataTransaction = p.NoDataPtgJwb
WHERE JenisAplikasi = 'UMTG'
AND YEAR(p.WaktuDibuat) = 2017
and MONTH(p.WaktuDibuat) = 8

