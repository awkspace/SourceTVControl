**SourceTV Control** is a simple SourceMod plugin that automatically records demo files when the server is active, and stops recording when it is not.

## Configuration
* `sm_tvc_enable` turns autorecording on or off. (Default: `1`)
* `sm_tvc_autovacate` determines whether SourceTV will always be present, or only when it is recording. (Default: `1`)
* `sm_tvc_filename` controls where and how demo files are stored. Supports [strftime format specifiers](http://www.cplusplus.com/reference/ctime/strftime) and will replace `{MAPNAME}` with the full name of the current map. (Default: `demos/%T-{MAPNAME}` - i.e. the Unix timestamp the recording started at followed by the map name)
