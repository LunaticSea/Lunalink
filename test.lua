local discordia = require('discordia')
local client = discordia.Client()

local lunalink = require('lunalink')

local manager = lunalink.Core({
  nodes = {
    {
      name = "Test connection",
      host = "localhost",
      secure = false,
      auth = "youshallnotpass",
      port = 2333
    }
  },
  library = lunalink.library.Discordia(client),
  plugins = {},
  config = {
    retryCount = 999,
  }
})

manager:on('debug', function (log)
  print(log)
end)

client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
	if message.content == '!ping' then
		message.channel:send('Pong!')
	end
end)

client:run('Bot INSERT_TOKEN_HERE')