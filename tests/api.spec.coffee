m = require('mochainon')
nock = require('nock')
api = require('../lib/api')
packet = require('../lib/packet')

TEST_PACKET = packet.create
	severity: 1
	tag: 0
	message: 'Hello World'
	productKey: '8ygh638f3nn2937t'
	serial: '1234'

describe 'API:', ->

	describe '.alert()', ->

		describe 'given an endpoint that returns the request authorization header', ->

			beforeEach ->
				nock('https://log.crowsnest.io').post('/1').reply 200, ->
					return @req.headers.authorization

			afterEach ->
				nock.cleanAll()

			it 'should send a valid authorization header', ->
				promise = api.alert('p2f7j308dw0foie4', TEST_PACKET)
				m.chai.expect(promise).to.eventually.equal('token p2f7j308dw0foie4')

		describe 'given an endpoint that returns 204 and an empty body', ->

			beforeEach ->
				nock('https://log.crowsnest.io').post('/1').reply(204, '')

			afterEach ->
				nock.cleanAll()

			it 'should resolve undefined', ->
				promise = api.alert('p2f7j308dw0foie4', TEST_PACKET)
				m.chai.expect(promise).to.eventually.be.undefined

		describe 'given an endpoint that returns an error code', ->

			beforeEach ->
				nock('https://log.crowsnest.io').post('/1').reply(500, '')

			afterEach ->
				nock.cleanAll()

			it 'should be rejected with an unknown error', ->
				promise = api.alert('p2f7j308dw0foie4', TEST_PACKET)
				m.chai.expect(promise).to.be.rejectedWith('Unknown error: 500')
