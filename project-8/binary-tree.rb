class Node

	attr_accessor :value, :parent, :left_child, :right_child

	def initialize(value, parent = nil, left_child = nil, right_child = nil)
		@value = value
		@parent = parent
		@left_child = left_child
		@right_child = right_child
	end

	def to_s
		"#{@value} (L:#{@left_child}, R: #{@right_child})"
	end
end


class Tree

	attr_accessor :root

	def initialize(data_array)
		@data_array = data_array
		@root = Node.new(data_array[0], nil, nil, nil)
		build_tree(@root)
		@tree_data = traverse([], @root)
	end

	def build_tree(root)
		@tree_array = []
		@data_array[1..-1].each do |value|
			add_node(value, root)
		end
	end

	def add_node(value, ancestor)
		if value < ancestor.value
			if ancestor.left_child.nil?
				ancestor.left_child = Node.new(value)
				ancestor.left_child.parent = ancestor
			else
				add_node(value, ancestor.left_child)
			end
		elsif value >= ancestor.value
			if ancestor.right_child.nil?
				ancestor.right_child = Node.new(value)
				ancestor.right_child.parent = ancestor
			else
				add_node(value, ancestor.right_child)
			end
		else
			return ancestor
		end
	end

	def traverse(tree_array, ancestor)
		if ancestor.left_child.nil?
			tree_array << ancestor
		else
			traverse(tree_array, ancestor.left_child)
			traverse(tree_array, ancestor.right_child)
		end
		tree_array
	end

	def view_tree
		puts @tree_data
	end


	def breadth_first_search(search_value)
		queue = [@root]
		visited = []

		queue.each do |node|
			visited << node
			if node.value == search_value
				return node
			else
				queue << node.left_child unless node.left_child.nil? || visited.include?(node.left_child)
				queue << node.right_child unless node.right_child.nil? || visited.include?(node.right_child)
			end
		end
		nil
	end


	def depth_first_search(search_value)
		stack = [@root]
		visited = []


		while not stack.empty?
			node = stack.pop
			if node.value == search_value
				return node
			else
				stack << node.left_child unless node.left_child.nil? || visited.include?(node.left_child)
				stack << node.right_child unless node.right_child.nil? || visited.include?(node.right_child)
			end

		end
		nil
	end


	def dfs_rec(search_value, node)
		if node.nil?
			return nil
		elsif search_value == node.value
			return node
		else
			left = dfs_rec(search_value, node.left_child)
			return left if left
			right = dfs_rec(search_value, node.right_child)
			return right if right
		end
	end



end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

tree = Tree.new(arr)
# tree.view_tree

puts tree.dfs_rec(8, tree.root)