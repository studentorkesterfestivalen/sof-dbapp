module Formats
  class FunkisSummaryFormat
    def column_names
      {
          :name => 'Kategori',
          :funkis_name => 'Funkisnamn',
          :points => 'Poäng',
          :date => 'Datum',
          :day => 'Dag',
          :time => 'Tid',
          :total_applications => 'Antal anmälda',
          :red_limit => 'Röd gräns',
          :yellow_limit => 'Gul gräns',
          :green_limit => 'Grön gräns',
          :applicants => 'Anmälda Funkisar',
      }
    end

    def data_for(item, column)
      value_for(item, column)
    end

    def extra_row
      nil
    end


    private

    def value_for(item, column)
      case column
        when :name
          item.funkis_category.name
        when :funkis_name
          item.funkis_category.funkis_name
        when :total_applications
          counter = 0
          item.funkis_shift_applications.each do |shift_application|
            application = FunkisApplication.where(:id => shift_application.funkis_application_id).first
            if application.terms_agreed_at.not.nil?
              counter += 1
            end
          end
          counter
        when :applicants
          applicants = ''
          item.funkis_shift_applications.each do |shift_application|
            application = FunkisApplication.where(:id => shift_application.funkis_application_id).first
            if application.terms_agreed_at.not.nil?
              applicants += format_applicant get_applicant(application)
            end
          end
          applicants
        else
          item.send(column)
      end
    end

    def yes_no(value)
      value ? 'Ja' : 'Nej'
    end

    def format_applicant(applicant)
      "#{applicant[:name]}, #{applicant[:email]}, #{applicant[:phone]}, T-shirt: #{applicant[:tshirt]}, Körkort: #{applicant[:drivers_license]}, Hoben: #{applicant[:presale_choice]}, Allergier: #{applicant[:allergies]} \n"
    end


    def get_applicant(application)
      applicant = User.where(:id => application.user_id).first
      {
          :name => applicant.display_name,
          :email => applicant.email,
          :phone => application.phone,
          :tshirt => application.tshirt_size,
          :drivers_license => yes_no(application.drivers_license),
          :presale_choice => yes_no(application.presale_choice),
          :allergies => application.allergies,
      }
    end
  end
end