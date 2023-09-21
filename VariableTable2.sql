CREATE OR ALTER PROCEDURE [dbo].[SP_AnySP] (
  @soc NVARCHAR(30)
  ) AS

   DECLARE @tblCust TABLE (
      ItemName NVARCHAR(100),
      QuantityOrdered INT NULL,
      IsDangerous_C BIT NULL,
       IsCold_C BIT NULL,
       ShipToCode NVARCHAR(100)
       ) INSERT INTO @tblCust
      SELECT
       CASE WHEN IsConvertedToCode_C = 1
         AND ConvertedToQty_C > 0
        AND csod.QuantityOrdered >= ConvertedToQty_C THEN ConvertedFromCode_C ELSE II.ItemName END AS ItemName,
      CONVERT(
         INT,
            CASE WHEN II.ItemType = 'Note'
         OR II.ItemName = '' THEN NULL ELSE CASE WHEN IsConvertedToCode_C = 1
              and ConvertedToQty_C > 0
          AND csod.QuantityOrdered >= ConvertedToQty_C THEN csod.QuantityOrdered / ConvertedToQty_C ELSE csod.QuantityOrdered 
   end END
        ) AS QuantityOrdered,
       CONVERT(
        BIT,
         ISNULL(II.IsDangerousGoods_C, 0)
             ) AS IsDangerous_C,
         CONVERT(
        BIT,
         ISNULL(II.IsCold_C, 0)
         ) AS IsCold_C,
        CSO.ShipToCode
       FROM
          sales CSO WITH (NOLOCK)
      INNER JOIN orderdetail CSOD WITH (NOLOCK) ON CSO.soc = CSOD.soc
        INNER JOIN item II WITH (NOLOCK) ON II.ItemCode = CSOD.ItemCode
     WHERE
       CSO.soc = @soc
         AND CSO.Type = 'Sales Order'

      UPDATE s SET s.Ship = 1 FROM Shipment s
      WHERE s.ShipToCode IN (SELECT tsco.ShipToCode FROM @tblCust tsco)

      SELECT * FROM @tblCust tsco