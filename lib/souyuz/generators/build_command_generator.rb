# -*- encoding : utf-8 -*-
module Souyuz
  # Responsible for building the fully working xbuild command
  class BuildCommandGenerator
    class << self
      def generate
        parts = prefix
        parts << "xbuild"
        parts += options
        parts += targets
        parts += project
        parts += pipe

        parts
      end

      def prefix
        ["set -o pipefail &&"]
      end

      def options
        config = Souyuz.config

        options = []
        options << "/p:Configuration=#{config[:build_configuration]}" if config[:build_configuration]
        options << "/p:Platform=#{config[:build_platform]}" if Souyuz.project.ios? and config[:build_platform]
        options << "/p:BuildIpa=true" if Souyuz.project.ios?

        options
      end

      def build_targets
        Souyuz.config[:build_target].map! { |t| "/t:#{t}" }
      end

      def targets
        targets = []
        targets += build_targets
        targets << "/t:SignAndroidPackage" if Souyuz.project.android?

        targets
      end

      def project
        path = []

        path << Souyuz.config[:project_path] if Souyuz.project.android?
        path << Souyuz.config[:solution_path] if Souyuz.project.ios? or Souyuz.project.osx?

        path
      end

      def pipe
        pipe = []

        pipe
      end
    end
  end
end
