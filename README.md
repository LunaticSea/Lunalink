# 🌒 Lunalink

An advanced lavalink wrapper written in Lua. (Ported from rainlink and work in progress)

# 🌟 Features
 - Stable client
 - Support Luvit
 - 100% Compatible with Lavalink
 - Object-oriented
 - Easy to setup
 - Inbuilt Queue System
 - Extendable Player, Queue, Rest class
 - **Backward compatible** (Can run lavalink version 3.7.x)
 - **Driver based** (avaliable to run Nodelink v2 and port older lavalink version)
 - Plugin system

# 🛠️ Installation

```
lit install RainyXeon/lunalink
```

# 💿 Used by

| Name                                                   | Creator      | Variants          |
|--------------------------------------------------------|--------------|-------------------|
| [LunaticSea](https://github.com/LunaticSea/LunaticSea) | RainyXeon    | Original          |

If you want to add your own bot create a pull request with your bot added. Please add your full name.

# ⚙ Drivers

This is the list of all rainlink driver currently supported (codename is made up by me)

| Driver Name | Voice Server                                          | Language   | Supported Version | Notes                                                             |
|-------------|-------------------------------------------------------|------------|-------------------|-------------------------------------------------------------------| 
| koinu       | [Lavalink](https://github.com/lavalink-devs/Lavalink) | Java       | v4.0.0 - v4.x.x   |                                                                   |
| nari        | [Nodelink](https://github.com/PerformanC/NodeLink)    | Javascript | v2.0.0 - v2.x.x   | Some `filter` mode in nodelink not supported                      |

# 💾 Example bot:

```lua
local discordia = require('discordia')
local client = discordia.Client({
  gatewayIntents = 53608447
})
local lunalink = require('lunalink')
local f = string.format

local manager = lunalink.Core({
  nodes = {
    {
      name = "test",
      host = "localhost",
      secure = false,
      auth = "youshallnotpass",
      port = 2333
    }
  },
  library = lunalink.library.Discordia(client)
})

manager:on('debug', function (log)
  print(log)
end)

manager:on('nodeConnect', function (node)
  print(f("Lavalink [%s] Ready!", node.options.name))
end)

manager:on('nodeError', function (node, err)
  print(f("Lavalink [%s] error: %s", node.options.name, err))
end)

manager:on('nodeClosed', function (node)
  print(f("Lavalink [%s] Closed!", node.options.name))
end)

manager:on('nodeDisconnect', function (node, code, reason)
  print(f("Lavalink [%s] Disconnected, Code %s, Reason %s", node.options.name, code, reason))
end)

manager:on("trackStart", function (player, track)
  client.guilds:get(player.guildId).textChannels:get(player.textId):send(
    f("Now playing **%s** by **%s**", track.title, track.author)
  )
end);

manager:on("trackEnd", function (player)
  client.guilds:get(player.guildId).textChannels:get(player.textId):send(
    "Finished playing"
  )
end);

manager:on("queueEmpty", function (player)
  client.guilds:get(player.guildId).textChannels:get(player.textId):send(
    "Destroyed player due to inactivity."
  )
  player:destroy()
end);

client:on('messageCreate', function (message)
  if message.author.bot then return end

  local play_q = string.match(message.content, "%!play (.+)")

  if play_q then
    local channel = message.member.voiceChannel
    if not channel then return message:reply("You need to be in a voice channel to use this command!") end

    local player = manager.players:create({
      guildId = message.guild.id,
      textId = message.channel.id,
      voiceId = channel.id,
      shardId = 0,
      volume = 100
    })

    local result = manager:search(play_q, { requester = message.author })
    if #result.tracks == 0 then return message:reply("No results found!") end

    if result.type == "PLAYLIST" then
      for _, track in pairs(result.tracks) do
        player.queue:add(track)
      end
    else player.queue:add(result.tracks[1]) end

    if not player.playing then player:play() end

    return message:reply({ content = f("Queued %s", result.tracks[1].title) });
  end

  local is_stop = string.match(message.content, "%!stop")

  if is_stop then
    local player = manager.players:get(message.guild.id)
    if player then
      player:destroy()
      return message:reply({ content = "Player destroyed" })
    end
    return message:reply({ content = "No player have to destroy" })
  end
end)

client:run('Bot INSERT_TOKEN_HERE')
```

# ✨ Special thanks

| Creator                                              | Insipred Product                                         | Item                    |
|------------------------------------------------------|----------------------------------------------------------|-------------------------|
| [@cloudwithax](https://github.com/cloudwithax)       | [flare](https://github.com/cloudwithax/flare)            | Websocket Usage Example |
| [@SinisterRectus](https://github.com/SinisterRectus) | [Discordia](https://github.com/SinisterRectus/Discordia) | Emmiter, enums          |
| [@Bilal2453](https://github.com/Bilal2453)           | [luv-docgen](https://github.com/Bilal2453/luv-docgen)    | docgen                  |

- **And everyone who contribute my project 💗**

# 💫 Credits
- [@RainyXeon](https://github.com/RainyXeon): Owner of Lunalink
