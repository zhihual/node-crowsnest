node-crowsnest
--------------

[![npm version](https://badge.fury.io/js/crowsnest.svg)](http://badge.fury.io/js/crowsnest)
[![dependencies](https://david-dm.org/jviotti/node-crowsnest.png)](https://david-dm.org/jviotti/node-crowsnest.png)
[![Build Status](https://travis-ci.org/jviotti/node-crowsnest.svg?branch=master)](https://travis-ci.org/jviotti/node-crowsnest)

NodeJS [Crow's Nest](https://www.crowsnest.io) SDK.

```javascript
var cn = require('crowsnest');

// Grab these from the profile section
cn.config.productKey = '8ygh638f3nn2937t';
cn.config.productSecret = 'p2f7j308dw0foie4';

cn.alert(cn.severity.DEBUG, 1, 'Hello World');
```

Installation
------------

Install `node-crowsnest` by running:

```sh
$ npm install --save crowsnest
```

Documentation
-------------


* [cn](#module_cn)
  * [.severity](#module_cn.severity)
    * [.DEBUG](#module_cn.severity.DEBUG) : <code>Number</code>
    * [.INFO](#module_cn.severity.INFO) : <code>Number</code>
    * [.ERROR](#module_cn.severity.ERROR) : <code>Number</code>
    * [.CRITICAL](#module_cn.severity.CRITICAL) : <code>Number</code>
  * [.config](#module_cn.config)
    * [.getSerial](#module_cn.config.getSerial)
  * [.alert(severity, tag, message, callback)](#module_cn.alert)

<a name="module_cn.severity"></a>
### cn.severity
This severity table matches Crow's Nest v1 packet spec.

**Kind**: static property of <code>[cn](#module_cn)</code>  
**Summary**: Crow&#x27;s Nest severity table  
**Access:** public  

* [.severity](#module_cn.severity)
  * [.DEBUG](#module_cn.severity.DEBUG) : <code>Number</code>
  * [.INFO](#module_cn.severity.INFO) : <code>Number</code>
  * [.ERROR](#module_cn.severity.ERROR) : <code>Number</code>
  * [.CRITICAL](#module_cn.severity.CRITICAL) : <code>Number</code>

<a name="module_cn.severity.DEBUG"></a>
#### severity.DEBUG : <code>Number</code>
**Kind**: static property of <code>[severity](#module_cn.severity)</code>  
**Summary**: Describe a debug event  
**Access:** public  
<a name="module_cn.severity.INFO"></a>
#### severity.INFO : <code>Number</code>
**Kind**: static property of <code>[severity](#module_cn.severity)</code>  
**Summary**: Describe an information event  
**Access:** public  
<a name="module_cn.severity.ERROR"></a>
#### severity.ERROR : <code>Number</code>
**Kind**: static property of <code>[severity](#module_cn.severity)</code>  
**Summary**: Describe an error event  
**Access:** public  
<a name="module_cn.severity.CRITICAL"></a>
#### severity.CRITICAL : <code>Number</code>
**Kind**: static property of <code>[severity](#module_cn.severity)</code>  
**Summary**: Describe a critical event  
**Access:** public  
<a name="module_cn.config"></a>
### cn.config
This object should be edited to add the following properties:

- `String productKey`.
- `String productSecret`.

**Kind**: static property of <code>[cn](#module_cn)</code>  
**Summary**: Configuration object  
**Access:** public  
<a name="module_cn.config.getSerial"></a>
#### config.getSerial
This function returns the device MAC address by default. You may customise it to fit your needs as follows:

```javascript
cn.config.getSerial = function(callback) {
	return callback(null, 'mySerial');
};
```

**Kind**: static property of <code>[config](#module_cn.config)</code>  
**Summary**: Get the serial number of a device  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| callback | <code>function</code> | callback (error, serial) |

**Example**  
```js
cn.config.getSerial(function(error, serial) {
	if (error) throw error;
	console.log(serial);
});
```
<a name="module_cn.alert"></a>
### cn.alert(severity, tag, message, callback)
Notice you must set `cn.config.productKey` and `cn.config.productSecret` before using this function.

The `serial` property defaults to the MAC address of the running device. You may set a new function to `cn.config.getSerial` to customise this.

**Kind**: static method of <code>[cn](#module_cn)</code>  
**Summary**: Send an event to Crow&#x27;s Nest  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| severity | <code>Number</code> | severity |
| tag | <code>Number</code> | tag |
| message | <code>\*</code> | message |
| callback | <code>function</code> | callback (error, response) |

**Example**  
```js
var cn = require('crowsnest');

// Grab these from the profile section
cn.config.productKey = '8ygh638f3nn2937t';
cn.config.productSecret = 'p2f7j308dw0foie4';

cn.alert(cn.severity.DEBUG, 1, 'Hello World', function(error, response) {
	if (error) throw error;
	console.log(response);
});
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/jviotti/node-crowsnest/issues/new) on GitHub and I'll be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ npm test
```

Contribute
----------

- Issue Tracker: [github.com/jviotti/node-crowsnest/issues](https://github.com/jviotti/node-crowsnest/issues)
- Source Code: [github.com/jviotti/node-crowsnest](https://github.com/jviotti/node-crowsnest)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the MIT license.
