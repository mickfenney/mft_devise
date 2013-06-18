# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MftDevise::Application.initialize!

# Date formats
Time::DATE_FORMATS[:human]       = "%A, %e %B %Y"
Time::DATE_FORMATS[:human_short] = "%a, %d %b %Y"

require 'will_paginate'
