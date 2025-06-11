require 'sinatra/base'
require 'redis'

class Server < Sinatra::Base
  redis = Redis.new(
    url: ENV['REDIS_URL'] || 'redis://localhost:6379',
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  )
  get "/results" do
    results = {}
    ["Babies Dancing", "Artis Dances", "La Carioca", "Le Télékinésien", "La Chanson du Croissant", "Les Barbarèsques", "Les bras de Béyoncé", "Eli Kakou", "Les fairy star"].each_with_index do |talent, index|
      results[talent] = redis.get("count:#{index + 1}").to_i
    end
    return results.to_json
  end

  post '/message' do
    from = params['From']
    vote = params['Body'].strip.to_i
    # vote incorrect
    if vote < 1 || vote > 9
      return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<Response>
    <Message>Votre vote est inccorect, merci d'envoyer uniquement le nombre associé à votre talent préféré</Message>
</Response>"
    end
    previous_vote = redis.get("voters:#{from}")
    # nouveau vote
    if previous_vote.nil?
      redis.set("voters:#{from}", vote.to_s)
      redis.incr("count:#{vote}")
      return '<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Message>Votre vote pour Les Incroyables Parents de Sainte Marie a été pris en compte! Merci et bonne soirée</Message>
</Response>'
    end
    # déja voté ?
    if previous_vote == vote.to_s
      return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<Response>
    <Message>Votre vote est déjà pris en compte</Message>
</Response>" 
    end
    if previous_vote != vote.to_s
      redis.decr("count:#{previous_vote}")
      redis.incr("count:#{vote}")
      redis.set("voters:#{from}", vote.to_s)
      return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<Response>
    <Message>Bien reçu, votre vote à été mis à jour !</Message>
</Response>" 
    end
    return '<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Message>Votre vote pour les incroyables parents de Sainte Marie a été pris en compte! Merci et bonne soirée</Message>
</Response>'
  end
end
