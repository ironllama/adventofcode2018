# Source: https://gist.github.com/brianstorti/e20300eb2e7d62b87849

class PriorityQueue
  attr_reader :elements

  def initialize(type = "max")
    @elements = [nil]  # This must be here as a placeholder, based on this implementation.
    @type = type
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  def pop
    exchange(1, @elements.size - 1) if @elements.length > 1  # Will add nil if only 1 left.
    max = @elements.pop
    bubble_down(1)
    max
  end

  private

  def bubble_up(index)
    parent_index = (index / 2)

    return if index <= 1
    return if (@type == "max" && @elements[parent_index] >= @elements[index]) ||
        (@type == "min" && @elements[parent_index] <= @elements[index])

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = (index * 2)

    return if child_index > @elements.size - 1

    not_the_last_element = child_index < @elements.size - 1
    left_element = @elements[child_index]
    right_element = @elements[child_index + 1]

    if @type == "max"
      child_index += 1 if not_the_last_element && right_element > left_element
      return if @elements[index] >= @elements[child_index]
    else
      child_index += 1 if not_the_last_element && right_element < left_element
      return if @elements[index] <= @elements[child_index]
    end

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end
end