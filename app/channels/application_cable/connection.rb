module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_resource

    def connect
      set_current_resource || reject_unauthorized_connection
    end

    private
      def set_current_resource
        if session = Session.find_by(id: cookies.signed[:session_id])
          self.current_resource = session.resource
        end
      end
  end
end
