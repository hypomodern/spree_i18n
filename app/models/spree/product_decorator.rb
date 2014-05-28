module Spree
  Product.class_eval do
    translates :name, :description, :meta_description, :meta_keywords, :slug,
      :fallbacks_for_empty_translations => true
    include SpreeI18n::Translatable

    def duplicate_extra(old_product)
      duplicate_translations(old_product)
      set_slug_via_hack_to_avoid_duplication(old_product)
    end

    private

    def duplicate_translations(old_product)
      old_product.translations.each do |translation|
        self.translations << translation.dup
      end
    end

    def set_slug_via_hack_to_avoid_duplication(old_product)
      self.slug = "#{old_product.slug}-#{SecureRandom.uuid}"
    end
  end
end
