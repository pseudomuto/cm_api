# frozen_string_literal: true
describe CMAPI::Resource do
  let(:subject) { described_class.new(json_fixture("resource.json")) }

  it "recursively defines attr accessors for all properties" do
    expect(subject.object.id).to eq(1)
    expect(subject.object.name).to eq("My Object")
    expect(subject.object.keys).to eq(%w(Key1 Key2 Key3))

    expect(subject.object.tags[0].label).to eq("Tag 1")
    expect(subject.object.tags[1].children).to eq([4, 5, 6])
  end
end
