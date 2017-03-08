require "#{Rails.root}/app/helpers/payload_helper"
#include PayloadHelper
namespace :commit do
  desc "TODO"
  task fetch: :environment do
    Octokit.auto_paginate = true
    repositories = Octokit.organization_repositories('refactory-id')
    repositories.each do |repository|
      response = Octokit.commits(repository.full_name) 
      response.each do |commit|
        next if commit.pull_request != nil
        next if /merge/i.match commit.commit.message
        next if commit.author == nil
        current_commit = {
            head_commit: {
              author: commit.commit.author.to_h.merge(username: commit.author.login),
              message: commit.commit.message,
              timestamp: DateTime.parse(commit.commit.committer.date.to_s).to_s,
              id: commit.sha
          },
          repository: repository.to_h
        }
        PayloadHelper::PayloadProcess.new(current_commit).save_payload
      end
    end
  end

end
