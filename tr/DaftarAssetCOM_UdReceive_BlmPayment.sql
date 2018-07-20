SELECT mi.Barcode,
	   mi.NmAssets,
	   tm.KdCabang,
	   tm.NmCabang,
	   mi.NoReceive,
	   mi.TglReceive,
	   mi.Price,
	   ms.NmSupplier
	   
FROM MstInventoryAssets mi INNER JOIN MstGedung mg
	 ON mi.KdGedung = mg.KdGedung
						   INNER JOIN tblMCabang tm
	 ON mg.KdCabang = tm.KdCabang
						   INNER JOIN TrReceive tr
	 ON mi.NoReceive = tr.NoReg
						   INNER JOIN MstSupplier ms
	 ON tr.KdSupplier = ms.KdSupplier
						   
WHERE mi.NoPayment =''
AND mi.Price >= 1000000
AND mi.KdInventory like '%COM%'