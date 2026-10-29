-- Reusable views. These are observation-level and aggregate-level summaries.
CREATE OR REPLACE VIEW v_supply_chain_enriched AS
SELECT
  *,
  units_sold * unit_price AS sales_value,
  units_sold * unit_cost AS cogs,
  units_sold * (unit_price - unit_cost) AS gross_profit,
  100.0 * (unit_price - unit_cost) / NULLIF(unit_price, 0) AS gross_margin_pct_per_unit,
  inventory_level * unit_cost AS inventory_value,
  CASE WHEN inventory_level < reorder_point THEN 1 ELSE 0 END AS reorder_risk_flag,
  inventory_level::numeric / NULLIF(units_sold, 0) AS inventory_coverage_days,
  CASE WHEN units_sold > 0
        AND inventory_level::numeric / units_sold < supplier_lead_time_days
       THEN 1 ELSE 0 END AS coverage_below_lead_time
FROM supply_chain;

CREATE OR REPLACE VIEW v_sku_performance AS
SELECT
  sku_id,
  SUM(units_sold) AS units_sold,
  SUM(units_sold * unit_price) AS sales_value,
  SUM(units_sold * (unit_price - unit_cost)) AS gross_profit,
  AVG(inventory_level) AS avg_inventory_level,
  AVG(CASE WHEN inventory_level < reorder_point THEN 1.0 ELSE 0.0 END) AS below_reorder_record_rate,
  SUM(stockout_flag) AS stockout_records
FROM supply_chain
GROUP BY sku_id;

CREATE OR REPLACE VIEW v_warehouse_performance AS
SELECT
  warehouse_id,
  region,
  SUM(units_sold) AS units_sold,
  SUM(units_sold * unit_price) AS sales_value,
  AVG(inventory_level) AS avg_inventory_level,
  AVG(CASE WHEN inventory_level < reorder_point THEN 1.0 ELSE 0.0 END) AS below_reorder_record_rate,
  SUM(stockout_flag) AS stockout_records
FROM supply_chain
GROUP BY warehouse_id, region;

CREATE OR REPLACE VIEW v_supplier_lead_time AS
SELECT
  supplier_id,
  AVG(supplier_lead_time_days) AS avg_lead_time_days,
  MIN(supplier_lead_time_days) AS min_lead_time_days,
  MAX(supplier_lead_time_days) AS max_lead_time_days,
  COUNT(*) AS observations,
  AVG(CASE WHEN inventory_level < reorder_point THEN 1.0 ELSE 0.0 END) AS below_reorder_record_rate
FROM supply_chain
GROUP BY supplier_id;
