module Zlk
  module Lockable
    def lock_key
      suffix = if respond_to?(:id)
        id
      else
        respond_to?(:uuid) ? uuid : fail("Define #{self.class}#lock_key")
      end

      "#{self.class}-#{suffix}"
    end

    def run_exclusively
      lock.run_exclusively { yield }
    end

    def run_with_timeout!
      lock.with_timeout!(lock_timeout) { yield }
    end

    def lock_timeout
      10
    end

    def locked?
      !lock.acquirable?
    end

    def lock
      Zlk.create_lock(lock_key)
    end
  end
end
