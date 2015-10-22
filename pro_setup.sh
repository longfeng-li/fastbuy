# Setup Production Mode
# To run
# . pro_setup.sh

export SECRET_KEY_BASE=$(rake secret RAILS_ENV=production) 
rake db:drop db:migrate db:seed RAILS_ENV=production
rake assets:precompile RAILS_ENV=production
