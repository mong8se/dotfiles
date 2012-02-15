# Enable tab-completion.
require 'irb/completion'

# Auto-indentation.
IRB.conf[:AUTO_INDENT] = true

# Readline-enable prompts.
require 'irb/ext/save-history'
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_PATH] = File::expand_path("~/.irb.history")

# Colorize results
require 'wirble'
wirble_opts = {
    :colors => {
      :object_class => :brown,
      :symbol => :purple,
      :symbol_prefix => :purple
    },
    :init_color => true,
}
Wirble.init(wirble_opts)

require 'bond'
Bond.start

# require 'ap'
# unless IRB.version.include?('DietRB')
#   IRB::Irb.class_eval do
#     def output_value
#       ap @context.last_value
#     end
#   end
# else # MacRuby
#   IRB.formatter = Class.new(IRB::Formatter) do
#     def inspect_object(object)
#       object.ai
#     end
#   end.new
# end
