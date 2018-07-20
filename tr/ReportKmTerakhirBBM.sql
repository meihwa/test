SELECT	fkm.NoPolisi, 
		fkm.Kendaraan,  
		fpm.Nama, 
		fpm.BranchCode, 
		max(fm.KMAkhir) AS [KM Akhir], 
		left(fm.Periode,2) + ' - ' + right(fm.Periode,4) AS Periode
		--convert(varchar(max),convert(datetime,RIGHT(fm.Periode,4) +  left(fm.Periode,2)  + '01' ),112) 
FROM dbo.FC_MPP fm
INNER JOIN dbo.FC_Klaim_Hdr fkh ON fkh.NoDataKlaim = fm.NoDataKlaim
INNER JOIN dbo.FC_PemakaiMaster fpm ON fpm.NoDataPemakai = fkh.NoDataPemakai
INNER JOIN dbo.FC_KendaraanMaster fkm ON fkm.NoDataKendaraan = fpm.NoDataKendaraan
INNER JOIN dbo.FC_TipeKendaraanMaster ftkm ON ftkm.NoDataTipeKendaraan = fkm.NoDataTipeKendaraan


WHERE convert(varchar(max),convert(datetime,RIGHT(fm.Periode,4) +  left(fm.Periode,2)  + '01' ),112) > '20170631' 
AND ftkm.Keterangan <> 'Motor'
GROUP BY fkm.NoPolisi, fkm.Kendaraan,  fpm.Nama, fpm.BranchCode, fm.Periode
ORDER by fpm.Nama,  RIGHT(fm.Periode,4) , left(fm.Periode,2)  ASC	