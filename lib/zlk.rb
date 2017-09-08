require "erb"
require "yaml"
require "zlk/version"

module Zlk
  class << self
    attr_accessor :mutex
    Zlk.mutex = Mutex.new

    def create_lock(path)
      if config.use_fake_locks?
        NullLock.new
      else
        Lock.new(path)
      end
    end

    # Lazy initialization
    def connection_pool
      return @connection_pool if @connection_pool

      mutex.synchronize do
        hosts = config.hosts.join(',')

        @connection_pool = ZK::Pool::Simple.new(
          hosts,
          config.pool,
          chroot: config.chroot,
          timeout: config.connection_timeout,
          ephemeral: true
        )
      end

      @connection_pool
    end

    def config_file=(filepath)
      @config_file = filepath
      @config = nil
    end

    def config_file
      @config_file
    end

    def config
      @config ||= begin
        yaml = ERB.new(File.read(config_file)).result
        hash = YAML.load(yaml)
        Zlk::Config.new(hash[Rails.env]) if hash
      end
    end
  end
end

require "zlk/config"
require "zlk/lock"
require "zlk/null_lock"
require "zlk/lockable"
