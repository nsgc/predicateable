# frozen_string_literal: true

require_relative "lib/predicateable/version"

Gem::Specification.new do |spec|
  spec.name = "predicateable"
  spec.version = Predicateable::VERSION
  spec.authors = ["Naoki Nishiguchi"]

  spec.summary = "Dynamically defines predicate methods based on symbolic return values."
  spec.description = "Predicateable allows you to define predicate methods (like `admin?`) based on a method that returns a Symbol. Similar to Rails enums, with optional strict checking and prefix support."

  spec.homepage = "https://github.com/nsgc/predicateable"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nsgc/predicateable.git"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.22"
  spec.add_development_dependency "rbs",   "~> 3.9"
  spec.add_development_dependency "steep", "~> 1.10"
end
