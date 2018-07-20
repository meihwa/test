select t.NoMPP,v.BRANCH_NAME,V.BRANCH_CODE, t.Keterangan, u.KodeCabang,u.Keterangan,u.NoPengajuan
from MPP_PengajuanUM u
inner join MPP_Transaksi t
on u.NoDataMPP = convert(VARCHAR(MAX),t.NoDataMPPTransaksi)
inner join vMPP_BranchRepAll v
on v.BRANCH_CODE_REP = t.KodeCabang
where SUBSTRING(t.NoMPP,5,3) <> u.KodeCabang
and u.Keterangan = t.Keterangan




select t.NoMPP, t.KodeCabang,T.CabangInput, v.BRANCH_NAME,v.BRANCH_CODE as utama,u.KodeCabang as um,H.*
from MPP_PengajuanUM u
inner join MPP_Transaksi t
on u.NoDataMPP = convert(VARCHAR(MAX),t.NoDataMPPTransaksi)
inner join vMPP_BranchRepAll v
on v.BRANCH_CODE_REP = t.KodeCabang
INNER JOIN MPP_Journal_Hdr H
ON H.NoDataTransaction = U.NoDataPengajuan
AND H.JenisAplikasi ='UM'
where SUBSTRING(t.NoMPP,5,3) <> u.KodeCabang
and u.Keterangan <> t.Keterangan



SELECT *
from MPP_PengajuanUM u
inner join MPP_Transaksi t
on u.NoDataMPP = convert(VARCHAR(MAX),t.NoDataMPPTransaksi)
where t.KodeCabang = 248
