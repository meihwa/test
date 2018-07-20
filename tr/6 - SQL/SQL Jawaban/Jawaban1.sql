DECLARE @angkasatu INT, @angkadua INT, @i INT, @b INT, @hasil VARCHAR(10)
SET @angkasatu = 3
SET @angkadua = 5

set @i = @angkadua

WHILE @i >=  1
	BEGIN
	SET @hasil=''
	DECLARE @z INT
	SET @z = @i
	SET @b = @angkasatu
	
	WHILE @z >= 1
	BEGIN
		IF (@b%2) = 1
		BEGIN
			set @hasil = @hasil + CONVERT(VARCHAR(10),@b)
				
		END	
		
		SET @b = @b + 2
		SET @z = @z - 1	
		
	END
	
	SET @i = @i - 1
	PRINT @hasil
END

