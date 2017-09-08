module Zlk
  class NullLock
    def run_exclusively
      yield
    end

    def with_timeout(timeout)
      yield(true)
    end

    def with_timeout!(timeout)
      yield
    end

    def acquirable?
      true
    end
  end
end
