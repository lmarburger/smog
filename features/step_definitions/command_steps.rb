When /^I run the command:$/ do |command|
  When "I run #{ command.inspect }"
end
