# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
).each { |path| Spring.watch(path) }
