# Run Development Mode
# To run:
# sh dev_run
# Notice: In VM, the env is development as default.

bash start_sidekiq.sh
rails s -b 0.0.0.0 -e development

