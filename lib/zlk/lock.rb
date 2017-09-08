module Zlk
  class Lock
    LockWaitTimeoutError = Class.new(StandardError)

    attr_reader :path

    def initialize(path)
      @path = sanitize_path(path)
    end

    def run_exclusively
      with_locker do |locker|
        locker.with_lock(wait: true) { yield }
      end
    end

    def with_timeout(timeout)
      with_locker do |locker|
        begin
          locker.with_lock(wait: timeout) { yield(true) }
        rescue ZK::Exceptions::LockWaitTimeoutError => e
          yield(false)
        end
      end
    end

    def with_timeout!(timeout)
      with_timeout(timeout) do |locked|
        if locked
          yield
        else
          fail Zlk::Lock::LockWaitTimeoutError
        end
      end
    end

    def acquirable?
      with_locker do |locker|
        locker.acquirable?
      end
    end

    private

    def with_locker
      Zlk.connection_pool.with_connection do |connection|
        locker = connection.locker(path)
        yield(locker)
      end
    end

    # NOTE: it can be reimplemented really precisely (https://github.com/apache/zookeeper/blob/release-3.5.2/src/java/main/org/apache/zookeeper/common/PathUtils.java#L43-L102)
    # but simple is better. Leave only word characters and substitute the rest with an underscore
    def sanitize_path(path)
      I18n.transliterate(path).scan(/\w+/).join('_')
    end
  end
end
