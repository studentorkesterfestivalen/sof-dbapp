namespace :assign_usergroups do
  desc 'waits for database connection'
  task update_cortege_leaders_usergroup: :environment do
    cortege_leaders = User.includes(:cortege).where(corteges: { approved: true} )
    cortege_leaders.each do |leader|
      case leader.cortege.cortege_type
        when 0
          #Macro
          leader.usergroup |= UserGroupPermission::CORTEGE_MACRO
         when 1
          #Micro
          leader.usergroup |= UserGroupPermission::CORTEGE_MICRO
        when 2
          #Freebuilt
          leader.usergroup |= UserGroupPermission::CORTEGE_FREEBUILD
        else
          #Casecortege
      end
      leader.usergroup |= UserGroupPermission::CORTEGE_MEMBER | UserGroupPermission::CORTEGE_LEADER
      leader.save!
    end
  end

  task update_funkis_usergroup: :environment do
    funkisar = User.includes(:funkis_application).where.not(funkis_applications: { terms_agreed_at: nil } )
    funkisar.each do |funkis|
      funkis.usergroup |= UserGroupPermission::FUNKIS
      funkis.save!
    end
  end

  task update_risk_smask_usergroup: :environment do
    smaskers = ['anders.ryden@gmail.com',
     'tahin_tino@hotmail.com',
     'gustav.aldin@gmail.com',
     'molle.olson@gmail.com',
     'annk.backman@telia.com',
     'kjell.rundqvist@sonat.se',
     'torbjorn.sterner@gmail.com',
     'elin.lindqvist77@googlemail.com',
     'stefan.f.nilsson@gmail.com',
     'erik.lindblad@gmail.com',
     'sofie.maag@gmail.com',
     'david@krantz.dk',
     'joakim@eljas.se',
     'fanny.ekblomjohansson@gmail.com',
     'bjola358@student.liu.se',
     'anders.norell.bergendahl@gmail.com',
     'larsson.c.johan@gmail.com',
     'elin.jakobsson@gmail.com',
     'oller120@student.liu.se',
     'karli315@student.liu.se',
     'perde191@student.liu.se',
     'bobosv+sof@gmail.com']

    smaskers.each do |smask|
      user = User.find_by email: smask
      if user.present?
        user.usergroup |= UserGroupPermission::RISK_SMASK
        user.save!
      end
    end
  end
end