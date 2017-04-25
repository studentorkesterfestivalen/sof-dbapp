namespace :funkis do
  desc 'wait for database connection'
  task give_funkisar_their_accrued_points: :environment do
    funkisar = User.where.not(rebate_given: nil).includes(:funkis_application).where.not(funkis_applications: { terms_agreed_at: nil} )

    funkisar.each do |funkis|
      total_points = calculate_accrued_funkis_points funkis.funkis_application
      rebate = points_to_rebate total_points

      unless funkis.rebate_given
        funkis.rebate_balance = rebate
        funkis.rebate_given = true
        funkis.save
      end
    end
  end

  task remove_points_from_zazus: :environment do
    funkisar = User.where.not(rebate_given: nil).includes(:funkis_application).where.not(funkis_applications: { terms_agreed_at: nil})

    funkisar.each do |funkis|
      funkis.funkis_applications.each do |application|
        if name_is_zazu application.funkis_shift_application.funkis_shift.funkis_category
          if funkis.rebate_given
            funkis.rebate_balance = 0
            funkis.save
          end
        end
      end
    end
  end

  def name_is_zazu category
    category.name == 'Zazu'
  end

  def points_to_rebate(points)
    case points
      when 50
        60
      when 100
        150
      when 150
        240
      else
        0
    end
  end

  def calculate_accrued_funkis_points(application)
    total_points = 0
    application.funkis_shift_applications.each do |shift|
      total_points += shift.funkis_shift.points
      if total_points > 150
        total_points = 150
      end
    end
    total_points
  end
end