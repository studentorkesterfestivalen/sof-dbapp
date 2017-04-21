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
    application.presale_choice = FunkisApplication::PRESALE_MH

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

  test 'application creation when two users want the same last shift' do
    first = prepare_application
    second = prepare_application
    assert first.save
    assert second.save

    # Both user selects same shift with limit=1
    shift = FunkisShiftApplication.new
    shift.funkis_shift = funkis_shifts(:four)
    first.funkis_shift_applications.push shift
    assert first.save

    shift = FunkisShiftApplication.new
    shift.funkis_shift = funkis_shifts(:four)
    second.funkis_shift_applications.push shift
    assert second.save

    # Reload attributes and associations in applications from database (more similar to real use)
    first.reload
    second.reload

    # First user completes signup successfully
    first.terms_agreed_at = DateTime.now
    assert first.save

    # Second user is unable to complete signup
    second.terms_agreed_at = DateTime.now
    assert_not second.save
  end

  test 'destroying applications remove their shift applications' do
    application = prepare_application

    shift = FunkisShiftApplication.new
    shift.funkis_shift = funkis_shifts(:one)
    application.funkis_shift_applications.push shift
    assert application.save

    assert_equal 1, FunkisShiftApplication.count

    application.destroy!

    assert_equal 0, FunkisShiftApplication.count
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
