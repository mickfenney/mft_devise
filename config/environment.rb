# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MftDevise::Application.initialize!

require 'will_paginate'

require "enumerated_attribute"