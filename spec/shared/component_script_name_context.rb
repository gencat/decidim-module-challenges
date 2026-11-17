# frozen_string_literal: true

# Controller specs run without the mount prefix of the component engine.
# When that happens, Rails builds the prefix from the last place the engine
# is mounted. With decidim-initiatives installed that is the initiatives
# mount, which needs an `initiative_slug` we don't have.
#
# This context sets the participatory process prefix both for the test
# request and for the URLs the controller generates (redirects).
#
# Usage: include_context "with component script name", :admin  # or :public
shared_context "with component script name" do |side|
  let(:component_script_name) do
    slug = component.participatory_space.slug
    if side == :admin
      "/admin/participatory_processes/#{slug}/components/#{component.id}/manage"
    else
      "/processes/#{slug}/f/#{component.id}"
    end
  end

  before do
    @original_default_url_options = routes.default_url_options.dup
    routes.default_url_options[:script_name] = component_script_name
    request.script_name = component_script_name
  end

  after do
    routes.default_url_options = @original_default_url_options
  end
end
