module Fastlane
  module Actions
    module SharedValues
      GIT_REMOVE_TAG_CUSTOM_VALUE = :GIT_REMOVE_TAG_CUSTOM_VALUE
    end

    class GitRemoveTagAction < Action
      def self.run(params)
        tageName = params[:tag]
        isRemoveLocationTag = params[:isRL]
        isRemoveRemoteTag = params[:isRR]

        cmds = [
          ("git tag -d #{tageName}" if isRemoveLocationTag),
          ("git push origin :#{tageName}" if isRemoveRemoteTag),
        ].compact

        result = Actions.sh(cmds.join('&'))
        UI.message("执行完毕 remove_tag的操作 🚀")
        result
      end

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :tag,
            description: "tag 号是多少",
            optional:false,
            is_string: true
          ),

          FastlaneCore::ConfigItem.new(
            key: :isRL,
            description: "是否删除本地标签",
            optional:true,
            is_string: false,
            default_value: true
          ), 

          FastlaneCore::ConfigItem.new(
            key: :isRR,
            description: "是否删除远程标签",
            optional:true,
            is_string: false,
            default_value: true
          ) 
        ]
      end

      def self.output
        [
          ['GIT_REMOVE_TAG_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
      end

      def self.authors
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
