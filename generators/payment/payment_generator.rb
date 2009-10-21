class PaymentGenerator < RubiGen::Base

  default_options :author => nil

  attr_reader :name, :class_name, :model_dir, :spec_dir, :file_base_name

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    @class_name = "#{@name.camelize}Payment"
    @file_base_name = "#{@name.underscore}_payment"
    @model_dir = File.join('lib','payments')
    @spec_dir = File.join('spec','lib')
    @model_file =  File.join(@model_dir,"#{@file_base_name}.rb")
    @spec_file = File.join(spec_dir,"#{@file_base_name}_spec.rb")
    
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory model_dir
      m.directory spec_dir

      # Create stubs
      m.template           "model.rb.erb", @model_file
      m.template           "spec.rb.erb", @spec_file
    
    end
  end

  protected
    def banner
      <<-EOS
Creates a new DTA payment model

USAGE: #{$0} #{spec.name} name
EOS
    end

    def add_options!(opts)
      # opts.separator ''
      # opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |o| options[:author] = o }
      # opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
    
    def camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      else
        lower_case_and_underscored_word.first.downcase + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end
    
    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
end