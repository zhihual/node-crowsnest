m = require('mochainon')
Promise = require('bluebird')
_ = require('lodash')
msgpack = require('msgpack-js')
getmac = require('getmac')
api = require('../lib/api')
cn = require('../lib/crowsnest')

describe 'Crowsnest:', ->

	describe '.severity', ->

		it 'should be a plain object', ->
			m.chai.expect(_.isPlainObject(cn.severity)).to.be.true

		it 'should contain number properties', ->
			m.chai.expect(cn.severity).to.have.interface
				DEBUG: Number
				INFO: Number
				ERROR: Number
				CRITICAL: Number

	describe '.config', ->

		it 'should be a plain object', ->
			m.chai.expect(_.isPlainObject(cn.config)).to.be.true

		it 'should have a default getSerial function that returns the MAC address', (done) ->
			cn.config.getSerial (error, serial) ->
				return done(error) if error?
				m.chai.expect(serial).to.be.a('string')
				m.chai.expect(getmac.isMac(serial)).to.be.true
				done()

	describe '.alert()', ->

		describe 'given an unconfigured config object', ->

			beforeEach ->
				delete cn.config.productKey
				delete cn.config.productSecret

			it 'should yield an error if no product key', (done) ->
				cn.config.productSecret = 'p2f7j308dw0foie4'
				cn.alert cn.severity.DEBUG, 0, 'Hello', (error) ->
					m.chai.expect(error).to.be.an.instanceof(Error)
					m.chai.expect(error.message).to.equal('Did you set a productKey in the config object?')
					done()

			it 'should yield an error if no product secret', (done) ->
				cn.config.productKey = '8ygh638f3nn2937t'
				cn.alert cn.severity.DEBUG, 0, 'Hello', (error) ->
					m.chai.expect(error).to.be.an.instanceof(Error)
					m.chai.expect(error.message).to.equal('Did you set a productSecret in the config object?')
					done()

		describe 'given a configured config object', ->

			beforeEach ->
				cn.config.productKey = '8ygh638f3nn2937t'
				cn.config.productSecret = 'p2f7j308dw0foie4'

			describe 'given an api stub that finishes successfully', ->

				beforeEach ->
					@apiAlertStub = m.sinon.stub(api, 'alert')
					@apiAlertStub.returns(Promise.resolve(''))

				afterEach ->
					@apiAlertStub.restore()

				it 'should have been called with the correct data', (done) ->
					cn.alert cn.severity.DEBUG, 0, 'Hello World', (error) =>
						return done(error) if error?

						args = @apiAlertStub.firstCall.args
						m.chai.expect(args[0]).to.equal('p2f7j308dw0foie4')

						cn.config.getSerial (error, serial) ->
							return done(error) if error?

							payload = msgpack.decode(args[1])
							m.chai.expect(payload[0]).to.equal(1)
							m.chai.expect(payload[1]).to.equal(0)
							m.chai.expect(payload[2]).to.equal('8ygh638f3nn2937t')
							m.chai.expect(payload[3]).to.equal(serial)
							m.chai.expect(payload[4]).to.equal('Hello World')

							done()

				it 'should not yield any value', (done) ->
					cn.alert cn.severity.DEBUG, 0, 'Hello World', (error, response) ->
						return done(error) if error?
						m.chai.expect(response).to.not.exist
						done()

				it 'should stringify objects automatically', (done) ->
					cn.alert cn.severity.DEBUG, 0, hello: 'world', (error) =>
						return done(error) if error?

						args = @apiAlertStub.firstCall.args
						payload = msgpack.decode(args[1])
						m.chai.expect(payload[4]).to.equal('{"hello":"world"}')
						done()

				it 'should stringify numbers automatically', (done) ->
					cn.alert cn.severity.DEBUG, 0, 123, (error) =>
						return done(error) if error?

						args = @apiAlertStub.firstCall.args
						payload = msgpack.decode(args[1])
						m.chai.expect(payload[4]).to.equal('123')
						done()

				it 'should return an error if message cannot be stringified', (done) ->
					cn.alert cn.severity.DEBUG, 0, _.noop, (error) ->
						m.chai.expect(error).to.be.an.instanceof(Error)
						m.chai.expect(error.message).to.equal('Cannot stringify message')
						done()

				describe 'given a custom getSerial function', ->

					beforeEach ->
						@getSerialBackup = cn.config.getSerial
						cn.config.getSerial = (callback) ->
							return callback(null, 'custom_serial')

					afterEach ->
						cn.config.getSerial = @getSerialBackup

					it 'should have a custom serial', (done) ->
						cn.alert cn.severity.DEBUG, 0, hello: 'world', (error) =>
							return done(error) if error?

							args = @apiAlertStub.firstCall.args
							payload = msgpack.decode(args[1])
							m.chai.expect(payload[3]).to.equal('custom_serial')
							done()
