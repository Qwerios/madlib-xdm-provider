( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "madlib-console"
            require "madlib-xhr"
            require "madlib-shim-easyxdm"
            require "madlib-browser-cookie"
        )
    else if typeof define is "function" and define.amd
        define( [
            "madlib-console"
            "madlib-xhr"
            "madlib-shim-easyxdm"
            "madlib-browser-cookie"
        ], factory )
)( ( console, XHR, easyXDM, ppkCookie ) ->

    ###*
    #   The XDM Provider makes a same host ajax call using the parameters provided
    #   by the XDM consumer. The response needs to be marshalled as text because of
    #   restrictions in the easyXDM channel and the JSON.stringify method (cyclic structures)
    #
    #   @author     mdoeswijk
    #   @class      XDMProvider
    #   @constructor
    #   @version    0.1
    ###
    class XDMProvider
        @remote

        ###*
        #   The class constructor. You need to supply the whitelist
        #
        #   @function constructor
        #
        #   @params {Array}  [whitelist]   Whitelisted host allowed to call the provider. Leave empty to allow all
        #
        #   @return None
        #
        ###
        constructor: ( @whitelist = [] ) ->
            options =
                swfUrl: document.location.href.substr( 0, document.location.href.lastIndexOf( "/" ) + 1 ) + "easyxdm.swf"

            rpcChannel =
               local:
                    ping: ( successHandler, errorHandler ) ->
                        successHandler( "pong" )

                    request: ( params, successHandler, errorHandler ) =>

                        if not @isAllowed( document.referrer )
                            errorHandler(
                                status:     403
                                statusText: "Forbidden"
                            )
                        else
                            xhr = new XHR()

                            # Set custom timeout if provided
                            #
                            xhr.timeout = params.timeout if params.timeout

                            xhr.call( params )
                            .then(
                                # Success
                                #
                                ( data ) =>
                                    console.log( "[XDM] Provider XHR success", data )

                                    # Always return responseText because of marshalling contraints
                                    #
                                    data.response = xhr.transport.responseText
                                    successHandler( data )
                            ,
                                # Error
                                #
                                ( data ) =>
                                    console.log( "[XDM] Provider XHR error", data )

                                    # Always return responseText because of marshalling contraints
                                    #
                                    data.response = xhr.transport.responseText
                                    errorHandler( data )
                            )
                            .done()

                            return

                    setCookie: ( name, value, days, successHandler, errorHandler ) =>
                        if not @isAllowed( document.referrer )
                            errorHandler(
                                status:     403
                                statusText: "Forbidden"
                            )
                        else
                            ppkCookie.setCookie( name, value, days );
                            successHandler()

                    getCookie: ( name, successHandler, errorHandler ) =>
                        if not @isAllowed( document.referrer )
                            errorHandler(
                                status:     403
                                statusText: "Forbidden"
                            )
                        else
                            value = ppkCookie.getCookie( name )
                            successHandler()

                    deleteCookie: ( name, successHandler, errorHandler ) =>
                        if not @isAllowed( document.referrer )
                            errorHandler(
                                status:     403
                                statusText: "Forbidden"
                            )
                        else
                            ppkCookie.deleteCookie( name )

            # Create the XDM Provider side of the RPC channel
            #
            @remote = new easyXDM.Rpc( options, rpcChannel )

        ###*
        #   The class constructor. You need to supply your instance of madlib-settings
        #
        #   @function isAllowed
        #
        #   @params {String} hostname   Checks if the host is allowed to call the provided based on the whitelist
        #
        #   @return {Boolean}   True if host is allowed to call the provider
        #
        ###
        isAllowed: ( hostname ) =>
                return true if @whitelist.length is 0

                allowed = false

                # Check for a (partial) host match from the whitelist
                #
                host = hostname.replace( /^http[s]?:\/\//, "" ).split( "/" ).slice( 0, 1 ).pop()

                for allowedHost in whitelist
                    test    = "^" + whitelist[ key ] + "$"
                    allowed = host.match( test ) is not null

                    break if allowed

                return allowed
)