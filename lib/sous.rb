# frozen_string_literal: true

require_relative "sous/version"

# Sous is my little helper. Leave me and my child alone.
module Sous
  class Error < StandardError
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  #
  # I always get myself into a situation where I refactor or change something and
  # it shouldn't be on this branch. This method assumes that I have commited the code that
  # I want to save to my current branch. I need to add the files that I want to
  # add to the new file so I can toss them in a stash, pop it in another branch
  # and then commit and push it up and then return to the original branch
  def self.commit_to_other_branch(new_branch, message)
    original_branch = `git rev-parse --abbrev-ref HEAD`.strip
    raise "Failed to get the current branch name" unless $?.success?

    system("git stash") or raise "Failed to stash changes"
    system("git checkout -b \"#{new_branch}\"") or
      raise "Failed to create and switch to new branch"
    system("git stash pop") or raise "Failed to apply stashed changes"
    system("git add .") or raise "Failed to add changes"
    system("git commit -m \"#{message}\"") or raise "Failed to commit changes"
    system("git push -u origin \"#{new_branch}\"") or
      raise "Failed to push new branch to remote"
    system("git checkout \"#{original_branch}\"") or
      raise "Failed to switch back to original branch"
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
end
