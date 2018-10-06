module Fastlane
  module Actions
    module SharedValues
      POD_PACKAGE_CUSTOM_VALUE = :POD_PACKAGE_CUSTOM_VALUE
    end

    class PodPackageAction < Action
      def self.run(params)
        cmds = [
          "pod package \"#{params[:podspec_name]}.podspec\"",
          "rm -rf Frameworks/#{params[:podspec_name]}-#{params[:version]}",
        ].compact
        result = Actions.sh(cmds.join('&'))
        result = Actions.sh("mv #{params[:podspec_name]}-#{params[:version]} Frameworks")
        UI.message("pod package finish 🚀")
        return result
      end

      def self.description
        "pod package xxx.podspec"
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(
            key: :podspec_name,
            # env_name: "FL_POD_PACKAGE_API_TOKEN", # The name of the environment variable
            description: "podspec filename",
            is_string: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            # env_name: "FL_POD_PACKAGE_API_TOKEN", # The name of the environment variable
            description: "podspec version",
            is_string: true
          )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['POD_PACKAGE_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
