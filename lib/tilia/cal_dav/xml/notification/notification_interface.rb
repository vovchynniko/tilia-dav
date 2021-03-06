module Tilia
  module CalDav
    module Xml
      module Notification
        # This interface reflects a single notification type.
        #
        # @copyright Copyright (C) 2007-2015 fruux GmbH (https://fruux.com/).
        # @author Evert Pot (http://evertpot.com/)
        # @license http://sabre.io/license/ Modified BSD License
        module NotificationInterface
          include Tilia::Xml::XmlSerializable

          # This method serializes the entire notification, as it is used in the
          # response body.
          #
          # @param Writer writer
          # @return void
          def xml_serialize_full(writer)
          end

          # Returns a unique id for this notification
          #
          # This is just the base url. This should generally be some kind of unique
          # id.
          #
          # @return string
          def id
          end

          # Returns the ETag for this notification.
          #
          # The ETag must be surrounded by literal double-quotes.
          #
          # @return string
          def etag
          end
        end
      end
    end
  end
end
