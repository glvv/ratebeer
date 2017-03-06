class TestJob
  include SuckerPunch::Job

  def perform
    puts "running job..."
  end
end
