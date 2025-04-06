require 'bundler/setup'
require './karafka'  # Load Karafka configuration

# Mount the Karafka Web UI
run Karafka::Web::App
