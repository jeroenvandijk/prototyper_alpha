require File.join(File.dirname(__FILE__), '../../lib/prototyper/generator')

class PrototypeConcernGenerator < Rails::Generator::NamedBase

  attr_reader :prototype

  def manifest

    @prototype = Prototyper::Base.find_prototype_for(options[:for])
    raise "Couldn't find prototype '#{@prototype.name}'" unless @prototype

    record do |m|
      concern_path = File.join('app/models', "#{@prototype.name}_concerns")
      m.directory(concern_path)
      m.template("concern.rb", File.join(concern_path, "#{@name}.rb"))
    end
  end


  protected

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--for=prototype", String,
           "The name of the prototype") { |v| options[:for] = v }
  end

end