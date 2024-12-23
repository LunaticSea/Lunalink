Some lunalink additional config option

*Instances of this class should not be constructed by users.*

## Properties

| Name | Type | Description |
|-|-|-|
| additionalDriver | table | Additional custom driver for rainlink (no need 'new' keyword when add). Example: `additionalDriver: Lavalink4` |
| defaultSearchEngine | string | The default search engine like default search from youtube, spotify,... |
| defaultVolume | number | The default volume when create a player |
| nodeResolver | function | Node Resolver to use if you want to customize it `function (nodes) end` |
| resume | number | Whether to resume a connection on disconnect to Lavalink (Server Side) (Note: DOES NOT RESUME WHEN THE LAVALINK SERVER DIES) |
| resumeTimeout | number | When the seasion is deleted from Lavalink. Use second (Server Side) (Note: DOES NOT RESUME WHEN THE LAVALINK SERVER DIES) |
| retryCount | number | Number of times to try and reconnect to Lavalink before giving up |
| retryTimeout | number | Timeout before trying to reconnect (ms) |
| searchFallback | [[SearchFallback]] | Search track from youtube when track resolve failed |
| structures | [[Structures]] | Number of times to try and reconnect to Lavalink before giving up |
| userAgent | string | User Agent to use when making requests to Lavalink |
| voiceConnectionTimeout | number | The retry timeout for voice manager when dealing connection to discord voice server (ms) |

