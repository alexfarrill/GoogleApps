# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{GoogleApps}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Farrill"]
  s.date = %q{2009-10-26}
  s.description = %q{Use the GoogleApps API}
  s.email = %q{alex.farrill@gmail.com}
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "lib/google_apps.rb"]
  s.files = ["CHANGELOG", "GoogleApps.gemspec", "Manifest", "README.rdoc", "Rakefile", "google_apps", "init.rb", "lib/google_apps.rb", "test_rails_app/README", "test_rails_app/Rakefile", "test_rails_app/app/controllers/application_controller.rb", "test_rails_app/app/helpers/application_helper.rb", "test_rails_app/config/boot.rb", "test_rails_app/config/database.yml", "test_rails_app/config/environment.rb", "test_rails_app/config/environments/development.rb", "test_rails_app/config/environments/production.rb", "test_rails_app/config/environments/test.rb", "test_rails_app/config/google_apps.yml", "test_rails_app/config/initializers/backtrace_silencers.rb", "test_rails_app/config/initializers/inflections.rb", "test_rails_app/config/initializers/mime_types.rb", "test_rails_app/config/initializers/new_rails_defaults.rb", "test_rails_app/config/initializers/session_store.rb", "test_rails_app/config/locales/en.yml", "test_rails_app/config/routes.rb", "test_rails_app/db/development.sqlite3", "test_rails_app/db/schema.rb", "test_rails_app/db/seeds.rb", "test_rails_app/db/test.sqlite3", "test_rails_app/doc/README_FOR_APP", "test_rails_app/public/404.html", "test_rails_app/public/422.html", "test_rails_app/public/500.html", "test_rails_app/public/favicon.ico", "test_rails_app/public/images/rails.png", "test_rails_app/public/index.html", "test_rails_app/public/javascripts/application.js", "test_rails_app/public/javascripts/controls.js", "test_rails_app/public/javascripts/dragdrop.js", "test_rails_app/public/javascripts/effects.js", "test_rails_app/public/javascripts/prototype.js", "test_rails_app/public/robots.txt", "test_rails_app/script/about", "test_rails_app/script/console", "test_rails_app/script/dbconsole", "test_rails_app/script/destroy", "test_rails_app/script/generate", "test_rails_app/script/performance/benchmarker", "test_rails_app/script/performance/profiler", "test_rails_app/script/plugin", "test_rails_app/script/runner", "test_rails_app/script/server", "test_rails_app/test/mocks/test/httparty.rb", "test_rails_app/test/performance/browsing_test.rb", "test_rails_app/test/test_helper.rb", "test_rails_app/test/unit/calendars_test.rb"]
  s.homepage = %q{http://github.com/alexfarrill/GoogleApps}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "GoogleApps", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{googleapps}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Use the GoogleApps API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
