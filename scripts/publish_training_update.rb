# frozen_string_literal: true

require 'net/http'
require 'json'
require 'base64'
require 'uri'

DB_FILE = '_data/database.sqlite'

if system("git diff --quiet -- #{DB_FILE}")
  puts 'No training update recorded, nothing to publish.'
  exit
end

api_url = ENV.fetch('CI_API_V4_URL')
project_id = ENV.fetch('CI_PROJECT_ID')
branch = ENV.fetch('CI_COMMIT_REF_NAME')
token = ENV.fetch('GITLAB_PUSH_TOKEN')

uri = URI("#{api_url}/projects/#{project_id}/repository/commits")
request = Net::HTTP::Post.new(uri)
request['PRIVATE-TOKEN'] = token
request['Content-Type'] = 'application/json'
request.body = {
  branch: branch,
  commit_message: 'update trainings',
  actions: [
    {
      action: 'update',
      file_path: DB_FILE,
      content: Base64.strict_encode64(File.binread(DB_FILE)),
      encoding: 'base64'
    }
  ]
}.to_json

response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }

if response.is_a?(Net::HTTPSuccess)
  puts 'Published training update via GitLab API.'
else
  puts "Failed to publish training update: #{response.code} #{response.body}"
  exit(1)
end
