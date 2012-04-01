module Notifiable
  def self.included(base)
    ['title', 'path'].each do |m|
      notifiable_callback = "notifiable_#{m}"
      base.class_eval <<-CODE
        def #{notifiable_callback}
          raise "Notifiable model should define instance method: #{notifiable_callback}"
        end
      CODE
    end
  end
end
