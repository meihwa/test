DECLARE @tenor DECIMAL(18,5), @pokok DECIMAL(18,5), @bungaefektif decimal(18,5), @sisa decimal(18,5)
SELECT @tenor = 12 , @pokok = 10000000, @bungaefektif = 0.09000

DECLARE @bulan int, @AngsPokok decimal(18,5), @bungapersen decimal(18,5), @AngsBunga decimal(18,5), @AngsTotal decimal(18,5)

PRINT 'Bulan' + char(9) + 'Total Angs'+ char(9) +'Pokok Angs'+ char(9) +'Bunga'+ char(9) +'Bunga(persen)'+ char(9) +'Sisa Pokok'

DECLARE @i int
SET @bulan = 12
SET @i =  0

DECLARE @SumAngsTotal decimal(18,5), @SumAngsPokok decimal(18,5), @SumAngsBunga decimal(18,5)
SET @SumAngsTotal = 0 
SET @SumAngsPokok =0
SET @SumAngsBunga = 0

While @i <= @bulan
begin

	if @i = 0
		begin
			SET @AngsTotal = 0
			SET @AngsPokok = 0
			SET @AngsBunga = 0
			SET @bungapersen = @bungaefektif
			SET @sisa = @pokok
		end
		
	DECLARE @pokok1 decimal(18,5), @sisa1 decimal(18,5)
	if @i > 0
		begin
			SET @AngsPokok = @pokok /@tenor
			SET @bungapersen = @bungaefektif /12
			SET @AngsBunga = (@bungaefektif / 12) * @sisa1
			SET @AngsTotal = @AngsPokok + @AngsBunga
			SET @sisa = @pokok1 - @AngsPokok
		end

		SET @pokok1 = @sisa
		SET @sisa1 = @sisa
		
		
		SET @SumAngsPokok =@SumAngsPokok + @AngsPokok
		SET  @SumAngsTotal = @SumAngsTotal + @AngsTotal
		SET @SumAngsBunga = @SumAngsBunga + @AngsBunga

		PRINT cast(@i as varchar) +char(9) + char(9) + cast(floor(@AngsTotal) as varchar) + char(9) + char(9) +  
		cast(floor(@AngsPokok) as varchar) +char(9) + char(9) + cast(floor(@AngsBunga) as varchar) + char(9) +char(9) + 
		cast(@bungapersen as varchar) + char(9) +char(9) + cast(floor(@sisa) as varchar)

		

	SET @i = @i +1


end
PRINT char(9) +char(9) +cast(CEILING(@SumAngsTotal) as varchar) + char(9) + cast(ceiling(@SumAngsPokok) as varchar) +char(9)+ cast(ceiling(@SumAngsBunga) as varchar)