require 'spec_helper'

module Spree
  describe Product do
    let(:product) { FactoryGirl.create(:product, name: "Clone Me Plz") }

    # Regression test for #309
    it "duplicates translations" do
      original_count = product.translations.count
      new_product = product.duplicate
      new_product.translations.should_not be_blank
      product.reload
      product.translations.count.should == original_count
    end

    # It appears as though spree_i18n is updating the original item on clone
    it "should not update the original item during clone" do
      new_product = product.duplicate
      product.reload
      new_product.name.should == "COPY OF #{product.name}"
      product.name.should == "Clone Me Plz"
      new_product.name.should_not == product.name
    end

    it "doesn't screw up duplicating items with slugs" do
      product = FactoryGirl.create(:product)
      new_product = product.duplicate
      product.reload

      new_product.slug.should_not == product.slug
    end
  end
end