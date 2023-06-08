USE [Database]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: <Ivan Hincapie>
-- Create date: <08/06/2023>
-- Description <Import from excel to sql table>
-- =============================================

CREATE PROCEDURE [dbo].[spOrders]
AS
SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#arch') IS NOT NULL DROP TABLE #arch;
	CREATE TABLE #arch (ID INT IDENTITY(1,1),S VARCHAR(1000));
	-- Declare the path to the folder where the file is saved
	DECLARE @Ruta VARCHAR(4000) = 'C:\Users\';
	DECLARE @return_value INT=0;
	DECLARE @query VARCHAR(4000);

	INSERT INTO #arch
	-- Declare file name and extension
	SELECT REPLACE(Dir,@Ruta,'') FROM [SCTRANSTOOLBOX].[dbo].[GetFiles](@Ruta,'Raw_Data.xlsx');

BEGIN

	DECLARE @Archivo VARCHAR(8000),
		    @CMD VARCHAR(8000),
		    @Error INT = 0;
	
BEGIN TRY

--============  Create and delete a Temporary Table  ============--

		IF OBJECT_ID('tempdb..##tbOrders') Is Not Null

		DROP TABLE ##tbOrders;
		
		CREATE TABLE ##tbOrders
		([Order_id] VARCHAR(50) NULL
		,[Order_date] VARCHAR(50) NULL
		,[status] VARCHAR(50) NULL
		,[delivery_status] VARCHAR(50) NULL
		,[client_id] VARCHAR(50) NULL
		,[product_id] VARCHAR(50) NULL
		,[items] VARCHAR(50) NULL
		,[discount_amount] VARCHAR(50) NULL
		);

--============  Bulk Inserts  ============--

		SET @Archivo = (SELECT S FROM #arch)

		DECLARE @FNR VARCHAR(4000) = @Ruta + @Archivo;

		DECLARE @EXEC VARCHAR (4000) = ('BULK INSERT ##tbTBRData2 FROM '''+@FNR+''' 
		                                 WITH(FIELDTERMINATOR = ''\t'', ROWTERMINATOR = ''\n'', FIRSTROW = 2, codepage = ''ACP'')');
		PRINT @EXEC;

		EXEC(@EXEC);
	
--============  Merge from Temporary to SQL Table  ============--
		
		MERGE [Database].[dbo].[tbOrders] AS TARGET

		USING [##tbOrders] AS SOURCE

		ON 
		(
			TARGET.[Order_id] = SOURCE.[Order_id]
		)
 		WHEN Matched

		THEN UPDATE SET

			TARGET.[Order_id]          = Try_Convert(Int,SOURCE.[Order_id])
			,TARGET.[Order_date]	   = CONVERT (DATE,SOURCE.[Order_date],103)
			,TARGET.[status]		   = SOURCE.[status]
			,TARGET.[delivery_status]  = SOURCE.[delivery_status]
			,TARGET.[client_id]		   = Try_Convert(Int,SOURCE.[client_id])
			,TARGET.[product_id]	   = SOURCE.[product_id]
			,TARGET.[items]			   = Try_Convert(Int,SOURCE.[items])
			,TARGET.[discount_amount]  = Try_Convert(FLOAT,SOURCE.[discount_amount],2)
		WHEN NOT MATCHED BY TARGET
		THEN INSERT 
			(
				[Order_id]  
				,[Order_date]
				,[status]
				,[delivery_status]
				,[client_id]
				,[product_id]
				,[items]
				,[discount_amount]
			)
		VALUES 
			(
			 SOURCE.[Order_id]  
			 ,CONVERT (DATE,SOURCE.[Order_date],103)
			 ,SOURCE.[status]
			 ,SOURCE.[delivery_status]
			 ,Try_Convert(Int,SOURCE.[client_id])
			 ,SOURCE.[product_id]
			 ,Try_Convert(Int,SOURCE.[items])
			 ,Try_Convert(FLOAT,SOURCE.[discount_amount],2)
			);

--==========  Remove Temporary Tables  ==========--

	IF OBJECT_ID('tempdb..##tbOrders') IS NOT NULL
	DROP TABLE ##tbTestLogistica;

	IF OBJECT_ID('tempdb..#arch') IS NOT NULL
	DROP TABLE #arch;

END