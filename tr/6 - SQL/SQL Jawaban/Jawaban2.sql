DECLARE @input INT, @t INT, @i INT, @j INT, @hasil varchar(10)
SET @input = 5
SET @t = (@input/ 2) + 1
SET @i =1

WHILE @i <= @input
BEGIN
	SET @hasil=''
	IF @i <= @t
	BEGIN
		SET @j =@i 
		WHILE @j>=1
		BEGIN
		SET @hasil = @hasil + '*'
		set @j =@j-1	
		END 	
	END

	
	IF @i > @t
	BEGIN 
		SET @j = @i 
		WHILE @j <= @input
		BEGIN
        set @hasil = @hasil +'*'	
		SET @j=@j +1
		END
		
	END
	set @i =@i+1
	PRINT @hasil
END
