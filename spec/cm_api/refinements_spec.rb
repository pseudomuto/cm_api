# frozen_string_literal: true
describe CMAPI::Refinements do
  using CMAPI::Refinements

  class RefinedClass
    attr_reader :prop

    def initialize(prop)
      @prop = prop
    end
  end

  describe "Object refinements" do
    describe "#blank?" do
      it "is true when false, empty, or nil" do
        expect(RefinedClass.new(nil).prop.blank?).to be(true)
        expect(RefinedClass.new(false).prop.blank?).to be(true)
        expect(RefinedClass.new([]).prop.blank?).to be(true)
        expect(RefinedClass.new({}).prop.blank?).to be(true)
        expect(RefinedClass.new("").prop.blank?).to be(true)
      end

      it "is false when true, not empty or contains a value" do
        expect(RefinedClass.new(true).prop.blank?).to_not be(true)
        expect(RefinedClass.new(" ").prop.blank?).to_not be(true)
        expect(RefinedClass.new(1).prop.blank?).to_not be(true)
        expect(RefinedClass.new(0).prop.blank?).to_not be(true)
        expect(RefinedClass.new([:hash]).prop.blank?).to_not be(true)
        expect(RefinedClass.new(this: "is good").prop.blank?).to_not be(true)
      end
    end

    describe "#present?" do
      it "is true when blank? isn't" do
        expect(RefinedClass.new(true).prop.present?).to be(true)
        expect(RefinedClass.new(" ").prop.present?).to be(true)
        expect(RefinedClass.new(1).prop.present?).to be(true)
        expect(RefinedClass.new(0).prop.present?).to be(true)
        expect(RefinedClass.new([:hash]).prop.present?).to be(true)
        expect(RefinedClass.new(this: "is good").prop.present?).to be(true)
      end
    end
  end
end
