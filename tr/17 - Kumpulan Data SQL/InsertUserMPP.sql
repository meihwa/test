--K1010001

DECLARE @NoDataCostCenter INT
        ,@NamaUser varchar(50)
        ,@BranchCode numeric(3,0)
        ,@NoHP varchar(50)
        ,@Jabatan varchar(50)
        ,@Golongan varchar(50)
        ,@Bank varchar(50)
        ,@NoRekening varchar(50)
        ,@AtasNama varchar(50)
        ,@EmailInternal varchar(50)
        ,@EmailExternal varchar(50)
        ,@fAktif BIT
        ,@DibuatOleh varchar(50)
        ,@DiubahOleh varchar(50)
        ,@WaktuDibuat datetime
        ,@WaktuDiubah datetime
		, @count as int

set @count = 0

DECLARE db_cursor CURSOR FOR 

SELECT  45 AS NoDataCostCenter,
		[NAMA VENDOR] AS NamaUser,
		Cabang AS BranchCode,
		0 AS NoHP,
		'Vendor' AS Jabatan,
		'Vendor' AS Golongan,
		[NAMA BANK] AS Bank,
		NOMORREKENING AS NoRekening,
		[NAMA VENDOR] AS AtasNama,
		'' AS EmailInternal,
		'' AS EmailExternal,
		1 AS fAktif,
		'system' AS DibuatOleh,
		'system' AS DiubahOleh,
		GETDATE() AS WaktuDibuat,
		GETDATE() AS WaktuDiubah
from User2017

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO  @NoDataCostCenter ,@NamaUser ,@BranchCode ,@NoHP ,@Jabatan ,@Golongan ,@Bank,@NoRekening ,@AtasNama ,@EmailInternal ,@EmailExternal ,@fAktif  ,@DibuatOleh ,@DiubahOleh  ,@WaktuDibuat, @WaktuDiubah

WHILE @@FETCH_STATUS = 0  
BEGIN  
	
	set @count = @count + 1
	
	--SELECT @NoDataCostCenter
	--	   ,CASE WHEN LEN(@count) = 1 THEN 'K101000' + CONVERT(varchar(max), @count) 
	--			 WHEN LEN(@count) = 2 THEN 'K10100' + CONVERT(varchar(max), @count) 
	--			 WHEN LEN(@count) = 3 THEN 'K1010' + CONVERT(varchar(max), @count) 
	--		END
 --          ,@NamaUser
 --          ,@BranchCode
 --          ,@NoHP
 --          ,@Jabatan
 --          ,@Golongan
 --          ,@Bank
 --          ,@NoRekening
 --          ,@AtasNama
 --          ,@EmailInternal
 --          ,@EmailExternal
 --          ,@fAktif
 --          ,@DibuatOleh
 --          ,@DiubahOleh
 --          ,@WaktuDibuat
	--	   , @WaktuDiubah

	INSERT INTO [dbo].[MPP_User]
           ([NoDataCostCenter]
           ,[NIK]
           ,[NamaUser]
           ,[BranchCode]
           ,[NoHP]
           ,[Jabatan]
           ,[Golongan]
           ,[Bank]
           ,[NoRekening]
           ,[AtasNama]
           ,[EmailInternal]
           ,[EmailExternal]
           ,[fAktif]
           ,[DibuatOleh]
           ,[DiubahOleh]
           ,[WaktuDibuat]
           ,[WaktuDiubah])
     VALUES ( @NoDataCostCenter
		   ,CASE WHEN LEN(@count) = 1 THEN 'K101000' + CONVERT(varchar(max), @count) 
				 WHEN LEN(@count) = 2 THEN 'K10100' + CONVERT(varchar(max), @count) 
				 WHEN LEN(@count) = 3 THEN 'K1010' + CONVERT(varchar(max), @count) 
			END
           ,@NamaUser
           ,@BranchCode
           ,@NoHP
           ,@Jabatan
           ,@Golongan
           ,@Bank
           ,@NoRekening
           ,@AtasNama
           ,@EmailInternal
           ,@EmailExternal
           ,@fAktif
           ,@DibuatOleh
           ,@DiubahOleh
           ,@WaktuDibuat
		   ,@WaktuDiubah)

	FETCH NEXT FROM db_cursor INTO  @NoDataCostCenter
           ,@NamaUser
           ,@BranchCode
           ,@NoHP
           ,@Jabatan
           ,@Golongan
           ,@Bank
           ,@NoRekening
           ,@AtasNama
           ,@EmailInternal
           ,@EmailExternal
           ,@fAktif
           ,@DibuatOleh
           ,@DiubahOleh
           ,@WaktuDibuat
		   , @WaktuDiubah
END


CLOSE db_cursor  
DEALLOCATE db_cursor 


