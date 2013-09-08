Description
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

This cookbook includes support for running tests via Test Kitchen (1.0). This has some requirements.

1. You must be using the Git repository, rather than the downloaded cookbook from the Chef Community Site.
2. You must have Vagrant 1.1 installed.
3. You must have a "sane" Ruby 1.9.3 environment.

Once the above requirements are met, install the additional requirements:

Install the berkshelf plugin for vagrant, and berkshelf to your local Ruby environment.

    vagrant plugin install vagrant-berkshelf
    gem install berkshelf

Install Test Kitchen 1.0 (unreleased yet, use the alpha / prerelease version).

    gem install test-kitchen --pre

Install the Vagrant driver for Test Kitchen.

    gem install kitchen-vagrant

Once the above are installed, you should be able to run Test Kitchen:

    kitchen list
    kitchen test

Install foodcritic

	gem install foodcritic

Run foodcritic:

	rake lint

License
=======

Copyright 2013 Cory Roloff

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.