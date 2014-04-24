XDMProvider = require "./provider.coffee"
objectUtils = require "madlib-object-utils"

# Collect the whitelist
#
whitelist = []
if objectUtils.isArray( window.xdmWhitelist )
    whitelist = window.xdmWhitelist

# Create the XDM provider
#
xdmProvider = new XDMProvider( whitelist )