module FactoryGirl
  module Strategy
    class Cache
      # :nocov:
      def association(runner)
        runner.run(:cache)
      end
      # :nocov:

      def result(evaluation)
        repository.read(evaluation) || repository.store(evaluation)
      end

      protected

      def repository
        Repository.instance
      end
    end

    class Repository
      include Singleton

      def initialize
        recycle!
      end

      def recycle!
        @repository = Hash.new { |hash, key| hash[key] = {} }
      end

      def read(evaluation)
        repository[evaluation.object.class][
          evaluation.object.attributes.reject do |key|
            ['encrypted_password', 'password_salt'].include?(key)
          end
        ]
      end

      def store(evaluation)
        repository[evaluation.object.class][
          evaluation.object.attributes.reject do |key|
            ['encrypted_password', 'password_salt'].include?(key)
          end
        ] = evaluation.object.tap do |object|
          evaluation.notify(:after_build, object)
          evaluation.notify(:before_create, object)
          evaluation.create(object)
          evaluation.notify(:after_create, object)
        end
      end

      protected

      attr_reader :repository
    end
  end
end

FactoryGirl.register_strategy(:cache, FactoryGirl::Strategy::Cache)
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.after do
    FactoryGirl::Strategy::Repository.instance.recycle!
  end
end
