local access_shaft_components = table.deepcopy(data.raw["item"]["copper-cable"])
access_shaft_components.place_result = ""
access_shaft_components.flags = {}
access_shaft_components.name = "access-shaft-components"
data:extend({access_shaft_components})