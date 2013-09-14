chef-npm-registry [![Build Status](https://travis-ci.org/coryroloff/chef-npm-registry.png?branch=master)](https://travis-ci.org/coryroloff/chef-npm-registry) [![Dependency Status](https://gemnasium.com/coryroloff/chef-npm-registry.png)](https://gemnasium.com/coryroloff/chef-npm-registry)
===========

Installs and configures an NPM package registry using the official [NPM project layout](https://github.com/isaacs/npmjs.org). If you are installing this locally (such as with Vagrant), it is recommended you set the attributes `node['couch_db']['httpd']['bind_address']` to `"0.0.0.0"` and `node['couch_db']['httpd']['secure_rewrites']` to `false`.

Requirements
============

Platform
--------

* Ubuntu

Tested on:

* Ubuntu 12.04
* Ubuntu 12.10

Cookbooks
---------

Requires Opscode's [git](http://community.opscode.com/cookbooks/git) and [couchdb](http://community.opscode.com/cookbooks/couchdb) cookbooks and Marius Ducea's [nodejs](http://community.opscode.com/cookbooks/nodejs) cookbook. Opscode's [cron](http://community.opscode.com/cookbooks/cron) cookbook is required for scheduled replication. See Attributes and Usage for more information.

Attributes
==========

See the attributes/defaults.rb for default values.

* `node['npm_registry']['git']['url']` - The URL to NPM's registry repository. Attribute is provided in case the repository is ever moved.
* `node['npm_registry']['git']['reference']` - The branch or tag name to checkout from the Git repository.
* `node['npm_registry']['couchdb']['couch']` - The full path to your .couch file.
* `node['npm_registry']['couchdb']['username']` - The username for authenticating against your database.
* `node['npm_registry']['couchdb']['password']` - The password for authentication against your database.
* `node['npm_registry']['couchdb']['port']` - The port number your database is running on.
* `node['npm_registry']['registry']['url']` - The URL to your locally installed NPM registry.
* `node['npm_registry']['isaacs']['registry']['url']` - The URL to the official NPM registry (used for replication).
* `node['npm_registry']['replication']['use_replication']` - Whether to use replication.
* `node['npm_registry']['replication']['cron']['use_cron']` - Whether to use cron for replication.
* `node['npm_registry']['replication']['cron']['minute']` - The cron minute value.
* `node['npm_registry']['replication']['cron']['hour']` - The cron hour value.
* `node['npm_registry']['replication']['cron']['weekday']` - The cron weekday value.
* `node['npm_registry']['replication']['cron']['day']` - The cron day value.
* `node['npm_registry']['replication']['cron']['month']` - The cron month value.

Usage
=====

To install and configure the default NPM package registry, use:

`{ "run_list": ["recipe[npm_registry]"] }`

To use replication with cron, use:

`{ "run_list": ["recipe[cron]", "recipe[npm_registry]"] }`

Testing
=======

This cookbook includes support for running tests via FoodCritic, ChefSpec and Test Kitchen.

Install Vagrant:

	http://downloads.vagrantup.com/

Install Gem dependencies:

	bundle install

Install Cookbook dependencies:

	berks install

Run Bundler:

	bundle exec strainer test