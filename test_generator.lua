local gen = require("client.local_generator")

local headline, description = gen.generate({ faction = "public" })
print("Headline:", headline)
print("Description:", description)

gen.cleanup()
