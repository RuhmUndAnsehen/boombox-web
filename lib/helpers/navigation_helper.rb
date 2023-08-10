# frozen_string_literal: true

require_relative 'navigation_builder'

module Helpers
  ##
  # Provides an interface to generate a +nav+ tag and contents.
  module NavigationHelper
    ##
    # Generates a +nav+ tag and yields a NavigationBuilder.
    #
    # ==== Example
    #     <%= nav_tag class: 'site-nav' do |nav| %>
    #       <%= nav.bar do |nav| %>
    #         <%= nav.item link_to(site_logo, root_path), class: 'root-link' %>
    #         <%= nav.item 'Category 1', class: 'cat1' do |nav| %>
    #           <%= nav.menu do |nav| %>
    #             <%= nav.item 'Link 1', link1_path %>
    #             <%= nav.item 'Link 2', link2_path %>
    #           <% end %>
    #         <% end %>
    #         <%= nav.item class: 'cat2' do |nav| %>
    #           <%= nav.link_to 'Category 2', cat2_path %>
    #           <%= nav.menu do |nav| %>
    #             <%= nav.item 'Link 3', link3_path %>
    #             <%= nav.item 'Link 4', link4_path %>
    #           <% end %>
    #         <% end %>
    #         <%= nav.item do |nav| %>
    #           <a href="http://example.com">External Link</a>
    #         <% end %>
    #       <% end %>
    #     <% end %>
    #     # =>
    #     # <nav class="site-nav">
    #     #   <ul class="nav-bar">
    #     #     <li class="nav-item root-link">
    #     #       <a href="/"><img src="logo.png" alt="Site logo" /></a>
    #     #     </li>
    #     #     <li class="nav-item cat1">
    #     #       <span>Category 1</span>
    #     #       <ul class="nav-menu">
    #     #         <li class="nav-item">
    #     #           <a href="link1">Link 1</a>
    #     #         </li>
    #     #         <li class="nav-item">
    #     #           <a href="link2">Link 2</a>
    #     #         </li>
    #     #       </ul>
    #     #     </li>
    #     #     <li class="nav-item cat2">
    #     #       <a href="/cat2">Category 2</a>
    #     #       <ul class="nav-menu">
    #     #         <li class="nav-item">
    #     #           <a href="link3">Link 3</a>
    #     #         </li>
    #     #         <li class="nav-item">
    #     #           <a href="link4">Link 4</a>
    #     #         </li>
    #     #       </ul>
    #     #     </li>
    #     #     <li class="nav-item">
    #     #       <a href="https://example.com">External Link</a>
    #     #     </li>
    #     #   </ul>
    #     # </nav>
    def navigation(**opts, &block)
      NavigationBuilder.new(self).nav_tag(opts, &block)
    end
    alias nav_tag navigation
  end
end
