# config/initializers/wisper.rb

Wisper.subscribe(ProjectGridTableRowListener.new)
Wisper.subscribe(PublishedFileListener.new, async: true)
