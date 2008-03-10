require 'rubygems'
require 'hpricot/blankslate'

class InlineExecutor < Hpricot::BlankSlate
  def self.create(initial_command)
    new([initial_command])
  end
  
  def initialize(command_stack)
    @command_stack = command_stack
  end
  
  def method_missing(cmd, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    @command_stack << cmd
    @command_stack.push(*args)
    @command_stack.push(*__transform_options__(options))
    InlineExecutor.new(@command_stack)
  end

  def to_command
    @command_stack.join(" ")
  end

  def __transform_options__(options)
    args = []
    options.keys.each do |key|
      options[key.to_s] = options.delete(key)
    end
    options.keys.sort.each do |opt|
      if opt.size == 1
        if options[opt] == true
          args << "-#{opt}"
        else
          val = options.delete(opt)
          args << "-#{opt} '#{val}'"
        end
      else
        if options[opt] == true
          args << "--#{opt.gsub(/_/, '-')}"
        else
          val = options.delete(opt)
          args << "--#{opt.gsub(/_/, '-')}='#{val}'"
        end
      end
    end
    args
  end
end