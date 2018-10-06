module Fastlane
  module Actions
    module SharedValues
      GIT_COMMIT_ALL_CUSTOM_VALUE = :GIT_COMMIT_ALL_CUSTOM_VALUE
    end

    class GitCommitAllAction < Action
      def self.run(params)
        Actions.sh "pod package \"#{params[:podspec]}\""
      end

      def self.description
        "Commit all unsaved changes to git."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :message,
            env_name: "FL_GIT_COMMIT_ALL",
            description: "The git message for the commit",
            is_string: true
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
