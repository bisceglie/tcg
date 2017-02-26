module TwitterClient
    class Cache
      def initialize(limit=2, wait=15*60)
        @limit, @wait = limit, wait
        @store, @queue = {}, []
        @last_cached_at = 0
      end

      def cached(key, &block)
        if @store.keys.include?(key)
          @store[key]
        elsif can_cache? and block_given?
          add_to_cache(key, block.call)
        end
      end

      private
      def add_to_cache(key, val)
        eject_last_if_needed
        @queue = [key] + @queue
        @store[key] = val
        @last_cached_at = epoch_seconds
        val
      end
      def eject_last_if_needed
        if @store.keys.size >= @limit
          key = @queue.pop
          @store.delete(key)
        end
      end
      def can_cache?()
        @store.keys.size < @limit or !@last_cached_at or eject_allowed?
      end
      def eject_allowed?()
        epoch_seconds > (@last_cached_at + @wait)
      end
      def epoch_seconds()
        Time.new.to_i
      end
    end
end
