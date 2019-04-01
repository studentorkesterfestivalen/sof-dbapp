module Formats
  class OrchestrasOverlappingFormat
    def column_names
      {
          :orch1 => 'Orkester 1',
          :amount => 'Antal krockande personer',
          :orch2 => 'Orkester 2',
          :names => 'Namn',
          :emails => 'Emails'
      }
    end

    def get_data(orchestra)
      overlap_names = Hash.new
      overlap_emails = Hash.new

      signups = orchestra.orchestra_signups

      signups.each do |signup|
        user_signups = signup.user.orchestra_signup
        if user_signups.count() > 1
          user_signups.each do |u_signup|
            if u_signup.orchestra.id != orchestra.id
              if !overlap_names.has_key?(u_signup.orchestra.name)
                overlap_names[u_signup.orchestra.name] = Array.new
                overlap_emails[u_signup.orchestra.name] = Array.new
              end
              overlap_names[u_signup.orchestra.name] << u_signup.user.name
              overlap_emails[u_signup.orchestra.name] << u_signup.user.email
            end
          end
        end
      end

      [overlap_names, overlap_emails]
    end

  end
end
