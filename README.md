# "Compress my Mojo/Enyo - Linux & Mac OS X"

## Compresses your webOS-Applications and builds packages

**Copyright (c) 2011, R. Kowalski**
**All rights reserved.**

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:


Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Updates:

We added support for node-services in your app, example usage: 

    $ compress-my-mojo -s BasicService/ servicesample.application/ servicesample.srv/ servicesample.package/


We are now supporting UglifyJS for node.js which makes the build a lot of faster 

## Installation Notes:

### Needed:

- Ruby
- OS: currently Linux / Mac OS X are supported

#### If using the fast UglifyJS:

* Node.js - get node at: https://github.com/joyent/node/wiki/Installation
* npm

#### Or if using slower YUI Compressor or Google Closure Compiler:

* Java (also in your $PATH) 
* [YUI-Compressor](http://yuilibrary.com/downloads/#yuicompressor) AND/OR [Google Closure Compiler](http://closure-compiler.googlecode.com/files/compiler-latest.zip)


### Configurate:

#### UglifyJS

1. Install node.js & npm
2. Install UglifyJS 

    `npm install uglify-js`


3. add the path to uglify-js/bin to your $PATH at end of your .bashrc, for example: 
    
    `export PATH="$PATH:~/node_modules/uglify-js/bin"`


#### YUI-Compressor or Google Compiler

* Set your path to [YUI-Compressor](http://yuilibrary.com/downloads/#yuicompressor) or [Google Closure Compiler](http://closure-compiler.googlecode.com/files/compiler-latest.zip) jar in rb-file or place them in the directory of this project

#### Location awareness

* Add the directory of (a link to) compress-my-mojo to your $PATH at end of your .bashrc, for example:

    `export PATH="$PATH:/your/path/to/compress-my-mojo"`

## Compress JS (& CSS) and build IPK:

    $ compress-my-mojo [-i|v1|g|ugly|s] <PROJECTFOLDER-Name>

Options:

-i install to default device

-v1 package for >= webOS 1.4.x devices (old format)

-g to use google closure compiler (default is YUI-Compressor)

-ugly to use UglifyJS (default is YUI-Compressor)

-s for service-mode, if you package an app with webOS Javascript Services, usage:

    $ compress-my-mojo BasicApp/ -s servicesample.application/ servicesample.srv/ servicesample.package/

or combine them: -iv1g to package for webOS 1.4.x devices (old format), using Google Closure Compiler and installing them

## Commit:

We use 2 spaces as tab size for intendation.

## Contributors

Special thanks to [madnificent](https://github.com/madnificent) & [rretsiem](https://github.com/rretsiem) 