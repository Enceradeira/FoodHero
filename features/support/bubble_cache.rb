class BubbleCache
  def initialize(driver)
    @driver = driver
    @bubbles = []
  end

  def bubbles
    bubbles = @driver.find_elements :xpath, '//UIATableCell'
    # only update @bubbles when drivers returns more elements than before (sometimes it just doesn't return all elements)
    @bubbles = bubbles unless @bubbles.length > bubbles.length
    @bubbles
  end

  def reset
    @bubbles = []
  end
end