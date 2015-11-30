require 'asciidoctor'

module RevealCK
  module Commands
    # This Command is responsible for implementing the idea behind
    # "reveal-ck generate."
    class Generate
      include Retrieve
      attr_reader :slides_file, :stdout_prefix

      def initialize(args)
        user_dir = retrieve(:user_dir, args)
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
        msg = "#{stdout_prefix} #{msg}" unless stdout_prefix.empty?
        puts msg
        Asciidoctor.convert_file('slides.adoc',
                                 safe: Asciidoctor::SafeMode::SAFE,
                                 to_file: File.join(@output_dir, 'index.html'),
                                 template_dir: File.join(@gem_dir, 'files/asciidoctor-reveal.js/templates/slim')
        )
      end
    end
  end
end
