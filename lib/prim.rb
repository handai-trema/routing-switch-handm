# Finds shortest path.
class Prim
  # Graph node
  class Node
    attr_reader :name
    attr_reader :neighbors
    attr_reader :distance
    attr_reader :prev

    def initialize(name, neighbors)
      @name = name
      @neighbors = neighbors
      @distance = rand(100) + 1
      @prev = nil
    end

    def maybe_update_distance_and_prev(min_node)
      new_distance = min_node.distance + 1
      return if new_distance > @distance
      @distance = new_distance
      @prev = min_node
    end
    
    def distance=(new_distance)
      fails if new_distance < 0
      @distance = new_distance
    end

    def <=>(other)
      @distance <=> other.distance
    end
    
    def set_prev(prev)
      @prev = prev
    end
  end

  # Sorted list.
  # TODO: Replace with heap.
  class SortedArray
    def initialize(array)
      @array = []
      array.each { |each| @array << each }
      @array.sort!
    end

    def method_missing(method, *args)
      result = @array.__send__ method, *args
      @array.sort!
      result
    end
  end

  def initialize(graph)
    #puts "Prim.initialize()"
    @all = graph.map { |name, neighbors| Node.new(name, neighbors) }	#All nodes
    #@all.each{|each| puts "#{each.name}\t#{each.class}" }
    puts @all[0].neighbors[0].class
    @unvisited = SortedArray.new(@all)
    @undecided_nodes = []
    for node in @all do
      @undecided_nodes.append(node.name)
    end
    #@undecided_nodes.each{|each| puts "#{each.neighbors.class}" }
    @decided_nodes = []
  end

  def run(start, goal)
    #puts "Prim.run()"
    start_node = find(start, @all)
    @undecided_nodes.delete(start_node.name)
    @decided_nodes.append(start_node.name)
    #puts "Start node: #{start_node.name}\t#{start_node.class}:"
    #Create Min tree.
    while 0 < @undecided_nodes.length do
	    #Search neighbor.
	    neighbor = nil
	    break_switch = false
	    for focused_node_name in @decided_nodes do
		    focused_node = find(focused_node_name, @all)
		    #puts "Focused node: #{focused_node_name}\t#{focused_node.class}:"
		    focused_node.neighbors.each do |each|
		      neighbor = find(each, @all)
		      #puts "\t#{neighbor.name}\t#{neighbor.class}\t#{neighbor.distance}"
		      if neighbor != nil  and  @undecided_nodes.include?(neighbor.name) == true  then
			#puts "Add #{neighbor.name}\t#{neighbor.class}\t#{neighbor.distance}"
			neighbor.set_prev(focused_node)
			break_switch = true
			break
		      end
		    end
		   if break_switch == true then
		     break
		   end
	    end
	    @undecided_nodes.delete(neighbor.name)
	    @decided_nodes.append(neighbor.name)
    end
    result = path_to(goal)
    result.include?(start) ? result : []
    
    res = Html.new().update(result,@all)

  end

  private

  # This method smells of :reek:FeatureEnvy but ignores them
  # This method smells of :reek:DuplicateMethodCall but ignores them
  def path_to(goal)
    [find(goal, @all)].tap do |result|
      result.unshift result.first.prev while result.first.prev
    end.map(&:name)
  end

  def find(name, list)
    found = list.find { |each| each.name == name }
    fail "Node #{name.inspect} not found" unless found
    found
  end
end
