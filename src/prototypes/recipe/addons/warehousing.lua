require("prototypes.prototype")

-- Transport warehouses & storehouses
local transport_storehouse_down = proto.definition({"recipe", "transport_chest", "storehouse"}, "down", true)
local transport_storehouse_up = proto.definition({"recipe", "transport_chest", "storehouse"}, "up", true)
local logistic_transport_storehouse_down = proto.definition({"recipe", "transport_chest", "logistic_storehouse"}, "down", true)
local logistic_transport_storehouse_up = proto.definition({"recipe", "transport_chest", "logistic_storehouse"}, "up", true)
local transport_warehouse_down = proto.definition({"recipe", "transport_chest", "warehouse"}, "down", true)
local transport_warehouse_up = proto.definition({"recipe", "transport_chest", "warehouse"}, "up", true)
local logistic_transport_warehouse_down = proto.definition({"recipe", "transport_chest", "logistic_warehouse"}, "down", true)
local logistic_transport_warehouse_up = proto.definition({"recipe", "transport_chest", "logistic_warehouse"}, "up", true)

data:extend({transport_storehouse_down, transport_storehouse_up, logistic_transport_storehouse_down, logistic_transport_storehouse_up, transport_warehouse_down,
	transport_warehouse_up, logistic_transport_warehouse_down, logistic_transport_warehouse_up})