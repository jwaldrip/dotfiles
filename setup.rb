#!/usr/bin/env ruby

require 'net/http'
require 'net/https'
require 'json'
require 'io/console'
require 'pp'

class GithubToken < String
  URL = URI.parse'https://api.github.com/'

  class RequestError < StandardError
    def initialize(response)
      super(JSON.parse(response.body)['message'])
    end
  end

  LoginError = Class.new RequestError
  MissingOneTimePasswordError = RequestError

  def initialize
    @attempts = 0
    super(fetch)
  end

  private

  def connection
    Net::HTTP.new(URL.host, URL.port).tap { |conn| conn.use_ssl = URL.scheme == 'https' }
  end

  def ask(question, silent: false)
    puts question
    result = silent ? STDIN.noecho(&:gets) : gets
    result.strip
  end

  def get_password
    ask "Enter github password:", silent: true
  end

  def get_username
    ask "Enter github username:"
  end

  def get_otp
    ask "Enter two-factor-auth code:"
  end

  def fetch(username: get_username, password: get_password, tfa: false)
    request = Net::HTTP::Post.new('/authorizations')
    request['X-GitHub-OTP'] = get_otp if tfa
    request.basic_auth username, password
    request.body = JSON.dump scopes: ['repo'], note: "setup #{Time.now.to_i}"
    response = connection.request request
    if response.code.to_i == 401
      error = response['x-github-otp'] && !tfa ? MissingOneTimePasswordError : LoginError
      fail error, response
    end
    fail RequestError, response unless response.code.to_i < 300
    JSON.parse(response.body)['token']
  rescue LoginError => e
    @attempts += 1
    @attempts > 3 ? raise(e) : warn(e)
    warn "#{@attempts} failed attempts"
    fetch
  rescue MissingOneTimePasswordError => e
    warn e
    fetch(username: username, password: password, tfa: true)
  end

end

class SetupEnv

  def self.start
    new.start
  end

  def start
    init_homedir
    install_homebrew
    install_cask
    system 'brew bundle'
    system 'rbenv install -s'
    system 'rbenv global ' + File.read('.ruby-version')
  end

  private

  def clone_private
    return if File.exist? '.private/.ssh'
    system "git clone https://jwaldrip:#{token}@github.com/jwaldrip/.private"
    system 'chmod 400 ~/.ssh/id_dsa'
    system 'chmod 400 ~/.ssh/id_rsa'
    system 'git submodule update --init --recursive'
    system 'chsh -s /bin/zsh'
    puts "open a new shell"
  end

  def init_homedir
    unless `git remote -v`.include? 'jwaldrip/environment.git'
      system 'git init && git remote add origin https://github.com/jwaldrip/environment.git'
    end
    unless `git rev-parse --abbrev-ref HEAD`.strip == 'home'
      system 'git checkout --force home'
    end
  end

  def install_cask
    return if system 'brew --prefix cask'
    system 'brew install caskroom/cask/brew-cask'
    system 'brew cask'
  end

  def install_homebrew
    system 'ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"' unless system 'which brew &> /dev/null'
    system 'mkdir -p /usr/local/include && sudo chown `whoami` /usr/local/include'
    system 'mkdir -p /usr/local/lib && sudo chown `whoami` /usr/local/lib'
    system 'mkdir -p /usr/local && sudo chown `whoami` /usr/local/lib'
  end

  def token
    @token ||= GithubToken.new
  end

end

SetupEnv.start

