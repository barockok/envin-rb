
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "envin/version"

Gem::Specification.new do |spec|
  spec.name          = "envin"
  spec.version       = Envin::VERSION
  spec.authors       = ["Zidni Mubarock"]
  spec.email         = ["zidmubarock@gmail.com"]

  spec.summary       = %q{Build yaml file from OS environment variables}
  spec.description   = %q{Build yaml file from OS environment variables}
  spec.homepage      = "https://github.com/barockok"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ["envin"]
  spec.require_paths = ["lib"]
end
