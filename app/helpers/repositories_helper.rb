# frozen_string_literal: true

module RepositoriesHelper
  def commit_link(repository_full_name, commit_id)
    return if commit_id.blank?

    link = "https://github.com/#{repository_full_name}/commit/#{commit_id}"
    link_to commit_id, link, target: '_blank', rel: 'noopener'
  end
end
