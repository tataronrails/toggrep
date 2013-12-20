require 'zeus/rails'

class CustomPlan < Zeus::Rails

  def test
    require 'factory_girl'
    FactoryGirl.reload
    Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
    super
  end

end

Zeus.plan = CustomPlan.new
