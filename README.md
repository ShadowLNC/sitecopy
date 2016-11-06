# sitecopy - Copy (Mirror) Sites

Used to copy "live" sites (with data changing in "realtime") from HTTP(s) and upload them over SSH (scp).

Written in Bash; originally designed for mirroring the FLL&reg; scores.
See http://www.firstlegoleague.org/ - trademarks may apply.

## Setup
1. Configure your endpoints in server-remote.sh - a sample is available in the server-remote.sh.default file.
1. The `SHADOW` folder is where a shadow copy of the files are kept; if the files do not change, a new copy is not uploaded.

## Use
1. Run `./setup.sh` to copy static files, such as stylesheets (CSS), images and JavaScript
1. Run `./fetcher.sh` to copy the changing files (Ctrl+C to stop)
