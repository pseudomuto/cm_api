# frozen_string_literal: true
describe CMAPI::Resources::Base do
  let(:subject) { described_class.new(json_fixture("resource.json")) }

  it "recursively defines attr accessors for all properties" do
    expect(subject.object.id).to eq(1)
    expect(subject.object.name).to eq("My Object")
    expect(subject.object.keys).to eq(%w(Key1 Key2 Key3))

    expect(subject.object.tags[0].label).to eq("Tag 1")
    expect(subject.object.tags[1].children).to eq([4, 5, 6])
  end

  context "when object contains camelCased keys" do
    let(:subject) do
      json = JSON.generate(keyName: { child: { subKey: "value" } })
      described_class.new(JSON.parse(json))
    end

    it "recursively converts them to snake_case for goodness' sake" do
      expect(subject.key_name.child.sub_key).to eq("value")
    end
  end
end
