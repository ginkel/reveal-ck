require 'asciidoctor'

module RevealCK
  module Commands
    # This Command is responsible for implementing the idea behind
    # "reveal-ck generate."
    class Generate
      include Retrieve
      attr_reader :slides_file, :stdout_prefix

      def initialize(args)
        @application = Rake::Application.new
        @user_dir = retrieve(:user_dir, args)
        @gem_dir = retrieve(:gem_dir, args)
        @output_dir = retrieve(:output_dir, args)
        @stdout_prefix = args[:stdout_prefix] || ''
        @slides_file = retrieve(:slides_file, args)
        # @slides_builder =
        #   RevealCK::Builders::SlidesBuilder.new(user_dir: user_dir,
        #                                         gem_dir: gem_dir,
        #                                         output_dir: output_dir,
        #                                         slides_file: slides_file)
      end

      def run
        msg = "Generating slides for '#{slides_file}'.."
        msg = "#@stdout_prefix #{msg}" unless @stdout_prefix.empty?
        puts msg
        copy_user_files
        Asciidoctor.convert_file('slides.adoc',
                                 safe: Asciidoctor::SafeMode::SAFE,
                                 to_file: File.join(@output_dir, 'index.html'),
                                 template_dir: File.join(@gem_dir, 'files/asciidoctor-reveal.js/templates/slim')
        )
      end

      def copy_user_files
        msg = "Copying user files from #@user_dir..."
        msg = "#@stdout_prefix #{msg}" unless @stdout_prefix.empty?
        puts msg
        user_files = RevealCK::Builders::UserFiles.new(dir: @user_dir)
        copy_files(user_files)
        @application['copy_files_task'].invoke
      end

      def copy_files(file_listing)
        task = RevealCK::Builders::CopyFilesTask.new(file_listing: file_listing,
                                                     output_dir: @output_dir,
                                                     application: @application)
        task.prepare
      end
    end
  end
end
