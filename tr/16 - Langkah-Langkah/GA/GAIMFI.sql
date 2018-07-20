--Asset


SELECT TM.KdCabang, TM.NmCabang,MIA.KdInventory, MIA.Barcode,  MIA.NmAssets, MIA.TglReceive, MIA.Price, MIA.NilaiAssets
FROM MstInventoryAssets mia 
INNER JOIN MstGedung mg ON mg.KdGedung = mia.KdGedung
inner JOIN tblMCabang tm ON tm.KdCabang = mg.KdCabang

WHERE mia.FStatus NOT IN( 8, 11)

 --AND mia.TglReceive BETWEEN '01/01/2012' AND '10/08/2015' 
ORDER BY tm.KdCabang, mia.Barcode


--maintenance kendaraan


SELECT mv.KdVehicle,

tmas.NoReg,
d.KdCabang,  
d.NmCabang,
tmas.TglReg,
tmas.TglInvoice,
mv.Merk, 
mv.Tipe,
mv.[Description],
mv.NoPolisi, 
isnull(tmas.GrandTotal,0) AS [Total Biaya Service]
FROM MstVehicle mv 
INNER JOIN tblMCabang D ON mv.KdLokasi = d.KdCabang
left JOIN 
	(SELECT tma.NoReg, tma.KdVehicle, SUM(tma.GrandTotal) AS  GrandTotal, tma.TglReg , tma.TglInvoice	
	 from TrMaintenanceActual tma 
	 GROUP BY tma.KdVehicle , tma.TglReg, tma.TglInvoice, tma.NoReg
	) as tmas ON mv.KdVehicle = tmas.KdVehicle

WHERE mv.SellingDate IS NULL AND tmas.TglReg BETWEEN '10/01/2014' AND '10/09/2015' 

-- r2
--AND kind NOT like '%motor%' 
--AND model NOT LIKE '%motor%'

ORDER BY d.KdCabang ,mv.KdVehicle


