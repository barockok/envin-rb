require 'envin/converter'
require 'optparse'
module Envin
  module CLI
    extend self
    attr_reader :option
    def parse(args=ARGV)
      opts = {
        rootelement: "production"
      }

      parser = OptionParser.new do |opt_parser|
        opt_parser.on '-f', '--filepath FILENAME', 'file path' do |arg|
          opts[:filepath] = File.expand_path(arg)
        end

        opt_parser.on '-p', '--prefix PREFIX', 'env prefix' do |arg|
          opts[:prefix] = arg
        end

        opt_parser.on '-r', '--root-element ELEMENT', 'root element' do |arg|
          opts[:rootelement] = arg
        end
      end

      parser.on_tail "-h", "--help", "Show help" do
        puts parser
        die 1
      end

      parser.parse!(args)
      @option = opts
    end

    def run
      if !option[:filepath] || !option[:prefix]
        puts "File path & prefix is required"
        exit(1)
      end
      Converter.overwrite(option[:filepath], option[:prefix], option[:rootelement])
    end
  end
end
