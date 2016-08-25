# frozen_string_literal: true
def fixture(name)
  IO.binread(File.join("spec", "fixtures", name))
end

def json_fixture(name)
  JSON.parse(fixture(name))
end
