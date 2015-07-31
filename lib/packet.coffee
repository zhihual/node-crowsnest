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

_ = require('lodash')
msgpack = require('msgpack-js')

PACKET_VERSION = 1

###*
# @summary Create a Crow's Nest packet that complies with the Packet Spec v1.
# @function
# @protected
#
# @param {Object} options - packet options
# @param {Number} options.severity - event severity
# @param {Number} options.tag - event tag
# @param {String} options.message - event message
# @param {String} options.productKey - product key
# @param {String} options.serial - device serial number
#
# @returns {Buffer} packet payload
#
# @example
# payload = packet.create
# 	severity: 3
# 	tag: 0
# 	message: 'Hello World'
# 	productKey: '8ygh638f3nn2937t'
# 	serial: '1234'
###
exports.create = (options) ->

	if not options.severity?
		throw new Error('Severity missing')

	if not _.isNumber(options.severity)
		throw new Error('Severity should be a number')

	if not options.tag?
		throw new Error('Tag missing')

	if not _.isNumber(options.tag)
		throw new Error('Tag should be a number')

	if not options.message?
		throw new Error('Message missing')

	if not _.isString(options.message)
		throw new Error('Message should be a string')

	if Buffer.byteLength(options.message, 'utf8') > 255
		throw new Error('Message byte limit is 255')

	if not options.productKey?
		throw new Error('Product key missing')

	if not _.isString(options.productKey)
		throw new Error('Product key should be a string')

	if not options.serial?
		throw new Error('Serial missing')

	if not _.isString(options.serial)
		throw new Error('Serial should be a string')

	if Buffer.byteLength(options.serial, 'utf8') > 31
		throw new Error('Serial byte limit is 31')

	return msgpack.encode [
		PACKET_VERSION
		options.severity << options.tag
		options.productKey
		options.serial
		options.message
	]
