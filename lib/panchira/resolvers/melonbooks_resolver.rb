# frozen_string_literal: true

module Panchira
  class MelonbooksResolver < Resolver
    URL_REGEXP = %r{melonbooks.co.jp/detail/detail.php\?product_id=(\d+)}.freeze

    private

    def parse_canonical_url
      product_id = @url.slice(URL_REGEXP, 1)
      'https://www.melonbooks.co.jp/detail/detail.php?product_id=' + product_id + '&adult_view=1'
    end

    def parse_description
      # スタッフの紹介文でidが分岐
      special_description = @page.xpath('//div[@id="special_description"]//p/text()')
      if special_description.any?
        special_description.first.to_s
      else
        description = @page.xpath('//div[@id="description"]//p/text()')
        description.first.to_s
      end
    end

    def parse_image_url
      @page.css('//meta[property="og:image"]/@content').first.to_s.sub(/&c=1/, '')
    end

    def parse_tags
      @page.css('#related_tags .clearfix').children.children.map(&:text)
    end
  end

  ::Panchira::Extensions.register(Panchira::MelonbooksResolver)
end
