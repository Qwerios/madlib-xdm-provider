# madlib-xdm-provider
[![Build Status](https://travis-ci.org/Qwerios/madlib-xdm-provider.svg?branch=master)](https://travis-ci.org/Qwerios/madlib-xdm-provider) [![NPM version](https://badge.fury.io/js/madlib-xdm-provider.png)](http://badge.fury.io/js/madlib-xdm-provider) [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)

The server-side XDM provider files for madlib-xhr-xdm


## acknowledgments
The Marviq Application Development library (aka madlib) was developed by me when I was working at Marviq. They were cool enough to let me publish it using my personal github account instead of the company account. We decided to open source it for our mutual benefit and to ensure future updates should I decide to leave the company.


## philosophy
JavaScript is the language of the web. Wouldn't it be nice if we could stop having to rewrite (most) of our code for all those web connected platforms running on JavaScript? That is what madLib hopes to achieve. The focus of madLib is to have the same old boring stuff ready made for multiple platforms. Write your core application logic once using modules and never worry about the basics stuff again. Basics including XHR, XML, JSON, host mappings, settings, storage, etcetera. The idea is to use the tried and proven frameworks where available and use madlib based modules as the missing link.

Currently madLib is focused on supporting the following platforms:

* Web browsers (IE6+, Chrome, Firefox, Opera)
* Appcelerator/Titanium
* PhoneGap
* NodeJS


## installation
```bash
$ npm install madlib-xdm-provider --save
```

## usage
The Cross Domain version of the madlib XHR requires knowledge of the following other madlib modules:
* [xhr](https://github.com/Qwerios/madlib-xhr)
* [xhr-xdm](https://github.com/Qwerios/madlib-xhr-xdm)
* [hostmapping](https://github.com/Qwerios/madlib-hostmapping)
* [settings](https://github.com/Qwerios/madlib-settings)

Unzip and deploy on your server. Then configure the xdm settings pointing to where you deployed it.

You can check the documentation for [madlib-xhr-xdm](https://github.com/Qwerios/madlib-xhr-xdm) for configuration and usage examples