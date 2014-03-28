# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'active_support/inflector'

guard :rspec, cmd: 'rspec --color --format nested ', all_on_start: false, all_after_pass: false do

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }

  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    %W[
      spec/models/#{m[1].singularize}_spec.rb
      spec/controllers/#{m[1].singularize}_controller_spec.rb
      spec/features/#{m[1].singularize}_spec.rb
    ]
  end

  watch('spec/spec_helper.rb') { "spec" }
  watch('config/routes.rb') { "spec/routing" }
  watch('app/controllers/application_controller.rb') { "spec/controllers" }

  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$}) { |m| "spec/features/#{m[1]}_spec.rb" }

  watch(%r{^spec/features/(.+)\.rb$}) { |m| "spec/features/#{m[1]}_spec.rb" }

end

unless RUBY_PLATFORM =~ /mingw/i
  if `hostname` =~ /asus/i
     notification :libnotify, :timeout => 4, :transient => false, :append => true
  end
end
