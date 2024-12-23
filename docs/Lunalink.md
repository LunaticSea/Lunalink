The heart of Lunalink. Manage all package action

*Instances of this class should not be constructed by users.*

## Properties

| Name | Type | Description |
|-|-|-|
| drivers | AbstractDriver | All avaliable lunalink drivers |
| id | string | Bot id |
| library | AbstractLibrary | Discord library connector |
| nodes | NodeManager | Lavalink server that has been configured |
| options | [[LunalinkOptions]] | Lunalink options, see get:default_options |
| players | PlayerManager | All currently running players |
| plugins | Cache | All plugins (include resolver plugins) |
| searchEngine | Cache | All search engines |
| searchPlugins | Cache | All search plugins (resolver plugins) |
| shardCount | number | The current bott's shard count |
| voices | Cache | All voice handler currently |

## Methods

### __init(options)

| Parameter | Type |
|-|-|
| options | table |



**Returns:** 

----

### create(options)

| Parameter | Type |
|-|-|
| options | VoiceChannelOptions |

Create a new player.

**Returns:** Player

----

### destroy(guild_id)

| Parameter | Type |
|-|-|
| guild_id | string |

Destroy a specific player.

**Returns:** nil

----

### search(query, options)

| Parameter | Type |
|-|-|
| query | string |
| options | SearchOptions |

Search a specific track.

**Returns:** nil

----

