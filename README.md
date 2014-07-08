trelloxmpp
==========

Bot to relay activity from Trello boards to XMPP MUC rooms

Dependencies
------------
You must have Lua 5.1 installed, and a build environment including openssl-dev files so the other dependencies can be compiled automatically.

Other than that, editing the variables at the top of and running `make` will install all the Lua dependencies locally (within the current directory) without root access. It'll ask you to populate config.py for Sluift compilation, and give default options for this that should make sense.

Running
-------

Substitute appropriate values for the environment variables, and run something like
`SLUIFT_JID=test@example.com SLUIFT_PASS=password MUC_ROOM=trello@rooms.example.com TRELLO_KEY=yourAPIKeyHere TRELLO_BOARD=TrelloBoardID lua bridge.lua`

To get a Trello Key, go to https://trello.com/1/appKey/generate, and to find the id of the board look at the URL of the board and extract the bit between '/b/' and the next '/', e.g. if the URL to your board https://trello.com/b/AxxOEUI/test the key would be "AxxOEUI". If your board is private, you will also need to specify a TRELLO_TOKEN environment variable with a token that gives access to your board -- see https://trello.com/docs/gettingstarted/index.html 'Getting a Token from a User'.
