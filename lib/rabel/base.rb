module Rabel::Base
  def self.make_mention_links(text)
    text.gsub(Comment::MENTION_REGEXP) do
      if $1.present?
        %(@<a href="/member/#{$1}">#{$1}</a>)
      else
        "@#{$1}"
      end
    end
  end

  class Render < Redcarpet::Render::HTML
    def block_code(code, language)
      code = code.gsub("&lt;", '<').gsub("&gt;", '>').gsub("&quot;", '"').gsub("&amp;", "&")
      result = CodeRay.scan(code, language).div(:tab_width => 2).sub("\n", '')
      i = result.rindex("\n")
      result = result[0..i-1] + result[i+1..-1]
      result.gsub("\n", "<br/>")
    end

    def normal_text(text)
      return unless text.present?
      Rabel::Base.make_mention_links(text)
    end
  end
end
