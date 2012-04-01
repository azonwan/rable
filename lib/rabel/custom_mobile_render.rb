# Custom render with syntax highlight and mentions
module Rabel
  class CustomMobileRender < Rabel::Base::Render
    def normal_text(text)
      t = super(text)
      t.gsub("\r", '').gsub("\n", "<br/>") if t.present?
    end

    def image(link, title, alt_text)
      %(<a href="#{link}">#{link}</a>)
    end
  end
end
