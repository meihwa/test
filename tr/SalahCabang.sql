SELECT *
from MPP_PengajuanUM
where NoDataMPP in (
select convert(varchar,NoDataMPPTransaksi)
from MPP_Transaksi
where YEAR(WaktuDibuat) =2017
and KodeCabang <> CabangInput
and CabangInput <> 101
and StatusMPP = 'D'
)

