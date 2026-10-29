# Power BI build guide

## Connect
1. Open Power BI Desktop.
2. Get Data → Text/CSV.
3. Select `source/supply-chain-inventory-analytics-main/data/raw/supply_chain_dataset.csv`.
4. Set `Date` to Date; flags to Whole Number; costs/prices/forecast to Decimal Number.

## Recommended measures (DAX)
```DAX
Units Sold = SUM(supply_chain_dataset[Units_Sold])
Sales Value = SUMX(supply_chain_dataset, supply_chain_dataset[Units_Sold] * supply_chain_dataset[Unit_Price])
COGS = SUMX(supply_chain_dataset, supply_chain_dataset[Units_Sold] * supply_chain_dataset[Unit_Cost])
Gross Profit = [Sales Value] - [COGS]
Gross Margin % = DIVIDE([Gross Profit], [Sales Value])
Below Reorder Records = CALCULATE(COUNTROWS(supply_chain_dataset), FILTER(supply_chain_dataset, supply_chain_dataset[Inventory_Level] < supply_chain_dataset[Reorder_Point]))
Below Reorder % = DIVIDE([Below Reorder Records], COUNTROWS(supply_chain_dataset))
Stockout Records = SUM(supply_chain_dataset[Stockout_Flag])
Avg Lead Time = AVERAGE(supply_chain_dataset[Supplier_Lead_Time_Days])
Inventory Value (Observation Sum) = SUMX(supply_chain_dataset, supply_chain_dataset[Inventory_Level] * supply_chain_dataset[Unit_Cost])
```

## Suggested report layout
- KPI cards: Units Sold, Sales Value, Gross Profit, Gross Margin %, Below Reorder %, Stockout Records.
- Line chart: Units Sold by Date (monthly).
- Bar chart: Sales Value by SKU.
- Bar chart: Reorder-risk record rate by Warehouse.
- Bar chart: Average Supplier Lead Time by Supplier.
- Matrix: Region → Warehouse, with Units Sold, Sales Value, Below Reorder Records.
- Slicers: Date, Region, Warehouse_ID, SKU_ID, Supplier_ID, Promotion_Flag.

## Note
The inventory value sum across daily records is an observation-based aggregation. If treating Inventory_Level as a daily stock snapshot, avoid interpreting the full-period sum as a single date's inventory value.
