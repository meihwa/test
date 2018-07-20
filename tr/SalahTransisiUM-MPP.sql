--Data Aneh(Harus nya ada di Jurnal Hdr dan Dtl, tapi ada di Dtl Temp, slh transisi data)
select t.*, h.*
from  MPP_Journal_Dtl_Tmp T
inner join MPP_PertanggungJawabanUM_Hdr h
on ( t.NoDataTransaction = h.NoDataPtgJwb
and t.JenisAplikasi ='UMTG')
INNER JOIN MPP_PertanggungJawabanUM_Dtl D
ON H.NoDataPtgJwb = D.NoDataPtgJwb
where T.JenisAplikasi = 'UMTG'
AND YEAR(T.WaktuDibuat) = 2017
AND T.IsStandarJournal = 1
AND h.StatusPtgJwb <> 'n'





