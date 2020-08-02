require 'spec_helper'
require 'opal/sprockets/erb'

describe Opal::ERB::Processor do
  let(:pathname) { Pathname("/Code/app/mylib/opal/foo.#{ext}") }
  let(:environment) { double(Sprockets::Environment,
    cache: nil,
    :[] => nil,
    resolve: pathname.expand_path.to_s,
    mime_types: {},
  ) }
  let(:sprockets_context) { double(Sprockets::Context,
    logical_path: "foo.#{ext}",
    environment: environment,
    pathname: pathname,
    filename: pathname.to_s,
    root_path: '/Code/app/mylib',
    is_a?: true,
  ) }
  let(:required_assets) { [] }
  let(:template) { described_class.new { |t| %Q{<% print("") %><a href="<%= url %>"><%= name %></a>} } }
  before { allow(sprockets_context).to receive(:require_asset) {|asset| required_assets << asset } }

  let(:ext) { 'opalerb' }

  it "is registered for '.opalerb' files" do
    expect(Tilt["test.#{ext}"]).to eq(described_class)
  end

  it 'renders the template' do
    expect(template.render(sprockets_context)).to include('"<a href=\""')
  end

  it 'implicitly requires "erb"' do
    template.render(sprockets_context)
    expect(required_assets).to eq(['erb'])
  end
end
