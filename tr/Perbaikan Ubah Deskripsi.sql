select *
from MPP_Journal_Hdr h
inner join MPP_Journal_Dtl d
on d.NoDataJournal = h.NoDataJournal
where h.JenisAplikasi = 'UMTG'
AND d.IsStandarJournal =1 
AND YEAR(D.WaktuDibuat) = 2017
AND MONTH(D.WaktuDibuat) = 8
AND h.StatusFlag = 'T'

----------umtg---------------------------
SELECT  gl.[TRANS_DESC],d.*
from sqlcluster.[General Ledger].[dbo].[GL_JOURNAL_DTL] gl
INNER JOIN MPP_Journal_Hdr h
on (
h.TransactionYear = gl.[TRANS_YEAR] AND
h.SourceOfDoc = gl.[DOC_SRC] AND
h.NumberOfDoc = gl.[DOC_NO]
)
inner join MPP_Journal_Dtl d
on d.NoDataJournal = h.NoDataJournal
where h.JenisAplikasi = 'UMTG'
AND d.IsStandarJournal =1 
AND YEAR(D.WaktuDibuat) = 2017
AND MONTH(D.WaktuDibuat) = 8
AND h.StatusFlag = 'T'
and SUBSTRING(d.Deskripsi,1,4) <> 'UMTG'
and gl.[TRANS_DESC] <> SUBSTRING(d.Deskripsi,1,50)


----um---------------
SELECT  gl.[TRANS_DESC],d.*
from sqlcluster.[General Ledger].[dbo].[GL_JOURNAL_DTL] gl
inner join MPP_Journal_Hdr h
on CONVERT(VARCHAR(MAX),gl.[TRANS_YEAR])+'-'+gl.[DOC_SRC]+'-'+CONVERT(VARCHAR(MAX),gl.[DOC_NO]) = CONVERT(VARCHAR(MAX),H.TransactionYear)+'-'+ H.SourceOfDoc+'-' + CONVERT(VARCHAR(MAX),H.NumberOfDoc)
inner join MPP_Journal_Dtl d
on h.NoDataJournal = d.NoDataJournal
INNER JOIN MPP_PengajuanUM u
on h.NoDataTransaction = u.NoDataPengajuan
and h.JenisAplikasi = 'UM'
where h.JenisAplikasi ='UM'
AND MONTH(d.WaktuDibuat) = 8
AND YEAR(d.WaktuDibuat) =2017
and h.StatusFlag = 'T'
and gl.TRANS_DESC <>  SUBSTRING(d.Deskripsi,1,50)