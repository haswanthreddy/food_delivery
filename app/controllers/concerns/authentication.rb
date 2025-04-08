module Authentication
  extend ActiveSupport::Concern


  private

  def authenticated?
    resume_session
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    p "session ? ---------- #{Current.session.inspect}"
    Current.session ||= find_session_by_cookie

    p "Current.session ---------- #{Current.session.inspect}"

    Current.session
  end

  def find_session_by_cookie
    p "find_session_by_cookie ---------- #{cookies.signed[:session_id]}"

    Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end

  def request_authentication
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      p session
      p "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
      Current.session = session
      p "Current.session ------------------------- #{Current.session.inspect}"
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    Current.session.destroy
    cookies.delete(:session_id)
  end
end
