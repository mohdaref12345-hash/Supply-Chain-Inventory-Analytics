-- Data-quality checks to run after loading the CSV.
SELECT COUNT(*) AS null_dates FROM supply_chain WHERE date IS NULL;
SELECT COUNT(*) AS null_sku FROM supply_chain WHERE sku_id IS NULL;
SELECT COUNT(*) AS negative_units_sold FROM supply_chain WHERE units_sold < 0;
SELECT COUNT(*) AS negative_inventory FROM supply_chain WHERE inventory_level < 0;
SELECT COUNT(*) AS invalid_price_cost FROM supply_chain WHERE unit_price < 0 OR unit_cost < 0;
SELECT COUNT(*) AS invalid_flags FROM supply_chain
 WHERE promotion_flag NOT IN (0,1) OR stockout_flag NOT IN (0,1);
-- Check duplicate key based on daily SKU-warehouse observation.
SELECT date, sku_id, warehouse_id, COUNT(*) AS duplicate_count
FROM supply_chain
GROUP BY date, sku_id, warehouse_id
HAVING COUNT(*) > 1;
