# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( jquery.Jcrop.css )
Rails.application.config.assets.precompile += %w( jquery.Jcrop.min.js )

Rails.application.config.assets.precompile += %w( jstree/themes/default/style.min.css )
Rails.application.config.assets.precompile += %w( jstree/jstree.min.js )

Rails.application.config.assets.precompile += %w( jquery-validate/jquery.validate.min.js, jquery-validate/additional-methods.min.js)

# http://harvesthq.github.io/chosen/
Rails.application.config.assets.precompile += %w( chosen/chosen.jquery.js chosen/chosen.css)

# Assets copied over from oldtrope
Rails.application.config.assets.precompile += %w( twentyfourteen/* genericons/genericons.css )