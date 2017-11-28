module Aloha
  module LoggedModel
    extend ActiveSupport::Concern

    included do
      after_create :log_create_to_stdout
      after_update :log_update_to_stdout
      before_destroy :log_delete_to_stdout
    end

    module ClassMethods
      def logger
        @logger ||= Logger.new(STDOUT)
        @logger.level = Logger::INFO
      end
    end

    def log_create_to_stdout
      logger.info("Created #{self.class.name}: #{self.to_json}")
    end

    def log_update_to_stdout
      logger.info("Updated #{self.class.name}: #{self.to_json}")
    end

    def log_delete_to_stdout
      logger.info("Deleting #{self.class.name}: #{self.to_json}")
    end
  end
end