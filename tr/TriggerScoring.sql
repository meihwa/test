USE [ApprovalSystem]
GO
/****** Object:  Trigger [dbo].[TI_UPDATE_STATUS_SCORING]    Script Date: 12/15/2015 08:51:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TI_UPDATE_STATUS_SCORING]
ON [dbo].[APS_ApprovalTransaction]
AFTER UPDATE
AS 

Declare @InsertedStatus char(1)
--		,@NoDataApprovalTypeVersion INT
		,@ApprovalTypeId varchar(50)
		,@NoDataRegister INT
		,@NoDataDetailScoringLevel INT
		

DECLARE CekStatus CURSOR FOR
SELECT aat.ApprovalTypeId , i.Status , dbo.SPLIT(i.Field1,'.',1), dbo.SPLIT(i.Field1,'.',2) 
FROM INSERTED i 
INNER JOIN dbo.APS_ApprovalTypeVersion aatv ON aatv.NoDataApprovalTypeVersion = i.NoDataApprovalTypeVersion
INNER JOIN APS_ApprovalType aat ON aat.NoDataApprovalType = aatv.NoDataApprovalType

OPEN CekStatus;
FETCH NEXT FROM CekStatus INTO @ApprovalTypeId ,@InsertedStatus ,@NoDataRegister,@NoDataDetailScoringLevel;

WHILE @@FETCH_STATUS=0
BEGIN
	IF UPDATE(Status)
	BEGIN
		IF @ApprovalTypeId like '%SCORING%'
		BEGIN
			
			IF @InsertedStatus='A'
				BEGIN
					UPDATE Scoring.dbo.SCR_ScoringDetailLevel
					SET Status = 'A'
					WHERE NoDataDetailScoringLevel = @NoDataDetailScoringLevel

					IF EXISTS (SELECT * 
								FROM Scoring.dbo.SCR_ScoringDetailLevel 
								WHERE NoDataRegister=@NoDataRegister AND NoDataDetailScoringLevel>@NoDataDetailScoringLevel)
					BEGIN
						UPDATE Scoring.dbo.SCR_ScoringDetailLevel
						SET Status = 'C'
						WHERE NoDataRegister = @NoDataRegister
						AND NoDataDetailScoringLevel = @NoDataDetailScoringLevel+1
					END
					ELSE
						UPDATE Scoring.dbo.SCR_ScoringHeader
						SET RegisterScoringStatus = 'A'
						WHERE NoDataRegister = @NoDataRegister
				END
			
					ELSE IF @InsertedStatus = 'R'
				BEGIN
					UPDATE Scoring.dbo.SCR_ScoringDetailLevel
					SET Status = 'R'
					WHERE NoDataDetailScoringLevel = @NoDataDetailScoringLevel

					UPDATE Scoring.dbo.SCR_ScoringHeader
					SET RegisterScoringStatus = 'R'
					WHERE NoDataRegister = @NoDataRegister

					IF EXISTS (SELECT * 
								FROM Scoring.dbo.SCR_ScoringDetailLevel 
								WHERE NoDataRegister=@NoDataRegister AND NoDataDetailScoringLevel>@NoDataDetailScoringLevel)
					BEGIN
						UPDATE Scoring.dbo.SCR_ScoringDetailLevel
						SET Status = 'D'
						WHERE NoDataRegister = @NoDataRegister
						AND NoDataDetailScoringLevel > @NoDataDetailScoringLevel	
					END
				END
		END 

	END
	
	FETCH NEXT FROM CekStatus INTO @ApprovalTypeId ,@InsertedStatus ,@NoDataRegister,@NoDataDetailScoringLevel;
END
