require 'nokogiri'

class AppVersion
  class << self
    private
    def read_version_value(version)
      File.open(version_definition_file) do |file|
        Nokogiri::XML(file).xpath("/Version/#{version}/node()")
      end
    end

    def version_definition_file
      File.join(File.dirname(__FILE__), '../app-version.xml')
    end

    def write_version_value(version, value)
      doc = File.open(version_definition_file, 'r') do |file|
        Nokogiri::XML(file)
      end

      fragment = doc.at_css(version)
      fragment.content = value

      File.open(version_definition_file, 'w') do |file|
        file.write(doc.to_xml)
      end
    end

    public
    def version
      read_version_value('CFBundleShortVersionString')
    end

    def build
      read_version_value('CFBundleVersion').to_s.to_i
    end

    def build=(version)
      write_version_value('CFBundleVersion', version )
    end
  end
end
