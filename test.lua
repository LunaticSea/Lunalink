local ws = require('utils/Websocket')
local lock = false
local websocket = ws({
  url = 'ws://localhost:2333/v3/websocket',
  headers = {
    { 'authorization', 'youshallnotpass' },
    { 'user-id', '992776455790534667' },
    { 'client-name', 'Lunalink/1.0.0' },
  }
})

websocket:on('open', function (selfws)
  print('Node connected on: ' .. selfws._url)
end)

websocket:on('close', function (code, reason)
  print(string.format('Node closed. Code: %s Reason: %s', code, reason))
end)

websocket:on('message', function (res)
  p(res.json_payload)
  if res.json_payload.op == 'stats' then
    websocket:send({ op = "stop", guildId = "1084918771967344662" })
    if lock then return p(websocket._listeners) end
    websocket:close()
    websocket:connect()
    lock = true
  end
end)

websocket:connect()