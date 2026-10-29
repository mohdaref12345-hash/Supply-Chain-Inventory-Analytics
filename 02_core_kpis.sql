-- Core business KPIs. Assumes source CSV has been loaded into public.supply_chain.
SELECT
  COUNT(*) AS records,
  COUNT(DISTINCT sku_id) AS distinct_skus,
  COUNT(DISTINCT warehouse_id) AS warehouses,
  COUNT(DISTINCT supplier_id) AS suppliers,
  COUNT(DISTINCT region) AS regions,
  SUM(units_sold) AS units_sold,
  SUM(units_sold * unit_price) AS sales_value,
  SUM(units_sold * unit_cost) AS cogs,
  SUM(units_sold * (unit_price - unit_cost)) AS gross_profit,
  100.0 * SUM(units_sold * (unit_price - unit_cost))
      / NULLIF(SUM(units_sold * unit_price), 0) AS gross_margin_pct,
  SUM(inventory_level * unit_cost) AS observed_inventory_value,
  SUM(CASE WHEN inventory_level < reorder_point THEN 1 ELSE 0 END) AS below_reorder_records,
  100.0 * SUM(CASE WHEN inventory_level < reorder_point THEN 1 ELSE 0 END)
      / NULLIF(COUNT(*), 0) AS below_reorder_record_pct,
  SUM(stockout_flag) AS stockout_records
FROM supply_chain;
