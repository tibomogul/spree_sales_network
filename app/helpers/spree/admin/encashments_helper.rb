module Spree
  module Admin
    module EncashmentsHelper
      # Renders all the extension partials that may have been specified in the extensions
      def event_links(encashment, events)
        links = []
        events.sort.each do |event|
          next unless encashment.send("can_#{event}?")
          label = Spree.t(event, scope: 'encashment.events', default: Spree.t(event))
          links << button_link_to(
            label.capitalize,
            [event, :admin, encashment],
            method: :put,
            data: { confirm: Spree.t(:encashment_sure_want_to, event: label) }
          )
        end
        safe_join(links, '&nbsp;'.html_safe)
      end
    end
  end
end