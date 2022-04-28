namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      showSpinner("Apagando Banco de dados ..." ) { %x(rails db:drop)}
      showSpinner("Criando Banco de dados ..." ) {%x(rails db:create) }
      showSpinner("Criando tabelas do Banco de dados ..." ) {%x(rails db:migrate)}
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else
      puts "Você não esta em ambiente de desenvolvimento!"
    end
  end

  desc "Cadastra Moedas"
  task add_coins: :environment do
    showSpinner("Populando Banco de dados ..." ) do
      coins = [
        {
            description: "Bitcoin",
            acronym: "BTC",
            url_image: "https://e7.pngegg.com/pngimages/261/204/png-clipart-bitcoin-bitcoin-thumbnail.png",
            mining_type: MiningType.find_by(acronym: 'PoW')
        },

        {   description: "Ethereum",
            acronym: "ETH",
            url_image: "https://w7.pngwing.com/pngs/368/176/png-transparent-ethereum-cryptocurrency-blockchain-bitcoin-logo-bitcoin-angle-triangle-logo-thumbnail.png",
            mining_type: MiningType.all.sample()
        },
        {   description: "Dash",
            acronym: "DASH",
            url_image: "https://pngset.com/images/dash-coin-logo-symbol-text-screen-transparent-png-1794598.png",
            mining_type: MiningType.all.sample()
        }
      ]

      coins.each do |coin| 
          Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra Tipos de Mineração"
    task add_mining_types: :environment do
      showSpinner("Populando Banco de dados ..." ) do
        mining_types = [
          {description: "Proof of Work", acronym: "PoW"},
          {description: "Proof of Steak", acronym: "PoS"},
          {description: "Proof of Capacity", acronym: "PoC"}
        ]
      
        mining_types.each do |mining_type| 
          MiningType.find_or_create_by!(mining_type)
        end
      end
    end
  private

  def showSpinner(msg_start, msg_end='Concluido')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :dots)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
