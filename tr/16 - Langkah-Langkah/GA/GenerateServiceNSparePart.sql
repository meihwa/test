/* SERVICE */
USE GAIMFI

DECLARE	@KdService VARCHAR(5),
	@NmService VARCHAR(50),
	@Harga MONEY ,
	@FKM TINYINT,
	@KM MONEY,
	@FDays TINYINT,
	@Days MONEY

DECLARE @KdSubGroup VARCHAR(5)	
	
	
DECLARE curService CURSOR FOR
SELECT KdService,NmService,Harga,FKM,KM,FDays,FDays
FROM MstListService

OPEN curService
FETCH NEXT FROM curService
INTO @KdService,@NmService,@Harga,@FKM,@KM,@FDays,@FDays

WHILE @@FETCH_STATUS = 0
BEGIN
	
		
	DECLARE curSubGroup CURSOR FOR
	SELECT KdSubGroup
	FROM MstSubGroup
	
	OPEN curSubGroup
	FETCH NEXT FROM curSubGroup
	INTO @KdSubGroup
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS(SELECT * FROM MstService WHERE KdSubGroup = @KdSubGroup AND KdService = @KdService)		
		BEGIN
			INSERT INTO MstService
			(
				KdSubGroup,
				KdService,
				NmService,
				Harga,
				FKM,
				KM,
				FDays,
				Days,
				FTime,
				Remarks
			)
			VALUES
			(
				@KdSubGroup/* KdSubGroup	*/,
				@KdService/* KdService	*/,
				@NmService/* NmService	*/,
				@Harga/* Harga	*/,
				@FKM/* FKM	*/,
				@KM/* KM	*/,
				@FDays/* FDays	*/,
				@Days/* Days	*/,
				0/* FTime	*/,
				''/* Remarks	*/
			)
		END
	
	
		FETCH NEXT FROM curSubGroup
		INTO @KdSubGroup
	END
	
	CLOSE curSubGroup
	DEALLOCATE curSubGroup
	
	FETCH NEXT FROM curService
	INTO @KdService,@NmService,@Harga,@FKM,@KM,@FDays,@FDays
	
END

CLOSE curService
DEALLOCATE curService



/* SPARE PART */


DECLARE	@KdSparePart VARCHAR(5),
	@NmSparePart VARCHAR(50)

DECLARE curSparePart CURSOR FOR
SELECT KdSparePart,NmSparePart,Harga,FKM,KM,FDays,FDays
FROM MstListSparePart

OPEN curSparePart
FETCH NEXT FROM curSparePart
INTO @KdSparePart,@NmSparePart,@Harga,@FKM,@KM,@FDays,@FDays

WHILE @@FETCH_STATUS = 0
BEGIN		
	DECLARE curSubGroup CURSOR FOR
	SELECT KdSubGroup
	FROM MstSubGroup
	
	OPEN curSubGroup
	FETCH NEXT FROM curSubGroup
	INTO @KdSubGroup
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS(SELECT * FROM MstSparePart WHERE KdSubGroup = @KdSubGroup AND KdSparePart = @KdSparePart)		
		BEGIN
			INSERT INTO MstSparePart
			(
				KdSubGroup,
				KdSparePart,
				NmSparePart,
				Harga,
				FKM,
				KM,
				FDays,
				Days,
				FTime,
				Remarks
			)
			VALUES
			(
				@KdSubGroup/* KdSubGroup	*/,
				@KdSparePart/* KdSparePart	*/,
				@NmSparePart/* NmSparePart	*/,
				@Harga/* Harga	*/,
				@FKM/* FKM	*/,
				@KM/* KM	*/,
				@FDays/* FDays	*/,
				@Days/* Days	*/,
				0/* FTime	*/,
				''/* Remarks	*/
			)	
			
		END
	
	
		FETCH NEXT FROM curSubGroup
		INTO @KdSubGroup
	END
	
	CLOSE curSubGroup
	DEALLOCATE curSubGroup
	
	FETCH NEXT FROM curSparePart
	INTO @KdSparePart,@NmSparePart,@Harga,@FKM,@KM,@FDays,@FDays
	
END

CLOSE curSparePart
DEALLOCATE curSparePart