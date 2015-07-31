###
The MIT License

Copyright (c) 2015 Juan Cruz Viotti. https://jviotti.github.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

###*
# @module cn
###

Promise = require('bluebird')
_ = require('lodash')
getmac = require('getmac')
api = require('./api')
packet = require('./packet')

###*
# @summary Crow's Nest severity table
# @static
# @public
# @description
# This severity table matches Crow's Nest v1 packet spec.
###
exports.severity =

	###*
	# @summary Describe a debug event
	# @public
	# @constant
	# @member {Number}
	###
	DEBUG: 0

	###*
	# @summary Describe an information event
	# @public
	# @constant
	# @member {Number}
	###
	INFO: 1

	###*
	# @summary Describe an error event
	# @public
	# @constant
	# @member {Number}
	###
	ERROR: 2

	###*
	# @summary Describe a critical event
	# @public
	# @constant
	# @member {Number}
	###
	CRITICAL: 3

###*
# @summary Configuration object
# @static
# @public
# @description
# This object should be edited to add the following properties:
#
# - `String productKey`.
# - `String productSecret`.
###
exports.config =

	###*
	# @summary Get the serial number of a device
	# @public
	# @function
	# @member
	#
	# @description
	# This function returns the device MAC address by default. You may customise it to fit your needs as follows:
	#
	# ```javascript
	# cn.config.getSerial = function(callback) {
	# 	return callback(null, 'mySerial');
	# };
	# ```
	#
	# @param {Function} callback - callback (error, serial)
	#
	# @example
	# cn.config.getSerial(function(error, serial) {
	# 	if (error) throw error;
	# 	console.log(serial);
	# });
	###
	getSerial: getmac.getMac

###*
# @summary Send an event to Crow's Nest
# @function
# @public
#
# @description
# Notice you must set `cn.config.productKey` and `cn.config.productSecret` before using this function.
#
# The `serial` property defaults to the MAC address of the running device. You may set a new function to `cn.config.getSerial` to customise this.
#
# @param {Number} severity - severity
# @param {Number} tag - tag
# @param {*} message - message
# @param {Function} callback - callback (error, response)
#
# @example
# var cn = require('crowsnest');
#
# // Grab these from the profile section
# cn.config.productKey = '8ygh638f3nn2937t';
# cn.config.productSecret = 'p2f7j308dw0foie4';
#
# cn.alert(cn.severity.DEBUG, 1, 'Hello World', function(error, response) {
# 	if (error) throw error;
# 	console.log(response);
# });
###
exports.alert = (severity, tag, message, callback) ->
	Promise.try ->

		if not exports.config.productKey?
			throw new Error('Did you set a productKey in the config object?')

		if not exports.config.productSecret?
			throw new Error('Did you set a productSecret in the config object?')

		if not _.isString(message)
			stringifiedMessage = JSON.stringify(message)

			if not stringifiedMessage?
				return Promise.reject(new Error('Cannot stringify message'))

			message = stringifiedMessage

		Promise.fromNode(exports.config.getSerial).then (serial) ->
			payload = packet.create
				severity: severity
				tag: tag
				message: message
				productKey: exports.config.productKey
				serial: serial

			return api.alert(exports.config.productSecret, payload).return(undefined)

	.nodeify(callback)
