# Fix for https://github.com/studentorkesterfestivalen/sof-webapp/issues/53

module OmniAuth
  module Strategies
    class CAS

      private

      # Overridden to correctly filter LiU-IDs.
      # NOTE: Overriding private methods is not recommended.
      # TODO: Find a safer solution to this problem.
      def prune!(hash)
        hash.delete_if do |key, value|
          if is_liu_id? key, value
            fix_liu_id! value
          end

          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def fix_liu_id!(value)
        value.strip!
        value.downcase!
      end

      def is_liu_id?(key, value)
        key == 'user' and value.is_a?(String)
      end
    end
  end
end