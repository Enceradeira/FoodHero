require 'nokogiri'

class FoodHeroInfoPList
  class << self
    private
    def food_hero_info_plist_file
      File.join(File.dirname(__FILE__), '../app/FoodHero/FoodHero-Info.plist')
    end

    public
    def cFBundleShortVersionString=(value)
      set_value('CFBundleShortVersionString', value)
    end

    def cFBundleVersion=(value)
      set_value('CFBundleVersion', value)
    end

    def set_value(key, value)
      doc = File.open(food_hero_info_plist_file, 'r') do |file|
        Nokogiri::XML(file)
      end

      key_node = doc.at_xpath("//key[text()='#{key}']")
      value_node = key_node.next_element
      value_node.content = value

      File.open(food_hero_info_plist_file, 'w') do |file|
        file.write(doc.to_xml)
      end
    end
  end

end
