DECLARE @ShipmentTrackingTable TABLE (
    [TrackingNumber] VARCHAR(MAX),
	[IsShipiumSelect] BIT
);

DECLARE @DateCreated DATETIME = NULL;


-- CTE to combine shipments from all databases
WITH CombinedShipments AS (
    -- Selecting from TractorSupplyRx database
    SELECT TrackingNumber, IsShipiumSelect, DateCreated FROM TractorSupplyRx..Shipment
    UNION ALL
    -- Selecting from AKCPetRx database
    SELECT TrackingNumber, IsShipiumSelect, DateCreated FROM AKCPetRx..Shipment
    UNION ALL
    -- Selecting from FarmAndFleetRx database
    SELECT TrackingNumber, IsShipiumSelect, DateCreated FROM FarmAndFleetRx..Shipment 
    UNION ALL
    -- Selecting from GiantEaglePetRx database
    SELECT TrackingNumber, IsShipiumSelect, DateCreated FROM GiantEaglePetRx..Shipment 
    UNION ALL
    -- Selecting from LyonRx database
    SELECT TrackingNumber, IsShipiumSelect, DateCreated FROM LyonRx..Shipment 
    UNION ALL
    -- Selecting from WalmartPetRx database
    SELECT TrackingNumber, IsShipiumSelect, DateCreated FROM WalmartPetRx..Shipment
)
INSERT INTO @ShipmentTrackingTable ([TrackingNumber],[IsShipiumSelect])
-- Main query to find valid TrackingNumbers
SELECT 
    TrackingNumber -- Tracking number of the shipment
	,IsShipiumSelect
FROM 
    CombinedShipments -- From the combined shipments of all databases
WHERE 
    IsShipiumSelect IS NOT NULL -- Filter for shipments where IsShipiumSelect is true
	AND (@DateCreated IS NULL OR DateCreated = @DateCreated)
GROUP BY 
    TrackingNumber -- Group by TrackingNumber to aggregate
	,IsShipiumSelect

-- Update Allivet IsShipiumSelect Select
IF EXISTS(SELECT IsShipiumSelect, TrackingNumber, DateCreated FROM Allivet..Shipment WHERE TrackingNumber IN (SELECT TrackingNumber From @ShipmentTrackingTable))
BEGIN
	UPDATE Allivet..Shipment 
	SET Allivet..Shipment.IsShipiumSelect = STT.IsShipiumSelect
	FROM Allivet..Shipment AS S
	INNER JOIN @ShipmentTrackingTable AS STT ON S.TrackingNumber = STT.TrackingNumber
	WHERE S.IsShipiumSelect IS NULL OR S.IsShipiumSelect <> STT.IsShipiumSelect
END