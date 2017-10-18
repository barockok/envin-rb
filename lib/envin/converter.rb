require 'yaml'
require 'erb'

module Envin
  module Converter
    extend self
    def load_yaml file, root_element="production"
      return {} if !File.exists?(file)
      file_content = ERB.new(File.read(file)).result
      content = YAML.load(file_content)
      (!root_element ? content : content[root_element]) || {}
    end

    def build_child_split(key_split, v, coll=[], level=0)
      key_identifier = key_split.take(level + 1).join('-')
      lines = ""
      if !coll.include?(key_identifier) && key_split.length != level + 1
        coll << key_identifier
        lines += "#{' ' * level}#{key_split[level].downcase}:\n"
        child_line, _ = build_child_split(key_split, v,coll, level+1)
        lines += child_line
      else
        lines += "#{' ' * (key_split.length - 1) }#{key_split.last.downcase}: #{v}\n"
      end
      return lines, coll
    end

    def build_yaml_from_env prefix
      env_prefix = ENV.select{|k,v| k =~ /#{prefix}/ }
      coll = []
      lines = ""
      Hash[env_prefix.sort].each do |key, v|
        key_split = key.split("__")
        if key_split.length == 1
          lines += "#{key.gsub(prefix, '').downcase}: #{v}\n"
        elsif key_split.length > 1
          key_split[0] = key_split[0].gsub(prefix, '').downcase
          child_line, coll = build_child_split(key_split, v, coll)
          lines += child_line
        end
      end

      if lines != ""
        YAML.load(lines)
      else
        return {}
      end
    end

    def overwrite source_file:, target_file: false , prefix:, root_element: "production"
      target_file = source_file if !target_file
      config_content = File.exist?(source_file) ? load_yaml(source_file, root_element) : {}
      config_env     = build_yaml_from_env(prefix)

      root = {}
      if root_element
        root[root_element] = config_content.merge(config_env)
      else
        root = config_content.merge(config_env)
      end

      File.delete(target_file) if File.exist?(target_file)
      File.write(target_file, YAML.dump(root))
    end
  end
end