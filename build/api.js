
/*
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
 */
var Promise, request;

Promise = require('bluebird');

request = Promise.promisifyAll(require('request'));


/**
 * @summary Send an alert to Crow's Nest HTTP endpoint
 * @function
 * @protected
 *
 * @param {String} productSecret - product secret
 * @param {Buffer} payload - msgpack payload
 *
 * @returns {Promise}
 *
 * @example
 * payload = packet.create('...')
 * api.alert('p2f7j308dw0foie4', payload)
 */

exports.alert = function(productSecret, payload) {
  return request.postAsync({
    headers: {
      authorization: "token " + productSecret
    },
    url: 'https://log.crowsnest.io/1',
    body: payload
  }).spread(function(response) {
    var _ref;
    if ((200 <= (_ref = response.statusCode) && _ref < 300)) {
      return response.body || void 0;
    }
    throw new Error("Unknown error: " + response.statusCode);
  });
};
