#To run:
#sh dev_setup.sh

RAILS_ENV=development rake sunspot:solr:stop
RAILS_ENV=development rake sunspot:solr:start
rake db:drop db:create db:migrate db:seed RAILS_ENV=development
RAILS_ENV=development rake sunspot:solr:reindex
