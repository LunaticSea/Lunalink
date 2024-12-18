local crhttp = require('coro-http')

local json = require("json")

local lavalink_url = "http://192.168.0.107:2333/v4/stats"

local headers = {
  { 'authorization', 'youshallnotpass' },
  { "content-type", "application/json" },
}

-- Send the POST request
local res, res_data = crhttp.request("GET", lavalink_url, headers)

-- Was the request successful?
if res.code < 200 or res.code >= 300 then
   return print("Failed to send req: " .. res.reason)
end

print("Req sent successfully!")
p(res_data)
