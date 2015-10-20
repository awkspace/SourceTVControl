**SourceTV Control** is a simple SourceMod plugin that automatically records demo files when the server is active, and stops recording when it is not. Set `tv_enable 1` in your `autoexec.cfg` or add `+tv_enable 1` to your server parameters to enable SourceTV.

## Configuration
* `sm_tvc_filename` controls where and how demo files are stored. Supports [strftime format specifiers](http://www.cplusplus.com/reference/ctime/strftime). Use `{mapname}` to insert the name of the map the demo was recorded on and `{timestamp}` to insert the Unix timestamp when the recording started. Defaults to `demos/%F %H-%M-%S {mapname}`.
