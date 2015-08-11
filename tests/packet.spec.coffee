m = require('mochainon')
_ = require('lodash')
_.str = require('underscore.string')
msgpack = require('msgpack-js')
packet = require('../lib/packet')

describe 'Packet:', ->

	describe '.create()', ->

		it 'should throw if no severity', ->
			m.chai.expect ->
				packet.create
					tag: 0
					message: 'Hello World'
					productKey: '8ygh638f3nn2937t'
					serial: '1234'
			.to.throw('Severity missing')

		it 'should throw if severity is not a number', ->
			m.chai.expect ->
				packet.create
					severity: '1'
					tag: 0
					message: 'Hello World'
					productKey: '8ygh638f3nn2937t'
					serial: '1234'
			.to.throw('Severity should be a number')

		it 'should throw if no tag', ->
			m.chai.expect ->
				packet.create
					severity: 1
					message: 'Hello World'
					productKey: '8ygh638f3nn2937t'
					serial: '1234'
			.to.throw('Tag missing')

		it 'should throw if tag is not a number', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: '0'
					message: 'Hello World'
					productKey: '8ygh638f3nn2937t'
					serial: '1234'
			.to.throw('Tag should be a number')

		it 'should throw if no message', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					productKey: '8ygh638f3nn2937t'
					serial: '1234'
			.to.throw('Message missing')

		it 'should throw if message is not a string', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					message: 1234
					productKey: '8ygh638f3nn2937t'
					serial: '1234'
			.to.throw('Message should be a string')

		it 'should throw if message has more than 255 characters', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					message: _.str.repeat('0123456789abcdef', 16)
					productKey: '8ygh638f3nn2937t'
					serial: '1234'
			.to.throw('Message byte limit is 255')

		it 'should throw if no product key', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					message: 'Hello World'
					serial: '1234'
			.to.throw('Product key missing')

		it 'should throw if product key is not a string', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					message: 'Hello World'
					productKey: 1234
					serial: '1234'
			.to.throw('Product key should be a string')

		it 'should throw if no serial', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					message: 'Hello World'
					productKey: '8ygh638f3nn2937t'
			.to.throw('Serial missing')

		it 'should throw if serial is not a string', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					message: 'Hello World'
					productKey: '8ygh638f3nn2937t'
					serial: 1234
			.to.throw('Serial should be a string')

		it 'should throw if serial has more than 31 characters', ->
			m.chai.expect ->
				packet.create
					severity: 1
					tag: 0
					message: 'Hello World'
					productKey: '8ygh638f3nn2937t'
					serial: 'abcdefghijklmnopqrstuvwxyz012345'
			.to.throw('Serial byte limit is 31')

		it 'should encode an array of length 5', ->
			payload = packet.create
				severity: 1
				tag: 0
				message: 'Hello World'
				productKey: '8ygh638f3nn2937t'
				serial: '1234'

			decoded = msgpack.decode(payload)
			m.chai.expect(decoded).to.have.length(5)

		it 'should default the packet version to 1', ->
			payload = packet.create
				severity: 1
				tag: 0
				message: 'Hello World'
				productKey: '8ygh638f3nn2937t'
				serial: '1234'

			decoded = msgpack.decode(payload)
			m.chai.expect(decoded[0]).to.equal(1)

		it 'should compute a severity and tag of 001100101 given 3 and 5', ->
			payload = packet.create
				severity: 3
				tag: 5
				message: 'Hello World'
				productKey: '8ygh638f3nn2937t'
				serial: '1234'

			decoded = msgpack.decode(payload)
			m.chai.expect(decoded[1]).to.equal(parseInt('001100101', 2))

		it 'should put the product key as the third item in the array', ->
			payload = packet.create
				severity: 3
				tag: 5
				message: 'Hello World'
				productKey: '8ygh638f3nn2937t'
				serial: '1234'

			decoded = msgpack.decode(payload)
			m.chai.expect(decoded[2]).to.equal('8ygh638f3nn2937t')

		it 'should put the serial as the fourth item in the array', ->
			payload = packet.create
				severity: 3
				tag: 5
				message: 'Hello World'
				productKey: '8ygh638f3nn2937t'
				serial: '1234'

			decoded = msgpack.decode(payload)
			m.chai.expect(decoded[3]).to.equal('1234')

		it 'should put the message as the fifth item in the array', ->
			payload = packet.create
				severity: 3
				tag: 5
				message: 'Hello World'
				productKey: '8ygh638f3nn2937t'
				serial: '1234'

			decoded = msgpack.decode(payload)
			m.chai.expect(decoded[4]).to.equal('Hello World')
