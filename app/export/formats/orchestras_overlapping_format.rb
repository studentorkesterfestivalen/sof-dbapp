module Formats
  class OrchestrasOverlappingFormat
    def column_names
      {
          :orch1 => 'Orkester 1',
          :amount => 'Antal krockande personer',
          :orch2 => 'Orkester 2',
      }
    end

    def get_data(orchestra)
      overlaps = Hash.new

      signups = orchestra.orchestra_signups

      signups.each do |signup|
        user_signups = signup.user.orchestra_signup
        if user_signups.count() > 1
          user_signups.each do |u_signup|
            if u_signup.orchestra.id != orchestra.id
              if !overlaps.has_key?(u_signup.orchestra)
                overlaps[u_signup.orchestra.name] = 0
              end
              overlaps[u_signup.orchestra.name] += 1
            end
          end
        end
      end

      overlaps
    end

  end
end
