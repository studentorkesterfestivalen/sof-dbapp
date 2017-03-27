require 'test_helper'

class FunkisApplicationTest < ActiveSupport::TestCase
  test 'application process' do
    application = FunkisApplication.new

    assert application.ready_for_step? 1
    assert_not application.ready_for_step? 2
    assert_not application.save

    application.ssn = '900101-0101'
    application.phone = '013176800'
    application.tshirt_size = 'Female XS'
    application.allergies = 'Jordnötter'
    application.drivers_license = true
    application.presale_choice = FunkisApplication::PRESALE_NONE

    assert application.ready_for_step? 2
    assert_not application.ready_for_step? 3
    assert application.save

    shift = FunkisShiftApplication.new
    shift.funkis_shift = funkis_shifts(:one)

    application.funkis_shift_applications.push shift

    assert application.ready_for_step? 3
    assert_not application.ready_for_step? 4
    assert application.save

    application.terms_agreed_at = DateTime.now

    assert application.ready_for_step? 4
    assert application.save

    # Ensure already completed application cannot be updated
    assert_not application.save
  end

  test 'shift limit' do
    application = prepare_application
    assert application.save

    work_shift = funkis_shifts(:three)

    # Fill up first limit
    (1..work_shift.red_limit).each do
      shift = FunkisShiftApplication.new
      shift.funkis_shift = funkis_shifts(:three)
      application.funkis_shift_applications.push shift

      assert application.save
    end

    # Attempt to exceed limit
    shift = FunkisShiftApplication.new
    shift.funkis_shift = funkis_shifts(:three)
    application.funkis_shift_applications.push shift

    # ...and expect to fail
    assert_not application.save
  end

  private

  def prepare_application
    application = FunkisApplication.new
    application.ssn = '900101-0101'
    application.phone = '013176800'
    application.tshirt_size = 'Female XS'
    application.allergies = 'Jordnötter'
    application.drivers_license = true
    application.presale_choice = FunkisApplication::PRESALE_NONE
    application
  end
end
