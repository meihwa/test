
----VehicleGroup
--INSERT INTO GAMS_VehicleGroup
--SELECT KdGroup,
--	   NmGroup,
--	   MasaDepresiasi,
--	   MasaDepresiasiExt,
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.MstGroup


----VehicleSubGroup
--INSERT INTO GAMS_VehicleSubGroup
--SELECT b.NoDataGroup,
--	   a.KdSubGroup,
--	   a.NmSubGroup,
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.MstSubGroup a
--INNER JOIN GAMS_VehicleGroup b
--ON a.KdGroup = b.KdGroup  


----Insurance
--INSERT INTO GAMS_Insurance
--SELECT KdInsurance,
--	   NmInsurance,
--	   Alamat,
--	   Kota,
--	   KdPos,
--	   Telp,
--	   Fax,
--	   Email,
--	   ContactPerson,
--	   ContactPhone,
--	   Remarks,
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.MstInsurance


----Vehicle
--INSERT INTO GAMS_Vehicle
--SELECT a.KdVehicle,
--	   a.[Description],
--	   a.Merk,
--	   a.Tipe,
--	   a.Kind,
--	   a.Model,
--	   a.TahunBuat,
--	   a.TahunRakit,
--	   a.Silinder,
--	   a.Pemilik,
--	   a.Alamat,
--	   a.NoPolisi,
--	   a.Warna,
--	   a.NoRangka,
--	   a.NoMesin,
--	   a.NoBPKB,
--	   a.BahanBakar,
--	   a.FMeter,
--	   a.DigitMeter,
--	   a.KM,
--	   a.PurchaseDate,
--	   a.PurchaseValue,
--	   a.GLAccount,
--	   a.DepresiasiAccount,
--	   a.DepresiasiAccount2,
--	   a.DepreciationDate,
--	   a.PeriodeDepresiasi,
--	   a.NProsesDepresiasi,
--	   a.MasaDepresiasi,
--	   a.NilaiDepresiasi,
--	   a.NilaiVehicleAdj,
--	   a.NilaiVehicle,
--	   a.MasaDepresiasiExt,
--	   a.NilaiDepresiasiExt,
--	   a.NilaiVehicleAdjExt,
--	   a.NilaiVehicleExt,
--	   a.SellingDate,
--	   a.SellingValue,
--	   a.SellingAdmFee,
--	   a.SellingOthFee,
--	   a.FSTNK,
--	   a.NoSTNK,
--	   a.ExpSTNKDate,
--	   a.FTypeSTNK,
--	   a.PrevSTNKPemilik,
--	   a.PrevSTNKNoPolisi,
--	   a.PrevSTNKLokasi,
--	   a.FInsurance,
--	   a.NoInsurance,
--	   d.NoDataInsurance,
--	   a.FType,
--	   a.InsuranceDate,
--	   a.ExpInsuranceDate,
--	   a.InsuranceValue,
--	   a.InsurancePremi,
--	   a.FKIR,
--	   a.NoKIR,
--	   a.ExpKIRDate,
--	   a.KdLokasi,
--	   1,
--	   b.NoDataGroup,
--	   c.NoDataSubGroup,
--	   a.NoUser,
--	   a.Driver,
--	   a.Memo,
--	   a.FStatusVehicle,
--	   a.FTypeOfUse,
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.MstVehicle a
--INNER JOIN GAMS_VehicleGroup b
--ON a.KdGroup = b.KdGroup
--INNER JOIN GAMS_VehicleSubGroup c
--ON a.Jenis = c.KdSubGroup
--LEFT JOIN GAMS_Insurance d
--ON a.KdInsurance = d.KdInsurance


----Vehicle Service And Spare Parts
--INSERT INTO GAMS_ServiceAndSpareParts
--SELECT KdService,
--	   NmService,
--	   Harga,
--	   FKM,
--	   KM,
--	   FDays,
--	   [Days],
--	   'true',
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.MstListService
--UNION ALL
--SELECT KdSparePart,
--	   NmSparePart,
--	   Harga,
--	   FKM,
--	   KM,
--	   FDays,
--	   [Days],
--	   'false',
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.MstListSparePart


----Workshop
--INSERT INTO GAMS_Workshop
--SELECT KdWorkshop,
--	   NmWorkshop,
--	   '',
--	   Alamat,
--	   Kota,
--	   KdPos,
--	   Telp,
--	   Fax,
--	   Email,
--	   ContactPerson,
--	   ContactPhone,
--	   Remarks,
--	   '',
--	   'true',
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.MstWorkshop
--UNION ALL
--SELECT KdWorkshopGA,
--	   NmWorkshopGA,
--	   '',
--	   Alamat,
--	   Kota,
--	   KdPos,
--	   Telp,
--	   Fax,
--	   Email,
--	   ContactPerson,
--	   ContactPhone,
--	   Remarks,
--	   '',
--	   'false',
--	   'system',
--	   GETDATE(),
--	   'system',
--	   GETDATE()
--FROM dbweb2.GAIMFI.dbo.tblMWorkshopGA
