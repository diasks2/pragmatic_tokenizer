lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pragmatic_tokenizer/version'

Gem::Specification.new do |spec|
  spec.name          = "pragmatic_tokenizer"
  spec.version       = PragmaticTokenizer::VERSION
  spec.authors       = ["Kevin S. Dias"]
  spec.email         = ["diasks2@gmail.com"]

  spec.summary       = 'A multilingual tokenizer'
  spec.description   = 'A multilingual tokenizer to split a string into tokens.'
  spec.homepage      = 'https://github.com/diasks2/pragmatic_tokenizer'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "unicode"
  spec.add_runtime_dependency "unicode-emoji"
  spec.add_development_dependency "bundler", "> 1.9"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "stackprof"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rubocop"
end
