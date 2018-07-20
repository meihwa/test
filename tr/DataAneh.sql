select *
from MPP_Transaksi t
left join MPP_PengajuanUM u
on convert(VARCHAR(MAX),t.NoDataMPPTransaksi) = u.NoDataMPP
where NoMPP in (
'MPP/138/170010',
'MPP/362/170009',
'MPP/137/170009',
'MPP/409/170004',
'MPP/222/170031',
'MPP/383/170008',
'MPP/209/170009',
'MPP/340/170010',
'MPP/344/170004',
'MPP/500/170012',
'MPP/330/170018',
'MPP/221/170030',
'MPP/378/170012',
'MPP/510/170021',
'MPP/661/170015',
'MPP/210/170033',
'MPP/363/170063',
'MPP/209/170021',
'MPP/223/170043',
'MPP/210/170044',
'MPP/403/170022',
'MPP/214/170036',
'MPP/214/170029',
'MPP/681/170027'
)
order by StatusMPP

select *
from MPP_Transaksi
where Keterangan like '%sewa gedung%'


SELECT *
from MPP_Transaksi
WHERE NoDataMPPTransaksi in (4067,4061,4063)

SELECT *
FROM MPP_PengajuanUM
WHERE NoPengajuan ='1700006397'
OR NoDataMPP ='4067'


select *
from MPP_Transaksi
where YEAR(WaktuDibuat) =2017
and KodeCabang <> CabangInput
and CabangInput <> 101

SELECT *
FROM MPP_PengajuanUM
WHERE NoPengajuan = '1700007228'

SELECT *
from MPP_Transaksi
where Keterangan like '%stnk%'

SELECT *
FROM MPP_PengajuanUM
WHERE NoPengajuan = '1700007171'

select h.*
from MPP_Transaksi t
inner join MPP_PengajuanUM u
on convert(VARCHAR(MAX),t.NoDataMPPTransaksi) = u.NoDataMPP
inner join MPP_PertanggungJawabanUM_Hdr h
on u.NoDataPengajuan = h.NoDataPengajuan
WHERE t.KodeCabang <> u.KodeCabang
