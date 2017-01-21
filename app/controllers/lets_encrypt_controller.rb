class LetsEncryptController < ApplicationController
  def challenge
    if params[:id] == key
      render plain: challenge_hash
    else
      render nothing: true, status: 404
    end
  end

  def key
    unless challenge_hash.nil?
      challenge_hash.split('.')[0]
    end
  end

  def challenge_hash
    ENV['LETSENCRYPT_CHALLENGE']
  end
end
