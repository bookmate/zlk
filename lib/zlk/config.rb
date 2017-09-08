module Zlk
  class Config
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def use_fake_locks?
      !!hash['use_fake_locks'.freeze]
    end

    %w(hosts pool chroot connection_timeout).each do |config_key|
      define_method(config_key) do
        hash[config_key]
      end
    end
  end
end
