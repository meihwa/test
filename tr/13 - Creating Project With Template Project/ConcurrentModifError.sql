CREATE  PROCEDURE [dbo].[ConcurrentModificationError] 
AS

	RAISERROR('CONCURRENT_MODIFICATION_ERROR',16,1)