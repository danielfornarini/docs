# frozen_string_literal: true

# Speed up RSpec by deferring garbage collection
# (Ref.: http://makandracards.com/makandra/950-speed-up-rspec-by-deferring-garbage-collection)

class DeferredGarbageCollection
  GC_THRESHOLD = (ENV['DEFER_GC'] || 10.0).to_f

  @@last_gc_run = Time.zone.now

  def self.start
    GC.disable if GC_THRESHOLD > 0
  end

  def self.reconsider
    if GC_THRESHOLD > 0 && Time.zone.now - @@last_gc_run >= GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @@last_gc_run = Time.zone.now
    end
  end
end

unless ENV['RSPEC_GARBAGE_COLLECTOR']
  RSpec.configure do |config|
    config.before(:all) do
      DeferredGarbageCollection.start
    end
    config.after(:all) do
      DeferredGarbageCollection.reconsider
    end
  end
end
